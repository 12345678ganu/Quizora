class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  /// Helper method to verify if a chosen index is correct
  bool isCorrect(int selectedIndex) {
    return selectedIndex == correctAnswerIndex;
  }
}