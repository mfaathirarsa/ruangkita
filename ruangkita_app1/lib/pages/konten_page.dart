import 'package:flutter/material.dart';
import '../models/konten_data.dart';
import '../models/konten_card.dart'; // Mengimpor ContentCard dari konten_beranda.dart

class KontenPage extends StatefulWidget {
  final List<Map<String, dynamic>> filteredContent;
  final String searchQuery;
  final TextEditingController searchController; 
  const KontenPage({
    super.key,
    required this.filteredContent,
    required this.searchQuery,
    required this.searchController,
  });

  @override
  State<KontenPage> createState() => _KontenPageState();
}

class _KontenPageState extends State<KontenPage> {
  // Tag aktif (default = Semua)
  String _activeTag = "Semua";

  // Filter konten berdasarkan tag dan teks pencarian
  List<Map<String, dynamic>> get _filteredKonten {
    // Filter berdasarkan tag
    final filteredByTag = _activeTag == "Semua"
        ? widget.filteredContent
        : widget.filteredContent
            .where((item) => item['type'] == _activeTag)
            .toList();

    // Filter berdasarkan teks pencarian
    if (widget.searchQuery.isEmpty) {
      return filteredByTag; // Jika query kosong, gunakan hasil filter tag saja
    }

    return filteredByTag.where((item) {
      return item['title']
          .toLowerCase()
          .contains(widget.searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF6FC),
      resizeToAvoidBottomInset: false,
      body: ScrollConfiguration(
        behavior: _NoScrollGlow(),
        child: CustomScrollView(
          slivers: [
            // AppBar utama
            const SliverAppBar(
              title: Text(
                "Konten",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              foregroundColor: Colors.black,
              pinned: true,
            ),

            // Spasi sebelum Filter Tag
            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),

            // Filter Tag dengan SliverAppBar
            SliverAppBar(
              backgroundColor: const Color(0xFFEEF6FC),
              floating: true,
              snap: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: _buildTagFilter(),
              expandedHeight: 50, // Tinggi untuk filter tag
            ),

            // List konten
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final konten = _filteredKonten[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 6.0),
                    child: Column(
                      children: [
                        ContentCard(
                          title: konten['title']!,
                          type: konten['type']!,
                          date: konten['date']!,
                          imagePath: konten['imagePath']!,
                          width: MediaQuery.of(context).size.width - 20,
                          imageHeight: 175,
                          searchQuery: widget.searchController.text,
                        ),
                      ],
                    ),
                  );
                },
                childCount: _filteredKonten.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget filter tagging
  Widget _buildTagFilter() {
    const tags = ["Semua", "Artikel", "Video"];
    return Container(
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
}

class _NoScrollGlow extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
