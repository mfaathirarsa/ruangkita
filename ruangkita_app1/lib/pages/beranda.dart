import 'package:flutter/material.dart';
import '../models/konten_card.dart';
import '../models/konten_data.dart';
import '../models/footer_menu.dart';
import '../models/menu_beranda_data.dart';
import '../models/poin_kuis_harian_beranda.dart';

import 'aktivitas_page.dart';
import 'konten_page.dart';
import 'konsultasi_page.dart';

// Dashboard Widget
class Dashboard extends StatefulWidget {
  final int userId;
  const Dashboard({super.key, required this.userId});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0; // Index untuk tab saat ini
  bool _hasNewNotification = true; // Simulasi notifikasi baru di "Aktivitas"

  late final List<Widget> _pages; // Halaman untuk navigasi

  @override
  void initState() {
    super.initState();
    _pages = [
      Dashboard(userId: widget.userId), // Halaman Dashboard
      const KontenPage(),
      const AktivitasPage(),
      const KonsultasiPage(),
    ];
  }

  Future<void> _refreshContent() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulasi refresh konten
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;

      if (index == 2) {
        _hasNewNotification =
            false; // Hapus notifikasi jika tab "Aktivitas" dibuka
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF6FC),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            // Using ScrollConfiguration to hide the scrollbar and other behaviors
            ScrollConfiguration(
              behavior: _NoScrollGlow(),
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 65.0),
                    child: RefreshIndicator(
                      onRefresh: _refreshContent,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: _buildHeaderText(),
                            ),
                            const SizedBox(height: 16),

                            // Tambahkan Widget Tombol Menu di sini
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: GridView.count(
                                crossAxisCount: 3,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 16.0,
                                crossAxisSpacing: 16.0,
                                children: generateDashboardMenu,
                              ),
                            ),

                            const SizedBox(height: 26),

                            _buildContentText(),
                            const SizedBox(height: 16),
                            _buildContentList(),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ..._pages.sublist(1), // Halaman lainnya
                ],
              ),
            ),
            _buildSearchBar(context, widget.userId),
          ],
        ),
      ),
      bottomNavigationBar: MenuBawah(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
        hasNewNotification: _hasNewNotification,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Bersihkan ScrollController
    super.dispose();
  }

  Column _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Hai, Daffa Pramudya!', // Anda bisa mengganti ini dengan nama pengguna
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900]),
        ),
        Text(
          'Mau belajar apa hari ini?',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        const TotalPointsWidget(totalPoints: 120),
      ],
    );
  }

  Column _buildContentText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Ada yang baru nih buat kamu!',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900]),
          ),
        ),
      ],
    );
  }

  SizedBox _buildContentList() {
    return SizedBox(
      height: 210,
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        children: _buildContentCards(),
      ),
    );
  }

  List<Widget> _buildContentCards() {
    return contentData.map((item) {
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

  Positioned _buildSearchBar(BuildContext context, int userId) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Cari artikel, video, kuis, atau lainnya...',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/profile',
                  arguments: {'userId': userId},
                );
              },
              child: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom ScrollBehavior untuk menyembunyikan scrollbar
class _NoScrollGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child; // Tidak menampilkan efek glow atau scrollbar
  }
}
