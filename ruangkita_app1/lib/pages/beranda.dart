import 'package:flutter/material.dart';
import '../models/konten_card.dart';
import '../models/konten_data.dart';
import '../models/footer_menu.dart';
import '../models/menu_beranda_data.dart';
import '../models/poin_kuis_harian_beranda.dart';

import 'aktivitas_page.dart';
import 'konten_page.dart';
// import 'youtube_page_test.dart';
import 'konsultasi_page.dart';
import 'profile_page.dart';

import '../models/searchbar_dashboard_model.dart';
import '../controller/youtube_service.dart';
import '../controller/database_controller.dart';

// Dashboard Widget
class Dashboard extends StatefulWidget {
  final int userId;
  const Dashboard({super.key, required this.userId});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  int _currentIndex = 0; // Index untuk tab saat ini
  bool _hasNewNotification = true; // Simulasi notifikasi baru di "Aktivitas"
  final YouTubeService _youTubeService = YouTubeService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isLoading = false;

  List<Map<String, dynamic>> _filteredContentData = contentData; // Data filter
  late final List<Widget> _pages; // Halaman untuk navigasi
  final String _activeTag = "Semua"; // tag aktif (default adalah "Semua")
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadVideos();
    _loadUserName();
    print(contentData);
    _pages = [
      Dashboard(userId: widget.userId), // Halaman Dashboard
      KontenPage(
        filteredContent: _filteredContentData,
        searchQuery: searchController.text,
        searchController: searchController,
      ),
      // Youtube(),
      const AktivitasPage(),
      const KonsultasiPage(),
    ];
  }

  void navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _performSearch(String query) {
    SearchBarDashboardModel.performSearch(
      currentIndex: _currentIndex,
      query: query,
      contentData: contentData, // Data yang perlu difilter
      activeTag: _activeTag, // Tag aktif yang sedang dipilih
      onResult: (filteredResults) {
        setState(() {
          // Perbarui data konten dengan hasil pencarian
          _filteredContentData = filteredResults;
        });
      },
    );
  }

  Future<void> _loadUserName() async {
    try {
      final user = await _dbHelper.getUserById(widget.userId);
      if (user != null) {
        setState(() {
          _userName = user['name'] ?? ''; // Ambil nama pengguna
        });
      } else {
        print('Pengguna dengan ID ${widget.userId} tidak ditemukan.');
      }
    } catch (e) {
      print('Error loading user name: $e');
    }
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final videos = await _youTubeService.fetchVideos();
      print(videos); // Log seluruh respon dari API YouTube.

      setState(() {
        // Pastikan semua elemen videos sudah memiliki format Map<String, String>
        contentData.addAll(videos.cast<Map<String, dynamic>>());
      });
    } catch (error) {
      print("Error loading videos: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToProfilePage() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(userId: widget.userId),
      ),
    );

    if (updated == true) {
      _loadUserName(); // Perbarui nama pengguna di beranda
    }
  }

  Future<void> _refreshContent() async {
    try {
      // Ambil data pengguna terbaru
      final user = await _dbHelper.getUserById(widget.userId);

      if (user != null) {
        setState(() {
          _userName = user['name'] ?? ''; // Perbarui nama pengguna
        });
      } else {
        print('Pengguna dengan ID ${widget.userId} tidak ditemukan.');
      }

      // Perbarui data lain di dashboard jika diperlukan
      // ...
    } catch (e) {
      print('Error refreshing content: $e');
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      searchController.clear(); // Kosongkan teks di search bar saat tab berubah
      if (index == 2) {
        _hasNewNotification = false;
      }
    });
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content:
                const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Tidak keluar
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Keluar
                child: const Text('Ya'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: _buildHeaderText(),
                              ),
                              const SizedBox(height: 16),

                              // Tambahkan Widget Tombol Menu di sini
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  mainAxisSpacing: 16.0,
                                  crossAxisSpacing: 16.0,
                                  children:
                                      generateDashboardMenu(onTabTapped),
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
                    KontenPage(
                      filteredContent: _filteredContentData,
                      searchQuery: searchController.text,
                      searchController: searchController,
                    ),
                    const AktivitasPage(),
                    const KonsultasiPage(),
                  ],
                ),
              ),
              buildSearchBar(context, widget.userId),
            ],
          ),
        ),
        bottomNavigationBar: MenuBawah(
          currentIndex: _currentIndex,
          onTabTapped: onTabTapped,
          hasNewNotification: _hasNewNotification,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose(); // Bersihkan controller saat widget dihapus
    super.dispose();
  }

  Column _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Hai, $_userName!', // Anda bisa mengganti ini dengan nama pengguna
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
      height: 220,
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
          searchQuery:
              searchController.text, // Pass the search query to ContentCard
        ),
      );
    }).toList();
  }

  Positioned buildSearchBar(BuildContext context, int userId) {
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
                controller: searchController, // Hubungkan controller
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText:
                      SearchBarDashboardModel.getHintText(_currentIndex),
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onSubmitted: (query) => _performSearch(query),
                onChanged: (query) => _performSearch(query),
              ),
            ),
            const SizedBox(width: 8.0),
            GestureDetector(
              onTap: _navigateToProfilePage,
              child: const CircleAvatar(
                child: Icon(Icons.person), // Ikon profil tetap ada
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
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child; // Tidak menampilkan efek glow atau scrollbar
  }
}
