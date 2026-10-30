import 'quiz_question.dart';

class QuizCategory {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final List<QuizQuestion> questions;

  const QuizCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.questions,
  });

  int get totalQuestions => questions.length;
}