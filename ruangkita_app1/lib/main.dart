import 'package:flutter/material.dart';
import 'pages/beranda.dart';

void main() {
  runApp(const MyApp()); // Tambahkan 'const' di sini
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Tambahkan 'const' pada deklarasi konstruktor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Gotham',
      ),
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(), // Tambahkan 'const' di sini
    );
  }
}
