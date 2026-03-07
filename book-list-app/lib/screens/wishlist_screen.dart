import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_service.dart';
import '../widgets/book_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => WishlistScreenState();
}

class WishlistScreenState extends State<WishlistScreen> {
  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  void loadBooks() {
    if (mounted) {
      setState(() {
        _books = DatabaseService().getWishlist();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _books.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 64,
                  color: Colors.blue[200],
                ),
                const SizedBox(height: 16),
                Text(
                  'Your Wishlist',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Books you want to buy will appear here.'),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _books.length,
            itemBuilder: (context, index) {
              return BookCard(
                book: _books[index],
                onTap: () {
                  // Handle book tap if needed
                },
              );
            },
          );
  }
}
