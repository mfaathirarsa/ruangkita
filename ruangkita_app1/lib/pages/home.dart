import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulasi loading 3 detik sebelum ke Dashboard
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFF2280BF), // Mengubah warna latar belakang
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/RuangKitaLogo.PNG', // Gantilah dengan path logo yang sesuai
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Menampilkan indikator loading
          ],
        ),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(child: Text('Selamat datang di Dashboard!')),
    );
  }
}