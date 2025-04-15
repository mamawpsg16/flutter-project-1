import 'package:erp_application/models/order.dart';

import '../database_helper.dart';
import 'package:sqflite/sqflite.dart';

class OrderTable {
  static const tableName = 'orders';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnTotalAmount = 'total_amount';
  static const columnCreatedAt = 'created_at';
  static const columnUpdatedAt = 'updated_at';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnTotalAmount REAL NOT NULL,
        $columnCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        $columnUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  static Future<int> insert(Order order) async {
    final db = await DatabaseHelper().database;
    return await db.insert(tableName, order.toMap());
  }

  static Future<List<Order>>  getAll() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'id DESC', // Order by id in descending order
    );
    return maps.map((e) => Order.fromMap(e)).toList();
  }

  static Future<int> update(Order product) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      tableName,
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  static Future<int> delete(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  static Future<Order?> getById(int id) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Order.fromMap(maps.first);
    }
    return null;
  }
}