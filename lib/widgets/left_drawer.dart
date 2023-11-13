import 'package:flutter/material.dart';
import 'package:game_tracker/screens/item_list.dart'; // IMPLEMENTASI BONUS
import 'package:game_tracker/screens/menu.dart';
import 'package:game_tracker/screens/gamedata_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigoAccent,
            ),
            child: Column(
              children: [
                Text(
                  'Game Tracker',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text("Track Your Game Collections",
                    textAlign: TextAlign.center, // Center alignment
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.note_add_outlined),
            title: const Text('Tambah Item'),
            // Bagian redirection ke GameDataFormPage
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GameDataFormPage()),
              );
            },
          ),
          // List Tile untuk IMPLEMENTASI BONUS yaitu page baru Lihat Item
          ListTile(
            leading: const Icon(Icons.note_add_outlined),
            title: const Text('Lihat Item'),
            // Bagian redirection ke ItemListPage
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ItemListPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}