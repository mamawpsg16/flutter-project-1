import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/user.dart';

class UserTable {
  static const tableName = 'users';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        image TEXT
      )
    ''');
  }

  static Future<int> insert(User user) async {
     final db = await DatabaseHelper().database;
    return await db.insert(tableName, user.toMap());
  }


  static Future<List<User>> getAll() async {
    final db = await DatabaseHelper().database;
     final List<Map<String, dynamic>> users = await db.query(
      tableName,
      orderBy: 'id DESC', // Order by id in descending order
    );
    return users.map((e) => User.fromMap(e)).toList();
  }

  static Future<User?> getByEmail(String email) async {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  static Future<User?> getById(int id) async {
  final db = await DatabaseHelper().database;
  List<Map<String, dynamic>> result = await db.query(
    tableName,
    where: 'id = ?',
    whereArgs: [id],
    limit: 1,
  );
  if (result.isNotEmpty) {
    return User.fromMap(result.first);
  }
  return null;
}

static Future<int> update(User user) async {
  final db = await DatabaseHelper().database;
  return await db.update(
    tableName,
    user.toMap(),
    where: 'id = ?',
    whereArgs: [user.id],
  );
}

static Future<int> delete(int id) async {
  final db = await DatabaseHelper().database;
  return await db.delete(
    tableName,
    where: 'id = ?',
    whereArgs: [id],
  );
}
}
