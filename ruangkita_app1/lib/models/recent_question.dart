import 'package:flutter/material.dart';

class RecentQuestionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> questions;

  const RecentQuestionsWidget({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEEF6FC), // Warna latar sesuai desain
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cek pertanyaan terbaru!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blue[900],
            ),
          ),
          const SizedBox(height: 16),
          ...questions.map((question) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildQuestionCard(context, question),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, Map<String, dynamic> question) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/icons/iconProfile.png',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question['username'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      question['question'],
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/icons/iconProfile.png',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question['answer'],
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '${question['helpfulCount']} orang merasa terbantu',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Logika tombol "Like"
                },
                child: Image.asset(
                  'assets/icons/iconLike.png',
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(width: 16),
              Transform.rotate(
                angle: 3.14, // Putar 180 derajat
                child: GestureDetector(
                  onTap: () {
                    // Logika tombol "Dislike"
                  },
                  child: Image.asset(
                    'assets/icons/iconLike.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  // Logika tombol "Komentar"
                },
                child: Image.asset(
                  'assets/icons/iconComment.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${question['replyCount']} balasan',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
