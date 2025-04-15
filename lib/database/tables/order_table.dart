import 'package:erp_application/models/order.dart';

import '../database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:erp_application/models/order_detail.dart';

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

  static Future<List<Order>> getAll() async {
    final db = await DatabaseHelper().database;
    
    // First, get all orders
    final List<Map<String, dynamic>> orderMaps = await db.query('orders', orderBy: 'id DESC');
    
    // Create a map to store orders by ID
    Map<int, Order> orderMap = {};
    
    // Create Order objects
    for (var map in orderMaps) {
      int orderId = map['id'];
      orderMap[orderId] = Order.fromMap(map);
    }
    
    // Now get all order details and associate them with orders
    final List<Map<String, dynamic>> detailMaps = await db.rawQuery('''
      SELECT * FROM order_details
      WHERE order_id IN (${orderMap.keys.join(',')})
    ''');
    
    // Add order details to their corresponding orders
    for (var map in detailMaps) {
      int orderId = map['order_id'];
      if (orderMap.containsKey(orderId)) {
        var orderDetail = OrderDetail.fromMap(map);
        orderMap[orderId]?.addOrderDetail(orderDetail);
      }
    }
    
    // Convert the order map to a list and return
    return orderMap.values.toList();
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