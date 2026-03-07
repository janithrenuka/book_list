import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/book.dart';
import '../services/database_service.dart';
import '../widgets/greeting_app_bar.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _authorController = TextEditingController();
  String _selectedCategory = 'Action';
  XFile? _imageFile;
  final _picker = ImagePicker();

  final List<String> _categories = [
    'Action',
    'Adventure',
    'Alternate History',
    'Anthology',
    'Art',
    'Autobiography',
    'Biography',
    'Business',
    'Children',
    'Classic',
    'Comics',
    'Contemporary',
    'Cookbook',
    'Crime',
    'Dark Fantasy',
    'Drama',
    'Dystopian',
    'Education',
    'Epic Fantasy',
    'Essay',
    'Fairy Tale',
    'Fantasy',
    'Graphic Novel',
    'Guide',
    'Health',
    'Historical',
    'Historical Fiction',
    'History',
    'Horror',
    'Humor',
    'Literary Fiction',
    'Manga',
    'Memoir',
    'Mystery',
    'Mythology',
    'Nature',
    'Philosophy',
    'Poetry',
    'Political',
    'Psychology',
    'Religion',
    'Romance',
    'Satire',
    'Science',
    'Science Fiction',
    'Self Help',
    'Short Story',
    'Spirituality',
    'Sports',
    'Suspense',
    'Technology',
    'Thriller',
    'Travel',
    'True Crime',
    'Urban Fantasy',
    'War',
    'Western',
    'Young Adult',
  ];

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  void _saveBook() async {
    if (_formKey.currentState!.validate()) {
      String? savedImagePath;

      if (_imageFile != null) {
        final appDocDir = await getApplicationDocumentsDirectory();
        final imagesDir = Directory(p.join(appDocDir.path, 'images'));
        if (!await imagesDir.exists()) {
          await imagesDir.create(recursive: true);
        }

        final String fileName =
            '${DateTime.now().millisecondsSinceEpoch}${p.extension(_imageFile!.path)}';
        final String permanentPath = p.join(imagesDir.path, fileName);
        await File(_imageFile!.path).copy(permanentPath);
        savedImagePath = permanentPath;
      }

      final book = Book(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _nameController.text,
        author: _authorController.text,
        category: _selectedCategory,
        imagePath: savedImagePath,
        isWishlist: true,
      );

      await DatabaseService().addBook(book);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GreetingAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blue[200]!,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_rounded,
                              size: 48,
                              color: Colors.blue[300],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add Book Cover',
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Book Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_rounded),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Author (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_rounded),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveBook,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Book',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _authorController.dispose();
    super.dispose();
  }
}
