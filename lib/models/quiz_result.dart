class QuizResult {
  final String categoryTitle;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;

  QuizResult({
    required this.categoryTitle,
    required this.score,
    required this.totalQuestions,
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();

  /// Computed getter for percentage score
  double get percentage => (score / totalQuestions) * 100;
}