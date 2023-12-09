# Inventory Master Mobile

> Mobile version of Inventory Master Django Web app

`Muhammad Daffa Grahito Triharsanto - 2206820075 - PBP A`

## Tugas 9: Integrasi Layanan Web Django dengan Aplikasi Flutter

## Implementasi Checklist ✅
- ### Memastikan deployment proyek tugas Django kamu telah berjalan dengan baik. ✔️
![Deployment tugas Django](https://cdn.discordapp.com/attachments/1152952874037428306/1176697426103517294/image.png?ex=656fcfe0&is=655d5ae0&hm=9a6c46fc548585b894763dad32fee5a44036df0a510aa28e82daef4193e2c443&)

- ### Mengintegrasikan sistem autentikasi Django dengan proyek tugas Flutter. ✔️
Pertama, buat `django-app` dengan menjalankan `python manage.py startapp authentication`. 

Setelah itu tambahkan `django-cors-headers` ke dalam requirements.txt dan jalankan `pip install requirements.txt`. 

Pastikan untuk menambahkan `authentication` dan `corsheaders` ke dalam `INSTALLED_APPS` di `settings.py` direktori *project*. 

Tambahkan juga `corsheaders.middleware.CorsMiddleware` ke dalam `MIDDLEWARE`. 

Setelah itu tambahkan variable-variable berikut ini pada `settings.py`:
```py
CORS_ALLOW_ALL_ORIGINS = True
CORS_ALLOW_CREDENTIALS = True
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SAMESITE = 'None'
SESSION_COOKIE_SAMESITE = 'None'
```

Setelah itu menjalankan command berikut di terminal pada direktori flutter app `game_tracker`
```
flutter pub add provider
flutter pub add pbp_django_auth
```

Jika sudah, pada `lib/main.dart` akan diubah `class MyApp` menjadi seperti ini
```dart
... // Sesuaikan importnya dan tambahkan kode dibawah ini
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
...
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
          CookieRequest request = CookieRequest();
          return request;
      },
      child: MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
```

- ### Membuat halaman login pada proyek tugas Flutter. ✔️
Buat sebuah views function pada `authentication/views.py` dan isi dengan ini:
```py
from django.shortcuts import render
from django.contrib.auth import authenticate, login as auth_login
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def login(request):
    username = request.POST['username']
    password = request.POST['password']
    user = authenticate(username=username, password=password)
    if user is not None:
        if user.is_active:
            auth_login(request, user)
            # Status login sukses.
            return JsonResponse({
                "username": user.username,
                "status": True,
                "message": "Login sukses!"
                "id": user.id,  # IMPLEMENTASI BONUS: Untuk filtering item di Flutter app nya
            }, status=200)
        else:
            return JsonResponse({
                "status": False,
                "message": "Login gagal, akun dinonaktifkan."
            }, status=401)

    else:
        return JsonResponse({
            "status": False,
            "message": "Login gagal, periksa kembali email atau kata sandi."
        }, status=401)
```
Setelah itu, buat file `urls.py` pada direktori app `authentication` dan isi dengan ini:
```py
from django.urls import path
from authentication.views import login

app_name = 'authentication'

urlpatterns = [
    path('login/', login, name='login'),
]
```
Tambahkan juga path ini `path('auth/', include('authentication.urls')),` pada `urls.py` direktori project djangonya.

Setelah itu buat sebuah file baru pada folder `screens` dengan nama `login.dart` dan isi dengan kode ini:
```dart
// ignore_for_file: use_build_context_synchronously

import 'package:game_tracker/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:game_tracker/screens/register.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
    runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
const LoginApp({super.key});

@override
Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login',
        theme: ThemeData(
            primarySwatch: Colors.indigo,
    ),
    home: const LoginPage(),
    );
    }
}

class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    // ignore: library_private_types_in_public_api
    _LoginPageState createState() => _LoginPageState();
}

User? loggedInUser;

class User {
  final String username;
  final int id;

  User(this.username, this.id);
}

class _LoginPageState extends State<LoginPage> {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    @override
    Widget build(BuildContext context) {
        final request = context.watch<CookieRequest>();
        return Scaffold(
            appBar: AppBar(
                title: const Text('Login'),
                backgroundColor: Colors.indigoAccent,
                foregroundColor: Colors.white,
            ),
            body: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                                labelText: 'Username',
                            ),
                        ),
                        const SizedBox(height: 12.0),
                        TextField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                                labelText: 'Password',
                            ),
                            obscureText: true,
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                            onPressed: () async {
                                String username = _usernameController.text;
                                String password = _passwordController.text;

                                // Cek kredensial
                                final response = await request.login("http://muhammad-daffa23-tugas.pbp.cs.ui.ac.id/auth/login/", {
                                // final response = await request.login("http://localhost:8000/auth/login/", {
                                'username': username,
                                'password': password,
                                });
                    
                                if (request.loggedIn) {
                                    String message = response['message'];
                                    String uname = response['username'];
                                    int id = response['id'];
                                    loggedInUser = User(uname, id);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const MyHomePage()),
                                    );
                                    ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(
                                            SnackBar(content: Text("$message Selamat datang, $uname.")));
                                    } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                            title: const Text('Login Gagal'),
                                            content:
                                                Text(response['message']),
                                            actions: [
                                                TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                        Navigator.pop(context);
                                                    },
                                                ),
                                            ],
                                        ),
                                    );
                                }
                            },
                            child: const Text('Login'),
                        ),
                        const SizedBox(height: 12.0),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate ke Register Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterPage()),
                            );
                          },
                          child: const Text('Register'),),
                    ],
                ),
            ),
        );
    }
}
```
Setelah itu, pada file `main.dart`, pada Widget `MaterialApp(...)`, ubah `home: const MyHomePage()` menjadi `home: const LoginPage()` dan jalankan `flutter run` untuk melihat perubahannya

- ### Membuat model kustom sesuai dengan proyek aplikasi Django. ✔️
Untuk membuat model kustom sesuai project aplikasi Django, kita bisa menggunakan [Quicktype](http://app.quicktype.io/) yaitu dengan mengambil mengakses route `/json` pada Django web app kita. Ubah setup name menjadi `Item`, source type menjadi `JSON`, dan language menjadi `Dart` pada [Quicktype](http://app.quicktype.io/). Sehingga hasil yang didapat adalah seperti ini:
```dart
// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

List<Item> itemFromJson(String str) => List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

String itemToJson(List<Item> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Item {
    String model;
    int pk;
    Fields fields;

    Item({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String name;
    int amount;
    String description;
    DateTime dateAdded;
    String category;

    Fields({
        required this.user,
        required this.name,
        required this.amount,
        required this.description,
        required this.dateAdded,
        required this.category,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        name: json["name"],
        amount: json["amount"],
        description: json["description"],
        dateAdded: DateTime.parse(json["date_added"]),
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "name": name,
        "amount": amount,
        "description": description,
        "date_added": "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
        "category": category,
    };
}
```
Taruh kode tersebut ke dalam direktori baru di `lib` dengan nama `models` dan buat sebuah file baru bernama `item.dart`.

- ### Membuat halaman yang berisi daftar semua item yang terdapat pada endpoint JSON di Django yang telah kamu deploy. ✔️
Sebelum itu lakukan `flutter pub add http` pada terminal di direktori flutter app, dan pada `android/app/src/main/AndroidManifest.xml` tambahkan kode ini persis setelah `</application>`
```xml
...
    </application>
    <!-- Required to fetch data from the Internet. -->
    <uses-permission android:name="android.permission.INTERNET" />
...
```

Setelah itu, buat file baru pada `lib/screens` dengan nama `list_item.dart` dan isi dengan seperti ini:
```dart
import 'package:flutter/material.dart';
import 'package:game_tracker/screens/detail_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:game_tracker/models/item.dart';
import 'package:game_tracker/screens/login.dart';
import 'package:game_tracker/widgets/left_drawer.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  Future<List<Item>> fetchItem() async {
    var url = Uri.parse('https://muhammad-daffa23-tugas.pbp.cs.ui.ac.id/json/');
    // var url = Uri.parse('http://localhost:8000/json/');
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    // Melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // Melakukan konversi data json menjadi object Item
    List<Item> list_item = [];
    for (var d in data) {
      if (d != null) {
        Item item = Item.fromJson(d);
        if (item.fields.user == loggedInUser?.id){
          list_item.add(item);
        }
      }
    }
    return list_item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Daftar Item',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigoAccent,
          foregroundColor: Colors.white,
        ),
        drawer: const LeftDrawer(),
        body: FutureBuilder(
            future: fetchItem(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        "Tidak terdapat Item.",
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) => InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ItemDetailPage(item: snapshot.data![index]),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data![index].fields.name}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  "Amount : ${snapshot.data![index].fields.amount}"),
                              const SizedBox(height: 10),
                              Text(
                                  "Description : ${snapshot.data![index].fields.description}")
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
            }));
  }
}
```
Setelah itu tambahkan `ListTile` pada `widgets/left_drawer.dart` untuk routing ke page `Lihat Item` seperti kode dibawah ini:
```dart
// Sesuaikan importnya
import 'package:game_tracker/screens/list_item.dart';
...
ListTile(
  leading: const Icon(Icons.checklist),
  title: const Text('Lihat Item'),
  // Bagian redirection ke ItemListPage
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ItemPage()),
    );
  },
),
...
```
Dan juga tambahkan routing Lihat Item pada bagian `onTap: () { }` di file `widgets/item_card.dart` dengan menambahkan ini:
```dart
// Sesuaikan importnya
import 'package:game_tracker/screens/list_item.dart'; // Import ItemList untuk Tombol Lihat Item
...
else if (item.name == "Lihat Item") {
  Navigator.push(context,
  MaterialPageRoute(builder: (context) => const ItemPage()));
```

- ###  Membuat halaman detail untuk setiap item yang terdapat pada halaman daftar Item. ✔️
Sebelumnya, kita dapat mengintegrasikan layanan form flutter dengan layanan django terlebih dahulu dengan membuat views `create_product_flutter` dan juga mengimplementasikan fitur `Logout`. Lebih detailnya bisa dilihat pada source code di github.

Dan juga jika ada `onTap: () {...}` di file ubah menjadi `onTap: () async {...}` supaya berjalan secara asinkronus.

Untuk membuat halaman detail setiap itemnya, buat sebuah file baru pada `screens/` bernama `detail_item.dart` dan isi dengan kode berikut:
```dart
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
```

## Apakah bisa kita melakukan pengambilan data JSON tanpa membuat model terlebih dahulu? 💬
**Ya bisa**, kita dapat melakukan ini dengan menyimpan data JSON ke dalam struktur data seperti dictionary atau map. Namun, pendekatan ini tidak selalu ideal dan **bukan hal yang lebih baik** dari membuat model sebelum melakukan pengambilan data JSON, karena justru model mempermudah kita dalam melakukan pengambilan data karena dengan model kita dapat memastikan suatu objek memiliki semua nilai atribut pada kelas dibanding dengan dictionary yang bisa saja kita melewatkan suatu atribut.

## Jelaskan fungsi dari `CookieRequest` dan jelaskan mengapa instance `CookieRequest` perlu untuk dibagikan ke semua komponen di aplikasi Flutter? 🍪
`CookieRequest` adalah salah satu class pada package `pbp_django_auth.dart`.

### Fungsi
Dilihat dari isi *class*-nya, menurut saya, fungsi dari *class* `CookieRequest` ini yaitu:
- Menyediakan fungsi untuk inisialisasi sesi, login, dan logout yang memungkinkan aplikasi untuk melacak status login dan sesi pengguna.
- Cookies berupa informasi sesi tersebut disimpan secara lokal.
- Melakukan permintaan HTTP dengan metode `GET` dan `POST`.

`CookieRequest` perlu dibagikan ke semua komponen di aplikasi Flutter agar status login atau sesi (cookies) **konsisten**. Jadi, jika status login atau sesi diubah dalam suatu komponen atau aplikasi, maka di komponen atau aplikasi lain akan berubah juga.

## Jelaskan mekanisme pengambilan data dari JSON hingga dapat ditampilkan pada Flutter. 📚
Berikut adalah mekanisme pengambilan data dari JSON.
1. **Membuat model kustom**
Manfaatkan website [Quicktype](http://app.quicktype.io/) untuk membuat data JSON yang didapat dari *endpoint* `/json` pada tugas Django.
2. **Menambahkan dependensi HTTP**
Pada proyek Flutter, tambahkan dependensi `http` dan tambahkan kode `<uses-permission android:name="android.permission.INTERNET" />` pada `android/app/src/main/AndroidManifest.xml` untuk memperbolehkan akses internet.
3. **Fetch Data pada JSON**
```dart
...
Future<List<Item>> fetchItem() async {
    var url = Uri.parse('https://muhammad-daffa23-tugas.pbp.cs.ui.ac.id/json/');
    // var url = Uri.parse('http://localhost:8000/json/');
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    // Melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // Melakukan konversi data json menjadi object Item
    List<Item> list_item = [];
    for (var d in data) {
      if (d != null) {
        Item item = Item.fromJson(d);
        if (item.fields.user == loggedInUser?.id){
          list_item.add(item);
        }
      }
    }
    return list_item;
  }
...
```
Pada kode tersebut terlihat bahwa ada fetch data `JSON` yang dilakukan dan mengirim `HTTP Request`

## Jelaskan mekanisme autentikasi dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter. 🛂
Mekanisme autentikasi pengguna dijelaskan sebagai berikut.
1. Pengguna **memasukkan data akun** yaitu `username` dan `password` pada laman `LoginPage`.
2. Tombol *login* ditekan dan fungsi `login` pada `CookieRequest` terpanggil yang **mengirimkan HTTP *request*** dengan *endpoint* URL proyek Django.
3. Pada Django, **dilakukan autentikasi** seperti `user = authenticate(username=username, password=password)` pada `views.py` milik `authentication`.
4. Setelah itu dicek, **apakah `user is not None` dan `user.is_active:`**?
5. Kembali ke Flutter, jika `request.loggedIn`, **pengguna diarahkan ke `MyHomePage`** dan muncul tampilan selamat datang menggunakan `SnackBar`.
6. Terdapat filtering data `JSON` yang dilakukan setelah fetch data semua data `JSON` lalu data tersebut di filter berdasarkan user id yang terautentikasi dan dimasukkan ke dalam `list_item` untuk ditampilkan pada page `Lihat Item`.

## Widget yang digunakan pada tugas ini. 📱
| Widget            | Penjelasan                                                                                                                                                  |
|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Scaffold`        | `Scaffold` adalah kerangka utama yang digunakan untuk mengatur struktur dasar halaman. Ini mengandung `AppBar` dan `body`.                                     |
| `AppBar`          | `AppBar` adalah bilah atas yang menampilkan judul halaman dan aksi seperti tombol kembali.                                                                   |
| `Container`       | `Container` digunakan untuk mengelompokkan widget dalam satu area dengan padding. Ini memberikan tampilan yang lebih rapi pada widget di dalamnya.             |
| `TextField`       | `TextField` adalah input teks yang memungkinkan pengguna memasukkan teks.                                                                                  |
| `ElevatedButton`  | `ElevatedButton` adalah tombol dengan latar belakang yang terangkat dan reaksi saat ditekan. Digunakan untuk mengaktifkan tindakan seperti "Register" atau "Login". |
| `Text`            | `Text` digunakan untuk menampilkan teks statis.                                                                                                              |
| `AlertDialog`     | `AlertDialog` adalah dialog pop-up yang digunakan untuk menampilkan pesan kepada pengguna.                                                                 |
| `SnackBar`        | `SnackBar` adalah pesan singkat yang muncul di bagian bawah layar dan biasanya digunakan untuk memberikan umpan balik singkat.                             |
| `BuildContext`    | `BuildContext` digunakan untuk mengakses konteks saat membangun widget, seperti untuk menavigasi antar halaman.                                            |
| `Navigator`       | `Navigator` digunakan untuk mengelola navigasi antar halaman dalam aplikasi Flutter.                                                                         |
| `FutureBuilder`       | `FutureBuilder` digunakan untuk membangun UI berdasarkan hasil dari sebuah `Future`. Ini memungkinkan tampilan yang berbeda tergantung pada status Future. |
| `CircularProgressIndicator` | `CircularProgressIndicator` adalah indikator putar yang digunakan saat data sedang dimuat.                                                       |
| `ListView.builder`     | `ListView.builder` adalah daftar gulir yang dibangun secara dinamis berdasarkan data.                                                                   |
| `InkWell`             | `InkWell` digunakan untuk membuat area yang dapat ditekan (tappable).                                                                                    |

<br>
<hr>
<details>
<br>
<summary> <b> Tugas 8 </b> </summary>

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

## Perbedaan antara `Navigator.push()` dan `Navigator.pushReplacement()` ❔
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

## Layout Widget pada Flutter dan penggunaannya 🚩
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

## Elemen *input form* yang dipakai pada tugas ini 📃
Elemen input yang dipakai pada form yang ada di tugas ini hanya `TextFormField`. `TextFormField` dipakai untuk Nama game, Playtime, dan Deskripsi. Semua elemen input ini digunakan karena mereka memberikan cara yang mudah dan efektif bagi pengguna untuk memasukkan data. Selain itu, mereka semua dilengkapi dengan *validator* untuk memastikan bahwa pengguna memasukkan data yang valid dan tidak meninggalkan bidang tersebut kosong.

## Penerapan clean architecture pada aplikasi Flutter? 📘
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

</details>


<hr>
<details>

<summary> <b> Tugas 7 </b> </summary>
<br>

# Game Tracker

> The Game Tracker App is a Flutter-based mobile application that allows users to manage and track their game collections. With this app, you can easily add, view, and organize your video games.
<hr>

`Muhammad Daffa Grahito Triharsanto - 2206820075 - PBP A`

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
