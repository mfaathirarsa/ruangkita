import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/loading_screen.dart';
import 'pages/beranda.dart';
import 'pages/profile_page.dart';
import 'pages/profile_page_update.dart';
import 'pages/profile_page_update_password.dart';

import 'controller/user_provider.dart';
import 'controller/database_controller.dart';

// Manage crossplatform database
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

// Additional packages for Windows database handling
import 'dart:ffi';
import 'dart:io';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart'; // Untuk menggabungkan path

void main() async {
  // Manage crossplatform database
  if (kIsWeb) {
    // Initialize for web (use sqflite_common_ffi_web)
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isLinux || Platform.isMacOS) {
    // Initialize for desktop (use sqflite_common_ffi)
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  } else if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    // open.overrideFor(OperatingSystem.windows, _openSqliteUnderWindows);
    // final db = sqlite3.openInMemory();
    // db.dispose();
    print('windows');
  } else {
    // Default for mobile (use regular sqflite)
    // No initialization required for mobile
  }

  // Now test open the database
  openDatabase('app.db').then((db) {
    print('Database opened!');
  });

  final dbHelper = DatabaseHelper();
  await dbHelper.database; // Inisialisasi database

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// Definisikan fungsi _openSqliteUnderWindows
DynamicLibrary _openSqliteUnderWindows() {
  final path = join(Directory.current.path, 'sqlite3.dll');
  return DynamicLibrary.open(path);
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
        '/dashboard': (context) {
          final userId = Provider.of<UserProvider>(context).userId;

          if (userId == null) {
            // Redirect ke halaman login jika userId null
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/login');
            });
            return const SizedBox(); // Return widget kosong sementara
          }

          return Dashboard(userId: userId);
        },
        '/profile': (context) {
          final userId = Provider.of<UserProvider>(context).userId;
          return ProfilePage(userId: userId!);
        },
        '/updatePassword': (context) {
          final userId = Provider.of<UserProvider>(context).userId;
          return UpdatePasswordPage(userId: userId!);
        },
        '/updateProfile': (context) {
          final userId = Provider.of<UserProvider>(context).userId;
          return UpdateProfilePage(userId: userId!);
        },
      },
    );
  }
}
