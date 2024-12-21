import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/user_provider.dart';

// Loading screen widget
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;

      if (userId != null) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
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
