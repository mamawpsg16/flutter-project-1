import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tables/product_table.dart';
import 'tables/user_table.dart';
import 'tables/order_table.dart';
import 'tables/order_detail_table.dart';

class DatabaseHelper {
  static const String databaseName = "erp_app.db"; // Define database name
  static const int _databaseVersion = 1;  // Increment version
  
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, databaseName);  // Use database name
    return await openDatabase(
      path,
      version: _databaseVersion,  // Use database version
      onCreate: _onCreate,
    );
  }

  Future<void> resetDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, databaseName);
    await deleteDatabase(path);
  }

  
  Future<void> _onCreate(Database db, int version) async {
    await ProductTable.createTable(db);
    await UserTable.createTable(db);
    await OrderTable.createTable(db);
    await OrderDetailTable.createTable(db);
    // You can add more table initializations here.
  }
}