import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import '../models/book.dart';

class DatabaseService {
  static const String boxName = 'books_box';
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BookAdapter());
    }
    await Hive.openBox<Book>(boxName);
  }

  Box<Book> get _box => Hive.box<Book>(boxName);

  List<Book> getAllBooks() {
    return _box.values.toList();
  }

  List<Book> getWishlist() {
    return _box.values.where((book) => book.isWishlist).toList();
  }

  Future<void> addBook(Book book) async {
    await _box.add(book);
  }

  Future<void> updateBook(int index, Book book) async {
    await _box.putAt(index, book);
  }

  Future<void> deleteBook(int index) async {
    await _box.deleteAt(index);
  }

  Future<String> backupData() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final hiveDir = appDocDir;

    final archive = Archive();

    // Backup Hive files
    final boxFile = File(p.join(hiveDir.path, '$boxName.hive'));
    if (await boxFile.exists()) {
      final bytes = await boxFile.readAsBytes();
      archive.addFile(ArchiveFile('$boxName.hive', bytes.length, bytes));
    }

    // Backup images folder
    final imagesDir = Directory(p.join(appDocDir.path, 'images'));
    if (await imagesDir.exists()) {
      final List<FileSystemEntity> entities = await imagesDir.list().toList();
      for (final entity in entities) {
        if (entity is File) {
          final bytes = await entity.readAsBytes();
          final fileName = p.basename(entity.path);
          archive.addFile(ArchiveFile('images/$fileName', bytes.length, bytes));
        }
      }
    }

    final zipEncoder = ZipEncoder();
    final zipData = zipEncoder.encode(archive);

    if (zipData == null) throw Exception('Failed to encode zip');

    final backupDir = await getExternalStorageDirectory() ?? appDocDir;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupFile = File(
      p.join(backupDir.path, 'book_shelve_backup_$timestamp.zip'),
    );

    await backupFile.writeAsBytes(zipData);
    return backupFile.path;
  }

  Future<void> restoreData(String zipPath) async {
    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final appDocDir = await getApplicationDocumentsDirectory();

    // Ensure images directory exists
    final imagesDir = Directory(p.join(appDocDir.path, 'images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    for (final file in archive) {
      if (file.isFile) {
        final data = file.content as List<int>;
        final outFile = File(p.join(appDocDir.path, file.name));

        // Ensure subdirectories (like images/) exist if needed
        final parentDir = outFile.parent;
        if (!await parentDir.exists()) {
          await parentDir.create(recursive: true);
        }

        await outFile.writeAsBytes(data);
      }
    }

    // Re-open box after restore
    await _box.close();
    await Hive.openBox<Book>(boxName);
  }
}
