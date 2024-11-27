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
          MaterialPageRoute(builder: (context) => Dashboard()),
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

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
    // Simulasi delay untuk proses refresh
    await Future.delayed(const Duration(seconds: 2));

    // Setelah data baru dimuat, lakukan setState untuk memperbarui konten
    // setState(() {
    //   contentData.add({
    //     "title": "Konten Baru - Sehatpedia",
    //     "type": "Artikel",
    //     "date": "28/8/2021",
    //     "imagePath": "assets/images/exKonten3.png"
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF6FC),
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
                        child: TeksAtas(),
                      ),
                      const SizedBox(height: 16),
                      ListKonten(),
                      DailyQuizWidget(quiz: quiz),
                    ],
                  ),
                ),
              ),
            ),
            SearchBar(),
          ],
        ),
      ),
    );
  }

  Column TeksAtas() {
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

  SizedBox ListKonten() {
    return SizedBox(
      height: 210, // Menentukan tinggi untuk konten horizontal
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        children: buildContentCards(contentData),
      ),
    );
  }

  Positioned SearchBar() {
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
