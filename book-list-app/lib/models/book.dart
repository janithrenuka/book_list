import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String author;
  @HiveField(3)
  final String? imagePath;
  @HiveField(4)
  final bool isWishlist;
  @HiveField(5)
  final bool isRead;
  @HiveField(6)
  final String category;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    this.imagePath,
    this.isWishlist = false,
    this.isRead = false,
  });

  Book copyWith({
    String? title,
    String? author,
    String? imagePath,
    bool? isWishlist,
    bool? isRead,
    String? category,
  }) {
    return Book(
      id: id,
      title: title ?? this.title,
      author: author ?? this.author,
      imagePath: imagePath ?? this.imagePath,
      isWishlist: isWishlist ?? this.isWishlist,
      isRead: isRead ?? this.isRead,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imagePath': imagePath,
      'isWishlist': isWishlist,
      'isRead': isRead,
      'category': category,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      imagePath: map['imagePath'],
      isWishlist: map['isWishlist'] ?? false,
      isRead: map['isRead'] ?? false,
      category: map['category'] ?? 'General',
    );
  }
}

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      id: fields[0] as String,
      title: fields[1] as String,
      author: fields[2] as String,
      imagePath: fields[3] as String?,
      isWishlist: fields[4] as bool,
      isRead: fields[5] as bool,
      category: fields[6] as String? ?? 'General',
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.isWishlist)
      ..writeByte(5)
      ..write(obj.isRead)
      ..writeByte(6)
      ..write(obj.category);
  }
}
