  import '../models/daily_quiz.dart';
  
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