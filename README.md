# Game Tracker

> The Game Tracker App is a Flutter-based mobile application that allows users to manage and track their game collections. With this app, you can easily add, view, and organize your video games.
<hr>

`Muhammad Daffa Grahito Triharsanto - 2206820075 - PBP A`

## Tugas 8: Flutter Navigation, Layouts, Forms, and Input Elements


## Implementasi Checklist ✅
- ### Membuat drawer pada aplikasi ✔️
Pertama dibuat file `dart` baru bernama `left_drawer`, lalu masukkan ke direktori baru bernama `widgets` di dalam `lib` dan juga tambahkan kode berikut:
```dart
import 'package:flutter/material.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            // Bagian drawer header
          ),
          // Bagian routing
        ],
      ),
    );
  }
}
```
Setelah itu tambahkan import yang sesuai:
```dart
import 'package:flutter/material.dart';
import 'package:game_tracker/screens/menu.dart';

// Tambahkan import dibawah ini setelah membuat form page nya
import 'package:game_tracker/screens/gamedata_form.dart';
import 'package:game_tracker/screens/item_list.dart'; // IMPLEMENTASI BONUS
...
```
Setelah itu di bagian yang terdapat comment `// Bagian drawer header` dan `// Bagian Routing` akan kita sesuaikan sehingga kode menjadi seperti ini:
```dart
...
@override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader( // Tambahkan dari sini
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
            // Bagian redirection ke GameDataFormPage setelah membuat page form nya
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
```
Setelah itu masukkan drawer menu yang telah kita buat ke dalam `menu.dart`:
```dart
...
import 'package:game_tracker/widgets/left_drawer.dart'; // Tambahkan import
...
return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Game Tracker',
        ),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(), // Tambahkan drawer menu yang telah dibuat
      ...
```
Lihat drawer yang telah dibuat dengan menjalankan `flutter run`

- ### Membuat halaman baru yaitu halaman form pada aplikasi, Mengarahkan pengguna ke halaman form, dan Memunculkan data sesuai isi form ✔️✔️✔️
Buat file direktori baru bernama `screens` lalu dalam direktori tersebut buat file `dart` baru bernama `gamedata_form` dan isi dengan kode ini:
```dart
import 'package:flutter/material.dart';
import 'package:game_tracker/widgets/left_drawer.dart'; // Import drawer yang telah dibuat 
import 'package:game_tracker/screens/item_list.dart';   // IMPLEMENTASI BONUS: Tambahkan import ini setelah membuat page item list

class GameDataFormPage extends StatefulWidget {
    const GameDataFormPage({super.key});

    @override
    State<GameDataFormPage> createState() => _GameDataFormPageState();
}

class _GameDataFormPageState extends State<GameDataFormPage> {

    @override
    Widget build(BuildContext context) {
        return Placeholder()
    }
}
```
Tambahkan atribut-atribut ini pada class `_GameDataFormPageState`:
```dart
...
final _formKey = GlobalKey<FormState>();
String _name = "";
int _playtime = 0;
String _description = "";
...
```
Setelah ini kita bisa menambahkan fitur navigasi pada tombol yang telah dibuat pada tugas sebelumnya. Pada `menu.dart` di *widget* `ItemCard` akan kita tambahkan *routing* ke page-pagenya di bagian `onTap` dan tepatnya setelah bagian menampilkan `Snackbar`:
```dart
// Tambahkan import yang sesuai
import 'package:game_tracker/screens/gamedata_form.dart'; // Import untuk tombol Tambah Item
import 'package:game_tracker/screens/item_list.dart'; // Import ItemList untuk Tombol Lihat Item
...
onTap: () {
  // Memunculkan SnackBar ketika diklik
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
        content: Text("Kamu telah menekan tombol ${item.name}!")));

  // Navigate ke route yang sesuai (tergantung jenis tombol)
  if (item.name == "Tambah Item") {
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => const GameDataFormPage()));
  } else if (item.name == "Lihat Item") { // IMPLEMENTASI BONUS, ROUTING KE PAGE LIST ITEM
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => ItemListPage()));
  }
},
```

Setelah itu replace bagian *widget* `Placeholder()` pada `gamedata_form.dart` dengan kode ini:
```dart
...
return Scaffold(
  appBar: AppBar(
    title: const Center(
      child: Text(
        'Form Add Game Collections',
      ),
    ),
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
  ),
  drawer: const LeftDrawer(),
  body: Form(
    key: _formKey,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Nama Game",
                labelText: "Nama Game",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  _name = value!;
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Nama tidak boleh kosong!";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Playtime (in Hours)",
                labelText: "Playtime",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  _playtime = int.parse(value!);
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Playtime tidak boleh kosong!";
                }
                if (int.tryParse(value) == null) {
                  return "Playtime harus berupa angka!";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Deskripsi",
                labelText: "Deskripsi",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  _description = value!;
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Deskripsi tidak boleh kosong!";
                }
                return null;
              },
            ),
          ),
          Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.indigo),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                listItems.add(Item(_name, _playtime, _description));
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Data Game berhasil tersimpan'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama: $_name'),
                            Text('Playtime: $_playtime'),
                            Text('Deskripsi: $_description'),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
                _formKey.currentState!.reset();
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ),
        ),
        ],
    ),
  ),
)
);
```
ini membuat form page dengan form input beserta validasinya, tombol `Save`, dan memunculkan data sesuai isi dari formulir yang diisi dalam sebuah `pop-up` Setelah menekan tombol `Save`.

- ### Membuat halaman daftar item (Implementasi Bonus) 💡
Akan dibuat sebuah file `dart` baru yang bernama `item_list.dart` dan berisi seperti ini:
```dart
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
```

- ### Menata kembali struktur kode 📁
Akan kita tata kembali struktur kode kita. Pertama kita buat file `dart` baru bernama `item_card` yang akan ditaruh di folder `widgets` dan isinya adalah *widget* class `ItemCollections`, list `items`, dan class `ItemCard` dari `menu.dart`. Kode yang ada di `menu.dart` boleh di remove saja dan `menu.dart` nya kita pindahkan ke dalam direktori `screens`. Jadi struktur folder menjadi seperti ini:

![Gambar struktur kode](https://cdn.discordapp.com/attachments/1152952874037428306/1173527586786267156/image.png?ex=656447bb&is=6551d2bb&hm=96a3724f9f6e65dfc6d9ba47450e28ad5e6dea106234e396c8ddb528b9227a12&)

- ### Perbedaan antara `Navigator.push()` dan `Navigator.pushReplacement()` ❔
`Navigator.push()` dan `Navigator.pushReplacement() `adalah dua metode dalam Flutter yang digunakan untuk navigasi antar halaman.

`Navigator.push()`: Metode ini digunakan untuk menavigasi ke halaman baru dan menambahkannya ke tumpukan halaman (stack). Ketika pengguna menekan tombol kembali, mereka akan kembali ke halaman sebelumnya dalam tumpukan.
Contoh penggunaan `Navigator.push()`:
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SecondPage()),
);
```

`Navigator.pushReplacement()`: Metode ini juga digunakan untuk menavigasi ke halaman baru, tetapi halaman baru ini menggantikan halaman saat ini dalam tumpukan. Jadi, ketika pengguna menekan tombol kembali, mereka tidak akan kembali ke halaman sebelumnya, karena halaman tersebut sudah digantikan.
Contoh penggunaan `Navigator.pushReplacement()`:
```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => SecondPage()),
);
```

Dalam contoh di atas, `SecondPage()` adalah halaman baru yang ingin dinavigasi. Kita perlu mengganti `SecondPage()` dengan halaman tujuan.

- ### Layout Widget pada Flutter dan penggunaannya 🚩
**SingleChildLayoutWidget** 

SingleChildLayoutWidget adalah widget yang mengatur satu anak widget tunggal dalam tata letaknya. Widget dalam kelompok ini sering digunakan ketika kita ingin mengatur ukuran atau posisi anak widget secara kustom.

| Widget                   | Deskripsi                                                           | Contoh Penggunaan                                                             |
|--------------------------|---------------------------------------------------------------------|-------------------------------------------------------------------------------|
| `Container`              | Widget yang dapat mengatur properti seperti padding dan margin.      | Mengatur batas atau padding dari widget anak.                                |
| `Center`                 | Menempatkan widget anak di tengah parent widget.                     | Memusatkan widget anak di tengah parent.                                     |
| `Align`                  | Menempatkan widget anak di posisi yang dapat diatur.                 | Mengatur posisi widget anak dengan presisi.                                  |
| `FractionallySizedBox`  | Menyesuaikan ukuran widget anak sebagai fraksi dari parent.          | Membuat widget anak mengambil sebagian dari ukuran parent widget.            |
| `AspectRatio`            | Menyesuaikan ukuran widget anak berdasarkan rasio aspek tertentu.    | Mempertahankan rasio aspek pada widget anak.                                |
| `SizedBox`               | Mengatur ukuran widget anak secara eksplisit.                        | Menentukan ukuran widget anak dengan tepat.                                 |

<br>

**MultiChildLayoutWidget**

MultiChildLayoutWidget adalah widget yang mengatur beberapa anak widget dalam tata letaknya. Widget dalam kelompok ini memberikan lebih banyak kontrol atas posisi dan tata letak anak-anaknya.



| Widget                      | Deskripsi                                                                                                     | Contoh Penggunaan                                                                                   |
|-----------------------------|---------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| `Row`                       | Menyusun widget anak secara horizontal.                                                                      | Menyusun beberapa widget anak dalam satu baris.                                                  |
| `Column`                    | Menyusun widget anak secara vertikal.                                                                        | Menyusun beberapa widget anak dalam satu kolom.                                                 |
| `Stack`                     | Menumpuk widget anak satu di atas yang lain.                                                                | Menumpuk widget anak dan mengatur posisi relatif.                                                |
| `Wrap`                      | Membungkus widget anak ke baris baru jika tidak cukup ruang secara horizontal.                              | Mengelola tata letak widget anak dalam satu atau beberapa baris, bergantung pada kebutuhan.       |
| `Flow`                      | Menyusun widget anak dalam bentuk alur (flow).                                                              | Menyusun widget anak dalam alur dengan penyesuaian otomatis.                                       |
| `IndexedStack`              | Menunjukkan satu widget anak pada suatu waktu berdasarkan indeks.                                          | Menunjukkan satu widget anak pada suatu waktu berdasarkan indeks tertentu.                          |
| `Flex` dan `Expanded`       | Menggunakan fleksibilitas dalam tata letak, memungkinkan untuk memberikan bobot (flex) pada widget anak.   | Menggunakan `Flex` dan `Expanded` untuk mengatur tata letak dalam `Row` atau `Column`.              |
| `GridView` dan `ListView`   | Menyusun widget anak dalam bentuk grid atau daftar.       

- ### Elemen *input form* yang dipakai pada tugas ini 📃
Elemen input yang dipakai pada form yang ada di tugas ini hanya `TextFormField`. `TextFormField` dipakai untuk Nama game, Playtime, dan Deskripsi. Semua elemen input ini digunakan karena mereka memberikan cara yang mudah dan efektif bagi pengguna untuk memasukkan data. Selain itu, mereka semua dilengkapi dengan *validator* untuk memastikan bahwa pengguna memasukkan data yang valid dan tidak meninggalkan bidang tersebut kosong.

- ### Penerapan clean architecture pada aplikasi Flutter? 📘
Clean Architecture adalah suatu konsep arsitektur perangkat lunak yang bertujuan untuk memisahkan tanggung jawab dan ketergantungan antar komponen agar aplikasi lebih bersih, terstruktur, dan mudah diuji. Penerapan Clean Architecture pada aplikasi Flutter melibatkan beberapa lapisan utama:

1. **Lapisan Presentasi (Presentation Layer):**
    - **Widget UI**: Ini adalah bagian aplikasi yang menangani tampilan dan interaksi pengguna. Pada lapisan ini, kita bisa menggunakan widget Flutter seperti StatefulWidget dan StatelessWidget.
    - **ViewModel atau Bloc**: Kita dapat menggunakan `Provider`, `GetX`, atau `Bloc` untuk mengelola state dan logika presentasi. Pastikan bahwa lapisan ini tidak memiliki logika bisnis, tetapi hanya menangani presentasi dan interaksi pengguna.

2. **Lapisan Bisnis (Domain Layer):**
    - **Use Cases (Interactors)**: Ini adalah tempat di mana logika bisnis utama berada. Use cases menggambarkan tugas-tugas spesifik yang dapat dilakukan oleh aplikasi.
    - **Entity**: Representasi objek utama dalam domain kita. Mereka biasanya berisi aturan bisnis.

3. **Lapisan Data:**
    - **Repositories**: Tempat di mana kita mengakses data, baik itu dari database lokal atau sumber eksternal seperti API. Repositories berfungsi sebagai jembatan antara lapisan bisnis dan lapisan data eksternal.

4. **Lapisan Sumber Eksternal:**
    - **API Clients, Database, dan Eksternal Services**: Komponen ini menyediakan data ke Repositories atau menerima data dari Repositories.

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

15. `MyHomePage`: Ini adalah widget yang ditampilkan sebagai halaman utama dalam aplikasi. Widget ini tidak didefinisikan dalam potongan kode yang diberikan, tetapi biasanya merupakan StatefulWidget atau StatelessWidget yang berisi struktur dan konten halaman utama aplikasi.

16. `ThemeData`: Meskipun bukan widget, `ThemeData` digunakan untuk mengkonfigurasi tampilan aplikasi, seperti warna, font, dan lainnya. Ini digunakan dalam `MaterialApp` untuk menentukan tema aplikasi.

## Screenshot App 📷

![Screenshot App Game Tracker](https://cdn.discordapp.com/attachments/1152952874037428306/1171026480021635105/image.png?ex=655b2e65&is=6548b965&hm=6d0d222a4d3f3239b8fd5c04720a7214287653ba6a646da324282cd1f6e3c429&)
</details>