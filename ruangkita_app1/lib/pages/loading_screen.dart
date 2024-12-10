import 'package:flutter/material.dart';
import 'beranda.dart';

// Loading screen widget
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF2280BF),
      body: Center(
        child: Image.asset(
          'assets/logo/RuangKitaLogo.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}