import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE tasks (
      id $idType,
      title $textType,
      description $textType,
      priority $textType,
      status $textType,
      date $textType,
      category $textType
    )
    ''');
  }

  Future<int> create(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<Task> readTask(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'tasks',
      columns: [
        'id',
        'title',
        'description',
        'priority',
        'status',
        'date',
        'category'
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;
    const orderBy = 'date ASC';
    final result = await db.query('tasks', orderBy: orderBy);

    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<int> update(Task task) async {
    final db = await instance.database;

    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
