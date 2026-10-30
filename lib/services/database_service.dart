import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/quiz_result.dart';

class DatabaseService {
  // Singleton pattern to ensure only one database instance is active
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quiz_quest.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE quiz_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoryTitle TEXT NOT NULL,
        score INTEGER NOT NULL,
        totalQuestions INTEGER NOT NULL,
        completedAt TEXT NOT NULL
      )
    ''');
  }

  /// Insert a new quiz result into SQLite
  Future<int> insertResult(QuizResult result) async {
    final db = await instance.database;
    return await db.insert('quiz_history', {
      'categoryTitle': result.categoryTitle,
      'score': result.score,
      'totalQuestions': result.totalQuestions,
      'completedAt': result.completedAt.toIso8601String(),
    });
  }

  /// Fetch all past quiz results
  Future<List<Map<String, dynamic>>> fetchHistory() async {
    final db = await instance.database;
    return await db.query('quiz_history', orderBy: 'completedAt DESC');
  }

  /// Close database connection
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}