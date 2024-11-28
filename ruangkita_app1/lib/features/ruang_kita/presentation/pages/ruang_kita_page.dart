import 'package:flutter/material.dart';

class RuangKitaPage extends StatelessWidget {
  const RuangKitaPage({super.key});

  static const String routeName = '/ruang_kita';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RuangKita'),
      ),
      body: const Center(
        child: Text('RuangKita Page'),
      ),
    );
  }
}
