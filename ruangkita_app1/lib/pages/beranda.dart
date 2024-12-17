import 'package:flutter/material.dart';
import '../models/konten.dart';
import '../models/daily_quiz.dart';
import '../models/recent_question.dart';
import '../models/menu_bawah.dart';
import '../models/dashboard_menu.dart';
import '../models/daily_quiz_point_dashboard.dart';

// Dummy placeholder pages (replace with your actual page imports)
import 'aktivitas_page.dart'; // Replace with your actual page imports
import 'konten_page.dart'; // Replace with your actual page imports
import 'konsultasi_page.dart'; // Replace with your actual page imports

// Dashboard Widget
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
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
    question:
        "Apa yang perlu dilakukan untuk menjaga kesehatan tubuh di masa remaja?",
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
      "question":
          "Bagaimana cara pengobatan yang baik dan benar untuk Ibu kita?",
      "answer":
          "Kamu seharusnya begini lalu begitu, kamu harus minum ini 3x sehari.",
      "helpfulCount": 4,
      "replyCount": 2,
    },
  ];

  //Tempat navigasi
  final List<Widget> _pages = [
    const Dashboard(),
    const KontenPage(),
    const AktivitasPage(),
    const KonsultasiPage(),
  ];

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
            // Using IndexedStack to switch between pages (your existing Beranda page remains in the stack)
            IndexedStack(
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
                              children: [
                                DashboardMenu(
                                  icon: Icons.article,
                                  caption: 'Konten',
                                  onPressed: () {
                                    print('Konten clicked');
                                  },
                                ),
                                DashboardMenu(
                                  icon: Icons.lightbulb,
                                  caption: 'Aktivitas',
                                  onPressed: () {
                                    print('Aktivitas clicked');
                                  },
                                ),
                                DashboardMenu(
                                  icon: Icons.chat,
                                  caption: 'Konsultasi',
                                  onPressed: () {
                                    print('Konsultasi clicked');
                                  },
                                ),
                                DashboardMenu(
                                  icon: Icons.quiz,
                                  caption: 'Kuis',
                                  onPressed: () {
                                    print('Kuis clicked');
                                  },
                                ),
                                DashboardMenu(
                                  icon: Icons.question_answer,
                                  caption: 'Tanya Anonim',
                                  onPressed: () {
                                    print('Tanya Anonim clicked');
                                  },
                                ),
                                DashboardMenu(
                                  icon: Icons.star,
                                  caption: 'Premium',
                                  onPressed: () {
                                    print('Premium clicked');
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 26),

                          // Tetap menjaga widget _buildContentList()
                          

                          // DailyQuizWidget(quiz: quiz),
                          // const SizedBox(height: 20),
                          // RecentQuestionsWidget(questions: recentQuestions),
                          _buildContentText(),
                          const SizedBox(height: 16),
                          _buildContentList(),
                        ],
                      ),
                    ),
                  ),
                ),
                ..._pages.sublist(1), // Your other pages can be added here
              ],
            ),
            _buildSearchBar(),
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

  Column _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Hai, Daffa Pramudya!',
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
        TotalPointsWidget(totalPoints: 120),
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
