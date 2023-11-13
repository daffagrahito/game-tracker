// IMPLEMENTASI BONUS, PAGE LIHAT ITEM

import 'package:flutter/material.dart';

class Item {
  final String name;
  final int playtime;
  final String description;

  Item(this.name, this.playtime, this.description);

}
  
List<Item> listItems = [

];

class ItemListPage extends StatelessWidget {
  final List<Item> items = listItems;

  ItemListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Item'),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.indigoAccent,
                  child: Text(
                    items[index].name[0],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(items[index].name),
                subtitle: Text('${items[index].playtime} hours - ${items[index].description}'),
              ),
            );
          },
        ),
      ),
    );
  }
}