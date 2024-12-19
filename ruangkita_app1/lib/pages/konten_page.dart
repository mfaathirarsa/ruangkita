import 'package:flutter/material.dart';

class KontenPage extends StatefulWidget {
  const KontenPage({super.key});

  @override
  State<KontenPage> createState() => _KontenPageState();
}

class _KontenPageState extends State<KontenPage> {
  // Tag aktif (default semua)
  String _activeTag = "Semua";

  // Data konten
  final List<Map<String, String>> _konten = [
    {
      "title": "Cara Menjaga Organ Reproduksi Wanita",
      "type": "Video",
      "date": "26/8/2021",
      "image": "assets/images/konten_image_video.png"
    },
    {
      "title": "Pentingnya Pengetahuan Kesehatan Reproduksi Bagi Remaja",
      "type": "Artikel",
      "date": "26/8/2021",
      "image": "assets/images/konten_image_artikel.png"
    },
    {
      "title": "Seni Bicara Kesehatan Reproduksi dengan Remaja",
      "type": "Artikel",
      "date": "26/8/2021",
      "image": "assets/images/konten_image_artikel.png"
    },
  ];

  // Filter konten berdasarkan tag
  List<Map<String, String>> get _filteredKonten {
    if (_activeTag == "Semua") return _konten;
    return _konten.where((item) => item['type'] == _activeTag).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF6FC),
      appBar: AppBar(
        title: const Text("Konten"),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Tagging untuk filter
          _buildTagFilter(),
          const SizedBox(height: 10),

          // List konten
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _filteredKonten.length,
              itemBuilder: (context, index) {
                final konten = _filteredKonten[index];
                return _buildContentCard(
                  title: konten['title']!,
                  type: konten['type']!,
                  date: konten['date']!,
                  imagePath: konten['image']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget filter tagging
  Widget _buildTagFilter() {
    const tags = ["Semua", "Artikel", "Video"];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: tags.map((tag) {
          final isActive = _activeTag == tag;
          return GestureDetector(
            onTap: () {
              setState(() {
                _activeTag = tag;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? Colors.blue[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Widget konten card
  Widget _buildContentCard({
    required String title,
    required String type,
    required String date,
    required String imagePath,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Gambar konten
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),

          // Detail konten
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  type,
                  style: TextStyle(
                    color: type == "Video" ? Colors.red : Colors.blue[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
