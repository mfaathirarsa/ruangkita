import 'package:flutter/material.dart';
import '../models/konten.dart';
import '../models/dailyquiz.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF2280BF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/RuangKitaLogo.png', // Replace with your logo's path
              width: 150,
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0; // Variable to track the selected tab index
  bool _hasNewNotification = true; // Simulate a new notification for "Aktivitas"

  final List<Map<String, String>> contentData = [
    {
      "title": "Cara Menjaga Organ Reproduksi Wanita - Sehatpedia",
      "type": "Video",
      "date": "26/8/2021",
      "imagePath": "assets/images/exKonten1.png"
    },
    {
      "title": "Pentingnya Pengetahuan Kesehatan Reproduksi Bagi Remaja",
      "type": "Artikel",
      "date": "26/8/2021",
      "imagePath": "assets/images/exKonten2.png"
    },
  ];

  final DailyQuiz quiz = DailyQuiz(
    question: "Apa nama itu yang ada disana?",
    options: [
      AnswerOption(text: "Tes blablablabla", isCorrect: false),
      AnswerOption(text: "Tes blablablabla", isCorrect: false),
      AnswerOption(text: "Tes blablablabla", isCorrect: true),
      AnswerOption(text: "Tes blablablabla", isCorrect: false),
    ],
  );

  Future<void> _refreshContent() async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulate refreshing content
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 2) {
        // Clear notification when "Aktivitas" is clicked
        _hasNewNotification = false;
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
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: RefreshIndicator(
                onRefresh: _refreshContent,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: teksAtas(),
                      ),
                      const SizedBox(height: 16),
                      listKonten(),
                      DailyQuizWidget(quiz: quiz),
                    ],
                  ),
                ),
              ),
            ),
            searchBar(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF63B0E3), // Lighter blue color for active items
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onTabTapped,
        items: [
          _buildBottomNavigationBarItem(
            index: 0,
            label: 'Beranda',
            iconPath: 'assets/icons/iconBeranda.png',
          ),
          _buildBottomNavigationBarItem(
            index: 1,
            label: 'Konten',
            iconPath: 'assets/icons/iconKonten.png',
          ),
          _buildBottomNavigationBarItem(
            index: 2,
            label: 'Aktivitas',
            iconPath: 'assets/icons/iconAktivitas.png',
            hasNotification: _hasNewNotification,
          ),
          _buildBottomNavigationBarItem(
            index: 3,
            label: 'Konsultasi',
            iconPath: 'assets/icons/iconKonsultasi.png',
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required int index,
    required String label,
    required String iconPath,
    bool hasNotification = false,
  }) {
    bool isActive = _currentIndex == index;

    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          Image.asset(
            iconPath,
            color: isActive ? const Color(0xFF63B0E3) : Colors.grey, // Lighter blue when active
            height: 24,
          ),
          if (isActive)
            Positioned(
              top: -10, // Position the blue bar above the icon
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/aktif.png', // Blue bar image for active state
                height: 10, // Height of the bar
              ),
            ),
          if (hasNotification)
            Transform.translate(
              offset: const Offset(20, -5), // Move it 5 units higher
              child: Image.asset(
                'assets/images/elips.png',
                height: 5,
                width: 5,
              ),
            ),
        ],
      ),
      label: label,
      backgroundColor: Colors.white,
    );
  }

  Column teksAtas() {
    return Column(
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
        const SizedBox(height: 8),
        Text(
          'Mau belajar apa hari ini?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Ada yang baru nih buat kamu!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blue[900],
          ),
        ),
      ],
    );
  }

  SizedBox listKonten() {
    return SizedBox(
      height: 210, // Define height for horizontal content list
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        children: buildContentCards(contentData),
      ),
    );
  }

  Positioned searchBar() {
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
                  hintStyle: TextStyle(
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
            const SizedBox(width: 8.0),
            const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }

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
