import 'package:flutter/material.dart';
import 'pages/beranda.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Gotham',
      ),
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),  // Menampilkan loading screen sebagai home
    );
  }
}
