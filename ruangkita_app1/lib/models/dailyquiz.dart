import 'package:flutter/material.dart';

class DailyQuiz {
  final String question;
  final List<AnswerOption> options;

  DailyQuiz({
    required this.question,
    required this.options,
  });
}

class AnswerOption {
  final String text;
  final bool isCorrect;

  AnswerOption({
    required this.text,
    required this.isCorrect,
  });
}

class DailyQuizWidget extends StatefulWidget {
  final DailyQuiz quiz;

  const DailyQuizWidget({super.key, required this.quiz});

  @override
  State<DailyQuizWidget> createState() => _DailyQuizWidgetState();
}

class _DailyQuizWidgetState extends State<DailyQuizWidget> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tambahkan background biru pada teks "Daily Quiz:"
          Container(
            height: 35,
            width: double.infinity, // width yang diatur ke double.infinity
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
            ),
            alignment: Alignment
                .topCenter, // alignment untuk memindahkan background text
            child: const Text(
              "Daily Quiz:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Teks putih
              ),
            ),
          ),

          const SizedBox(height: 8.0),
          Text(
            widget.quiz.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16.0),
          ...List.generate(widget.quiz.options.length, (index) {
            final option = widget.quiz.options[index];
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? (option.isCorrect ? Colors.green : Colors.red)
                        : Colors.blue,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[100],
                ),
                child: Row(
                  children: [
                    if (selectedIndex != null)
                      Icon(
                        option.isCorrect
                            ? Icons.check_circle
                            : Icons.cancel_rounded,
                        color: option.isCorrect ? Colors.green : Colors.red,
                      )
                    else
                      const Icon(
                        Icons.circle_outlined,
                        color: Colors.blue,
                      ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        option.text,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
