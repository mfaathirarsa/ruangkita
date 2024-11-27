import 'package:flutter/material.dart';
import '../models/konten.dart';
import '../models/dailyquiz.dart';
import '../models/recent_question.dart'; // Import untuk widget pertanyaan terbaru

// Loading Screen Widget
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
        child: Image.asset(
          'assets/logo/RuangKitaLogo.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}

// Dashboard Widget
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0; // Index untuk tab saat ini
  bool _hasNewNotification = true; // Simulasi notifikasi baru di "Aktivitas"

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
    question: "Apa yang perlu dilakukan untuk menjaga kesehatan tubuh di masa remaja?",
    options: [
      AnswerOption(text: "Makan makanan yang sehat", isCorrect: true),
      AnswerOption(text: "Sering begadang", isCorrect: false),
      AnswerOption(text: "Menghindari olahraga", isCorrect: false),
      AnswerOption(text: "Merokok", isCorrect: false),
    ],
  );

  final List<Map<String, dynamic>> recentQuestions = [
    {
      "username": "Dudung",
      "question": "Bagaimana cara pengobatan yang baik dan benar untuk Ibu kita?",
      "answer": "Kamu seharusnya begini lalu begitu, kamu harus minum ini 3x sehari.",
      "helpfulCount": 4,
      "replyCount": 2,
    },
    {
      "username": "Dr. Ratio",
      "question": "Apa efek dari makan makanan yang tidak sehat?",
      "answer": "Hindari makanan cepat saji dan perbanyak sayur serta buah.",
      "helpfulCount": 3,
      "replyCount": 1,
    },
  ];

  Future<void> _refreshContent() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulasi refresh konten
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;

      if (index == 2) {
        _hasNewNotification = false; // Hapus notifikasi jika tab "Aktivitas" dibuka
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
                        child: _buildHeaderText(),
                      ),
                      const SizedBox(height: 16),
                      _buildContentList(),
                      DailyQuizWidget(quiz: quiz),
                      const SizedBox(height: 20),
                      RecentQuestionsWidget(questions: recentQuestions),
                    ],
                  ),
                ),
              ),
            ),
            _buildSearchBar(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      selectedItemColor: const Color(0xFF63B0E3),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: _onTabTapped,
      items: [
        _buildBottomNavigationBarItem(0, 'Beranda', 'assets/icons/iconBeranda.png'),
        _buildBottomNavigationBarItem(1, 'Konten', 'assets/icons/iconKonten.png'),
        _buildBottomNavigationBarItem(2, 'Aktivitas', 'assets/icons/iconAktivitas.png', hasNotification: _hasNewNotification),
        _buildBottomNavigationBarItem(3, 'Konsultasi', 'assets/icons/iconKonsultasi.png'),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    int index,
    String label,
    String iconPath, {
    bool hasNotification = false,
  }) {
    bool isActive = _currentIndex == index;

    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            iconPath,
            color: isActive ? const Color(0xFF63B0E3) : Colors.grey,
            height: 24,
          ),
          if (isActive)
            Positioned(
              top: -12,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/icons/aktif.png',
                height: 10,
              ),
            ),
          if (hasNotification)
            Positioned(
              top: -5,
              right: -5,
              child: Image.asset(
                'assets/icons/elips.png',
                height: 5,
                width: 5,
              ),
            ),
        ],
      ),
      label: label,
    );
  }

  Column _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hai, Daffa Pramudya!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[900]),
        ),
        const SizedBox(height: 8),
        Text(
          'Mau belajar apa hari ini?',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 20),
        Text(
          'Ada yang baru nih buat kamu!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blue[900]),
        ),
      ],
    );
  }

  SizedBox _buildContentList() {
    return SizedBox(
      height: 210,
      child: ListView(
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

  Positioned _buildSearchBar() {
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
            const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}
