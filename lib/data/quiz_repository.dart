import '../models/quiz_category.dart';
import '../models/quiz_question.dart';

class QuizRepository {
  /// Returns a list of available quiz categories with sample questions
  List<QuizCategory> getCategories() {
    return [
      const QuizCategory(
        id: 'tech',
        title: 'Technology & Flutter',
        description: 'Test your knowledge on programming, Dart, and Flutter basics.',
        iconName: 'code',
        questions: [
          QuizQuestion(
            id: 't1',
            question: 'Which programming language is primarily used for Flutter development?',
            options: ['Java', 'Dart', 'Python', 'C++'],
            correctAnswerIndex: 1,
          ),
          QuizQuestion(
            id: 't2',
            question: 'What is the base building block of a Flutter user interface?',
            options: ['Component', 'Element', 'Widget', 'Block'],
            correctAnswerIndex: 2,
          ),
          QuizQuestion(
            id: 't3',
            question: 'Which company created and maintains Flutter?',
            options: ['Apple', 'Microsoft', 'Google', 'Meta'],
            correctAnswerIndex: 2,
          ),
        ],
      ),
      const QuizCategory(
        id: 'gk',
        title: 'General Knowledge',
        description: 'Challenge yourself with general science, geography, and trivia.',
        iconName: 'public',
        questions: [
          QuizQuestion(
            id: 'g1',
            question: 'What is the capital city of Australia?',
            options: ['Sydney', 'Melbourne', 'Canberra', 'Brisbane'],
            correctAnswerIndex: 2,
          ),
          QuizQuestion(
            id: 'g2',
            question: 'Which planet is known as the Red Planet?',
            options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
            correctAnswerIndex: 1,
          ),
          QuizQuestion(
            id: 'g3',
            question: 'What is the chemical symbol for Gold?',
            options: ['Ag', 'Fe', 'Au', 'Cu'],
            correctAnswerIndex: 2,
          ),
        ],
      ),
    ];
  }
}