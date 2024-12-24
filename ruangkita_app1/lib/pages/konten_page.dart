import 'package:flutter/material.dart';
import '../models/konten_data.dart';
import '../models/konten_card.dart'; // Mengimpor ContentCard dari konten_beranda.dart

import 'konten_viewartikel_page.dart';
import 'konten_viewvideo_page.dart';

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
      body: Stack(
        children: [
          ScrollConfiguration(
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

                // Gunakan SliverPersistentHeader untuk Filter Tag
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: _TagFilterHeader(
                    child: _buildTagFilter(),
                    minExtent: 50,
                    maxExtent: 50,
                  ),
                ),

                // List konten
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final konten = _filteredKonten[index];
                      return GestureDetector(
                        onTap: () {
                          if (konten['type'] == 'Artikel') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ArticlePage(content: konten),
                              ),
                            );
                          } else if (konten['type'] == 'Video') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoPage(content: konten),
                              ),
                            );
                          }
                        },
                        child: Padding(
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
                        ),
                      );
                    },
                    childCount: _filteredKonten.length,
                  ),
                ),
              ],
            ),
          ),

          // FloatingActionButtons
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/editartikel');
                  },
                  heroTag: "editButton",
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.edit),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/postartikel');
                  },
                  heroTag: "postButton",
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
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

class _TagFilterHeader extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minExtent;
  final double maxExtent;

  _TagFilterHeader({
    required this.child,
    required this.minExtent,
    required this.maxExtent,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFEEF6FC),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class _NoScrollGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
