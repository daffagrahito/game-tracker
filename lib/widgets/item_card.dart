// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:game_tracker/screens/gamedata_form.dart'; // Import untuk tombol Tambah Item
import 'package:game_tracker/screens/list_item.dart'; // Import ItemList untuk Tombol Lihat Item
import 'package:game_tracker/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

// TERDAPAT IMPLEMENTASI BONUS: MENENTUKAN WARNA UNTUK TOMBOL
class ItemCollections {
  final String name;
  final IconData icon;
  final MaterialColor color;

  ItemCollections(this.name, this.icon, this.color); // Constructor
}

final List<ItemCollections> items = [
    ItemCollections("Lihat Item", Icons.checklist, Colors.blue),
    ItemCollections("Tambah Item", Icons.note_add_outlined, Colors.green),
    ItemCollections("Logout", Icons.logout, Colors.red),
];

class ItemCard extends StatelessWidget {
  final ItemCollections item;

  const ItemCard(this.item, {super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: item.color,
      child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () async {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));

          // Navigate ke route yang sesuai (tergantung jenis tombol)
          if (item.name == "Tambah Item") {
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => const GameDataFormPage()));
          } else if (item.name == "Lihat Item") {
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ItemPage()));
          } else if (item.name == "Logout") {
              final response = await request.logout(
                  "https://muhammad-daffa23-tugas.pbp.cs.ui.ac.id/auth/logout/");
                  // "https://localhost:8000/auth/logout/");
              String message = response["message"];
              if (response['status']) {
                String uname = response["username"];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message Sampai jumpa, $uname."),
                ));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message"),
                ));
              }
            }
        },
        child: Container(
          // Container untuk menyimpan Icon dan Text
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}