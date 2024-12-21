import 'package:flutter/material.dart';

// Loading screen widget
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
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
