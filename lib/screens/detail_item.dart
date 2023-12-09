import 'package:flutter/material.dart';
import 'package:game_tracker/models/item.dart';
import 'package:game_tracker/widgets/left_drawer.dart';

class ItemDetailPage extends StatelessWidget {
  final Item item;

  const ItemDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.fields.name,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text("Amount: ${item.fields.amount}"),
            const SizedBox(height: 10),
            Text("Description: ${item.fields.description}"),
            const SizedBox(height: 10),
            Text("Date Added: ${item.fields.dateAdded}"),
            const SizedBox(height: 10),
            Text("Category: ${item.fields.category}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the item list page
              },
              child: const Text('Kembali ke daftar item'),
            ),
          ],
        ),
      ),
    );
  }
}