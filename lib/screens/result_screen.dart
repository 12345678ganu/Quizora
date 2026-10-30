import 'package:flutter/material.dart';
import '../models/quiz_result.dart';

class ResultScreen extends StatelessWidget {
  final QuizResult result;
  final VoidCallback onRetry;
  final VoidCallback onHome;

  const ResultScreen({
    super.key,
    required this.result,
    required this.onRetry,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = result.percentage;

    // Determine performance feedback message based on percentage
    String feedbackMessage;
    IconData feedbackIcon;
    Color feedbackColor;

    if (percentage == 100) {
      feedbackMessage = 'Outstanding! Perfect Score!';
      feedbackIcon = Icons.emoji_events;
      feedbackColor = Colors.amber.shade700;
    } else if (percentage >= 70) {
      feedbackMessage = 'Great Job! Well Done!';
      feedbackIcon = Icons.thumb_up;
      feedbackColor = Colors.green;
    } else if (percentage >= 40) {
      feedbackMessage = 'Good Effort! Keep Practicing!';
      feedbackIcon = Icons.trending_up;
      feedbackColor = Colors.orange;
    } else {
      feedbackMessage = 'Don\'t give up! Try again!';
      feedbackIcon = Icons.refresh;
      feedbackColor = Colors.redAccent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Prevent back button clutter
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Feedback Icon
            Icon(
              feedbackIcon,
              size: 80,
              color: feedbackColor,
            ),
            const SizedBox(height: 16),

            // Category Title
            Text(
              result.categoryTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Performance Message
            Text(
              feedbackMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: feedbackColor,
              ),
            ),
            const SizedBox(height: 32),

            // Score Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Your Final Score',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${result.score} / ${result.totalQuestions}',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Action Buttons
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.replay),
              label: const Text('Retry Quiz', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onHome,
              icon: const Icon(Icons.home),
              label: const Text('Return Home', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}