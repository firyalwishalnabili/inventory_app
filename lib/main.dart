import 'package:flutter/material.dart';
import 'package:inventory_app/LandingPage.dart';
import 'package:inventory_app/LoginPage.dart';
import 'package:inventory_app/RegisterPage.dart';
import 'package:inventory_app/HomePage.dart';
import 'package:inventory_app/AddItemPage.dart';
import 'package:inventory_app/EditItemPage.dart';
import 'Koneksi.dart';
import 'package:flutter/services.dart'; // Jangan lupa import package ini

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init(); // Inisialisasi koneksi Supabase

  // Setel status bar menjadi transparan
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Set status bar transparan
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/addItem': (context) => AddItemPage(),
        '/editItem': (context) => EditItemPage(),
      },
    );
  }
}
