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

// For testing purpose
import 'pages/youtube_page_test.dart';
import 'pages/konten_addartikel_page.dart';
import 'pages/konten_addvideo_page.dart';
import 'pages/konten_viewartikel_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
        // '/init': (context) => const ArticlePage(), // For testing purpose
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/video': (context) => const Youtube(),
        '/dashboard': (BuildContext context) {
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
