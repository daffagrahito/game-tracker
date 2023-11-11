# Game Tracker

> The Game Tracker App is a Flutter-based mobile application that allows users to manage and track their game collections. With this app, you can easily add, view, and organize your video games.
<hr>

`Muhammad Daffa Grahito Triharsanto - 2206820075 - PBP A`

## Tugas 8: Flutter Navigation, Layouts, Forms, and Input Elements


## Implementasi Checklist ✅

<br>
<hr>
<details>

<summary> <b> Tugas 7 </b> </summary>

### Tugas 7: Elemen Dasar Flutter

## Implementasi Checklist ✅
- ### Membuat sebuah program Flutter baru dengan tema *inventory* ✔️
Untuk dapat memulai membuat aplikasi dengan Flutter pastikan sudah menginstall Flutter dari [sini](https://docs.flutter.dev/get-started/install), penting juga untuk menginstall beberapa software yang diperlukan oleh flutter seperti Android Studio, IDE seperti Visual Studio Code yang sudah terdownload extension Dart dan Flutter, serta keperluan lainnya yang bisa di cek dengan `flutter doctor` setelah menginstall Flutter SDK.
<br>

Lalu mulai membuat project dengan membuka Terminal dan menjalankan `flutter create game_tracker` setelah itu pindah ke direktori tersebut dengan melakukan `cd game_tracker`.
<br>

Lalu di explorer masuk ke direktori `game_tracker\lib` dan buka direktori tersebut dengan Visual Studio Code. Setelah itu akan dibuat file baru bernama `menu.dart`. Setelah itu buka file `main.dart` dan pindahkan kode dari baris ke-39 hingga akhir yang berisi dua class seperti dibawah ini ditambah dengan import material dari flutter ke `menu.dart`:
```dart
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
    ...
}

class _MyHomePageState extends State<MyHomePage> {
    ...
}
```
Setelah itu akan terdapat error di `main.dart` yang terjadi karena tidak terdapat class `MyHomePage` di `main.dart`, untuk itu perlu ditambahkan import dari `menu.dart` pada `main.dart` sehingga `main.dart` terisi seperti ini:
```dart
import 'package:flutter/material.dart';
import 'package:game_tracker/menu.dart'; // Tambahkan ini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    ...
}
```
Pastikan juga `class MyApp` yang tadinya `extends StatefulWidget` diubah menjadi `extends StatelessWidget`. Coba jalankan `flutter run` untuk melihat hasilnya.

- ### Membuat tiga tombol sederhana dengan *icon* dan *text* ✔️
Sebelumnya terdapat tambahan untuk mengganti warna tema aplikasi. Buka file `main.dart` pada direktori `game_tracker/lib`, lalu ubah warna `theme` aplikasi pada bagian `colorScheme` dengan yang mempunyai tipe `MaterialColor`. Saya menggunakan `primarySwatch` untuk mengganti warna primary secara keseluruhan, sehingga kode terlihat seperti ini:
```dart
    ...
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
        useMaterial3: true,
        ),
      home: const MyHomePage(),
    ...
```
Setelah itu, untuk dapat membuat tiga widget tombol sederhana yang disertai *icon* dan *text* kita perlu mengubah sifat widget menu menjadi *stateless* nantinya. Jadi kita hapus terlebih dahulu title yang ada di parameter `MyHomePage()` pada file `main.dart`.
<br>

Jadi dari seperti ini:
```dart
...
home: const MyHomePage(title: 'Flutter Demo Home Page'),
...
```
menjadi seperti ini:
```dart
...
home: const MyHomePage(),
...
```
Lalu pada file `menu.dart`, kita ubah widgetnya menjadi *stateless* sehingga replace kodenya menjadi seperti ini:
```dart
class MyHomePage extends StatelessWidget {
    const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        ...
        );
    }
}
```
Setelah itu kita tambahkan terlebih dahulu *text* dan *card* pada `menu.dart` dengan mendefinisikan *class-class*nya beserta atribut-atributnya pada list seperti yang terlihat pada kode dibawah ini:
```dart
...
// TERDAPAT IMPLEMENTASI BONUS: MENENTUKAN WARNA UNTUK TOMBOL DENGAN DEFINE ATRIBUT BARU
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
```
Baru setelah ini kita tambahkan isi untuk `Scaffold`nya seperti `AppBar`, body utama menu, dan pengaturan `GridView.
```dart
...
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Game Tracker',
        ),
        backgroundColor: Colors.indigoAccent,
      ),
      body: SingleChildScrollView(
        // Widget wrapper yang dapat discroll
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Set padding dari halaman
          child: Column(
            // Widget untuk menampilkan children secara vertikal
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                child: Text(
                  'Track Your Game Collections', // Text penanda
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Grid layout
              GridView.count(
                // Container pada card kita.
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: items.map((ItemCollections item) {
                  // Iterasi untuk setiap item
                  return ItemCard(item);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
...
```
Setelah ini kita akan membuat *stateless widget* baru untuk dapat menampilkan cardnya. Tambahkan class baru ini:
```dart
...
class ItemCard extends StatelessWidget {
  final ItemCollections item;

  const ItemCard(this.item, {super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      child: InkWell(
        ...
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
```
Jalankan `flutter run` untuk melihat tampilannya.

- ### Menampilkan snackbar dengan tulisan ✔️
Untuk dapat menampilkan snackbar (semacam popup) yang berisi tulisan saat menge*click* tombol-tombol yang tampil pada app, tambahkan `onTap` pada widget untuk menampilkan card, tepatnya di dalam parameter `InkWell()`.
```dart
...
child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));
        },
        child: Container(...
...
```
Jalankan lagi `flutter run` sehingga akan bisa menge*click* tombol yang telah kita buat sebelumnya.

## Apa perbedaan utama antara *stateless* dan *stateful* *widget* dalam konteks pengembangan aplikasi Flutter?📱
Dalam pengembangan aplikasi Flutter, perbedaan utama antara *Stateless* dan *Stateful widget* adalah:

- *Stateless Widget*: Widget ini tidak memiliki state, artinya ia tidak dapat berubah sepanjang lifecycle-nya. Jika kita perlu mengubah tampilan, kita harus menghancurkan widget dan menggantinya dengan yang baru. Stateless widget dapat digunakan untuk membuat bagian-bagian statis dari tampilan aplikasi, seperti teks atau ikon.

- *Stateful Widget*: Widget ini memiliki state yang dapat berubah sepanjang lifecycle-nya sehingga widget bisa berubah saat *user* berinteraksi dengan widget tersebut misalnya. Ini berarti bahwa kita dapat memperbarui tampilan widget tanpa harus menghancurkannya dan membuat yang baru. Ini dapat digunakan ketika perlu memperbarui tampilan aplikasi berdasarkan data yang berubah atau respons pengguna.

## Sebutkan seluruh widget yang kamu gunakan untuk menyelesaikan tugas ini dan jelaskan fungsinya masing-masing❗
Pada flutter, hampir semuanya terdefinisi sebagai widget. Pada tugas ini widget yang dipakai ada banyak, yaitu:
1. `Scaffold`: Widget ini menyediakan struktur visual dasar untuk aplikasi Material Design. Ini mencakup navigasi dan tampilan konten seperti `AppBar`, `Drawer`, dan `SnackBar`.

2. `AppBar`: Widget ini adalah toolbar yang biasanya digunakan di bagian atas aplikasi. `AppBar` biasanya berisi judul aplikasi dan beberapa action.

3. `SingleChildScrollView`: Widget ini memungkinkan kontennya dapat discroll jika konten tersebut melebihi ruang yang tersedia.

4. `Padding`: Widget ini digunakan untuk memberikan padding pada widget lainnya.

5. `Column`: Widget ini digunakan untuk menampilkan anak-anaknya (children) dalam urutan vertikal.

6. `Text`: Widget ini digunakan untuk menampilkan teks.

7. `GridView`: Widget ini digunakan untuk menampilkan data dalam bentuk grid.

8. `Material`: Widget ini digunakan untuk memberikan efek visual Material Design pada widget lainnya.

9. `InkWell`: Widget ini digunakan untuk memberikan efek visual sentuhan pada widget lainnya. Biasanya digunakan untuk memberikan efek visual ketika widget disentuh.

10. `Container`: Widget ini digunakan untuk mengkombinasikan beberapa widget menjadi satu. Biasanya digunakan untuk mengatur ukuran, padding, atau margin dari widget lainnya.

11. `Icon`: Widget ini digunakan untuk menampilkan ikon.

12. `SnackBar`: Widget ini digunakan untuk menampilkan pesan singkat di bagian bawah layar. Biasanya digunakan untuk memberikan feedback kepada pengguna tentang aksi yang mereka lakukan.

13. `MyApp`: Ini adalah widget utama yang merupakan titik masuk aplikasi Flutter. Widget ini merupakan turunan dari StatelessWidget yang berarti konfigurasinya tidak berubah sepanjang waktu.

14. `MaterialApp`: Widget ini biasanya berada di paling atas dalam hirarki widget dan mengandung beberapa konfigurasi tingkat aplikasi seperti tema, navigasi, dan judul.

15. `MyHomePage`: Ini adalah widget yang ditampilkan sebagai halaman utama dalam aplikasi. Widget ini tidak didefinisikan dalam potongan kode yang Anda berikan, tetapi biasanya merupakan StatefulWidget atau StatelessWidget yang berisi struktur dan konten halaman utama aplikasi.

16. `ThemeData`: Meskipun bukan widget, `ThemeData` digunakan untuk mengkonfigurasi tampilan aplikasi, seperti warna, font, dan lainnya. Ini digunakan dalam `MaterialApp` untuk menentukan tema aplikasi.

## Screenshot App 📷

![Screenshot App Game Tracker](https://cdn.discordapp.com/attachments/1152952874037428306/1171026480021635105/image.png?ex=655b2e65&is=6548b965&hm=6d0d222a4d3f3239b8fd5c04720a7214287653ba6a646da324282cd1f6e3c429&)
</details>