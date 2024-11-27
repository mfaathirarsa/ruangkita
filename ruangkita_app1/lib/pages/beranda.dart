import 'package:flutter/material.dart';
import '../models/konten.dart';

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
              'assets/logo/RuangKitaLogo.png', // Gantilah dengan path logo yang sesuai
              width: 150,
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  final List<Map<String, String>> contentData = [
    {
      "title": "Cara Menjaga Organ Reproduksi Wanita - Sehatpedia",
      "type": "Video",
      "date": "26/8/2021",
      "imagePath": "assets/images/exKonten1.png" // Ganti sesuai path gambar
    },
    {
      "title": "Pentingnya Pengetahuan Kesehatan Reproduksi Bagi Remaja",
      "type": "Artikel",
      "date": "26/8/2021",
      "imagePath": "assets/images/exKonten2.png" // Ganti sesuai path gambar
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Agar konten tidak mengecil saat keyboard muncul
      body: SafeArea(
        child: Stack(
          children: [
            // Konten utama
            Padding(
              padding: const EdgeInsets.only(top: 80.0), // Jarak dari search bar
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hai, Daffa Pramudya!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Mau belajar apa hari ini?',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Ada yang baru nih buat kamu!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // List kartu konten
                    Container(
                      height: 210, // Menentukan tinggi untuk konten horizontal
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        scrollDirection: Axis.horizontal,
                        children: buildContentCards(contentData),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search bar di atas
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Cari artikel, video, kuis, atau lainnya...',
                          hintStyle: TextStyle( // Hint text tanpa bold
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Metode untuk membangun daftar ContentCard
  List<Widget> buildContentCards(List<Map<String, String>> data) {
    return data.map((item) {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: ContentCard(
          title: item["title"]!,
          type: item["type"]!,
          date: item["date"]!,
          imagePath: item["imagePath"]!,
        ),
      );
    }).toList();
  }
}