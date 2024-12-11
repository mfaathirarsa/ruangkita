import 'package:flutter/material.dart';

class AktivitasPage extends StatelessWidget {
  const AktivitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'Halaman Aktivitas',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
