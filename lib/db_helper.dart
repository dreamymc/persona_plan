import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('personaplan.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_table (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        email TEXT NOT NULL,
        UNIQUE (username),
        UNIQUE (email)
      )
    ''');

    await db.execute('''
      CREATE TABLE task_table (
        task_id INTEGER PRIMARY KEY AUTOINCREMENT,
        task_name TEXT NOT NULL,
        task_description TEXT NOT NULL,
        due_date TEXT NOT NULL,
        priority INTEGER NOT NULL,
        status TEXT NOT NULL,
        category TEXT NOT NULL,
        user_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user_table (user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE goal_table (
        goal_id INTEGER PRIMARY KEY AUTOINCREMENT,
        goal_name TEXT NOT NULL,
        deadline TEXT NOT NULL,
        status TEXT NOT NULL,
        category TEXT NOT NULL,
        user_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user_table (user_id)
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('user_table', row);
  }

  Future<Map<String, dynamic>?> getUser(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'user_table',
      columns: ['user_id', 'username'],
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? result.first : null;
  }


  Future<int> insertTask(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('task_table', row);
  }

  Future<int> insertGoal(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('goal_table', row);
  }

  Future<int> getTaskCount(String username) async {
    final db = await instance.database;
    final user = await getUser(username);
    if (user == null) return 0;

    final userId = user['username'];
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
          'SELECT COUNT(*) FROM task_table WHERE user_id = ?', [userId]),
    );
    return count ?? 0;
  }

  Future<int> getGoalCount(String username) async {
    final db = await instance.database;
    final user = await getUser(username);
    if (user == null) return 0;

    final userId = user['username'];
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
          'SELECT COUNT(*) FROM goal_table WHERE user_id = ?', [userId]),
    );
    return count ?? 0;
  }

  Future<List<Map<String, dynamic>>> getTasks(String username) async {
    final db = await instance.database;
    final user = await getUser(username);
    if (user == null) return [];

    final userId = user['username'];
    return await db
        .query('task_table', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> getGoals(String username) async {
    final db = await instance.database;
    final user = await getUser(username);
    if (user == null) return [];

    final userId = user['username'];
    return await db
        .query('goal_table', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<void> deleteTask(int taskId) async {
    final db = await instance.database;
    await db.delete('task_table', where: 'task_id = ?', whereArgs: [taskId]);
  }

  Future<void> updateTaskStatus(int taskId, String status) async {
    final db = await instance.database;
    await db.update(
      'task_table',
      {'status': status},
      where: 'task_id = ?',
      whereArgs: [taskId],
    );
  }

  Future<void> updateTask(int taskId, Map<String, dynamic> updatedTask) async {
    final db = await instance.database;
    await db.update(
      'task_table',
      updatedTask,
      where: 'task_id = ?',
      whereArgs: [taskId],
    );
  }
    Future<int> deleteGoal(int goalId) async {
    Database db = await instance.database;
    return await db.delete('goal_table', where: 'goal_id = ?', whereArgs: [goalId]);
  }
  Future<int> updateGoal(int goalId, Map<String, dynamic> updatedGoal) async {
  final db = await instance.database;
  return await db.update(
    'goal_table',
    updatedGoal,
    where: 'goal_id = ?',
    whereArgs: [goalId],
  );
}


}
