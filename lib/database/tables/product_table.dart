import 'package:sqflite/sqflite.dart';
import '../../models/product.dart';
import '../database_helper.dart';

class ProductTable {
  static const tableName = 'products';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        quantity INTEGER,
        price REAL 
      )
    ''');
  }

  static Future<int> insert(Product product) async {
    final db = await DatabaseHelper().database;
    return await db.insert(tableName, product.toMap());
  }

  static Future<List<Product>> getAll({bool onlyAvailable = false}) async {
    final db = await DatabaseHelper().database;
     List<Map<String, dynamic>> maps;
    if (onlyAvailable) {
       maps = await db.query(
        tableName,
        where: 'quantity != ?',
        whereArgs: [0],
        orderBy: 'id DESC',
      );
    } else {
       maps = await db.query(
        tableName,
        orderBy: 'id DESC',
      );
    }
    
    return maps.map((e) => Product.fromMap(e)).toList();
  }

  static Future<List<Product>> getAvailableProducts() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'quantity != ?',
      whereArgs: [0],
      orderBy: 'id DESC',
    );
    return maps.map((e) => Product.fromMap(e)).toList();
  }

  static Future<int> update(Product product) async {
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
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<Product?> getById(int id) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  

}
