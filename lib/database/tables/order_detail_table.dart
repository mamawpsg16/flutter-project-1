import 'package:sqflite/sqflite.dart';
import 'order_table.dart';
import 'product_table.dart';
import '../database_helper.dart';
import 'package:erp_application/models/order_detail.dart'; // Import the OrderDetail model

class OrderDetailTable {
  static const tableName = 'order_details';
  static const columnId = 'id';
  static const columnOrderId = 'order_id';
  static const columnProductId = 'product_id';
  static const columnAmount = 'amount';
  static const columnQuantity = 'quantity';
  static const columnCreatedAt = 'created_at';
  static const columnUpdatedAt = 'updated_at';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnOrderId INTEGER NOT NULL,
        $columnProductId INTEGER NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnQuantity INTEGER NOT NULL,
        $columnCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        $columnUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($columnOrderId) REFERENCES ${OrderTable.tableName}(${OrderTable.columnId}),
        FOREIGN KEY ($columnProductId) REFERENCES ${ProductTable.tableName}(id)
      )
    ''');
  }

  static Future<int> insert(OrderDetail orderDetail) async {
    final db = await DatabaseHelper().database;
    return await db.insert(tableName, orderDetail.toMap());
  }

  static Future<List<OrderDetail>> getAllByOrderId(int orderId) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '$columnOrderId = ?',
      whereArgs: [orderId],
    );
    return maps.map((map) => OrderDetail.fromMap(map)).toList();
  }

  static Future<int> update(OrderDetail orderDetail) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      tableName,
      orderDetail.toMap(),
      where: '$columnId = ?',
      whereArgs: [orderDetail.id],
    );
  }

  static Future<int> delete(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  static Future<List<OrderDetail>> getAll() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName, orderBy: '$columnId DESC');
    return maps.map((map) => OrderDetail.fromMap(map)).toList();
  }

  static Future<OrderDetail?> getById(int id) async {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return OrderDetail.fromMap(result.first);
    }
    return null;
  }
}