import 'package:flutter/material.dart';
import '../models/quiz_category.dart';
import '../models/quiz_result.dart';
import '../services/database_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategory category;

  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int? _selectedOptionIndex;
  int _score = 0;

  void _handleOptionSelected(int index) {
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  Future<void> _nextQuestion() async {
    if (_selectedOptionIndex == null) return;

    // Check if the answer is correct
    final question = widget.category.questions[_currentIndex];
    if (question.isCorrect(_selectedOptionIndex!)) {
      _score++;
    }

    // Move to next question or finish
    if (_currentIndex < widget.category.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null; // Reset selection for next question
      });
    } else {
      // Create the result object
      final result = QuizResult(
        categoryTitle: widget.category.title,
        score: _score,
        totalQuestions: widget.category.questions.length,
      );

      // Save result to SQLite database
      await DatabaseService.instance.insertResult(result);

      // Ensure the widget is still mounted before navigating
      if (!mounted) return;

      // Navigate to Result Screen and clear previous history stacks
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            result: result,
            onRetry: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(category: widget.category),
                ),
              );
            },
            onHome: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.category.questions;
    final currentQuestion = questions[_currentIndex];
    final progress = (_currentIndex + 1) / questions.length;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: colorScheme.primary.withOpacity(0.12),
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
            const SizedBox(height: 16),

            // Question Count
            Text(
              'QUESTION ${_currentIndex + 1} OF ${questions.length}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),

            // Question Text
            Text(
              currentQuestion.question,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 28),

            // Theme-Aware Answer Options
            ...List.generate(currentQuestion.options.length, (index) {
              final isSelected = _selectedOptionIndex == index;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isSelected
                        ? colorScheme.primary.withOpacity(0.15)
                        : colorScheme.surface,
                    side: BorderSide(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _handleOptionSelected(index),
                  child: Row(
                    children: [
                      // Radio Indicator Circle
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface.withOpacity(0.4),
                            width: 2,
                          ),
                          color: isSelected ? colorScheme.primary : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 14),

                      // Option Text
                      Expanded(
                        child: Text(
                          currentQuestion.options[index],
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const Spacer(),

            // Next / Finish Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _selectedOptionIndex == null ? null : _nextQuestion,
              child: Text(
                _currentIndex == questions.length - 1 ? 'Finish Quiz' : 'Next Question',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}