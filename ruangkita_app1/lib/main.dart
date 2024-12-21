import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/loading_screen.dart';
import 'pages/beranda.dart';

// import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
// import 'package:sqflite_common/sqlite_api.dart';

void main() {
  //   if (kIsWeb) {
  //   // // Initialize for web (use sqflite_common_ffi_web)
  //   // databaseFactory = databaseFactoryFfiWeb;
  // } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //   // Initialize for desktop (use sqflite_common_ffi)
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // } else {
  //   // Default for mobile (use regular sqflite)
  //   // No initialization required for mobile
  // }

  // // Now you can open the database
  // openDatabase('my_database.db').then((db) {
  //   print('Database opened!');
  // });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Gotham',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/init',
      routes: {
        '/init': (context) => const LoadingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const Dashboard(),
      },
    );
  }
}
