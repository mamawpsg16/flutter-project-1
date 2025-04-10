import 'package:flutter/material.dart';
import '../models/product.dart';
import '../helpers/database_helper.dart'; // Import DatabaseHelper

class ProductViewModel extends ChangeNotifier {
  // List to store products
  List<Product> _products = [];

  List<Product> get products => _products;

  // Load products from the database
  Future<void> loadProducts() async {
    _products = await DatabaseHelper().getAllProducts();
    notifyListeners(); // Notify listeners that the data has changed
  }

  // Add a product to the database
  Future<void> addProduct(String name, int quantity) async {
    final product = Product(name: name, quantity: quantity);
    await DatabaseHelper().insertProduct(product);
    await loadProducts(); // Reload products after adding a new one
  }

  // Update a product in the database
  Future<void> updateProduct(Product product) async {
    await DatabaseHelper().updateProduct(product);
    await loadProducts(); // Reload products after updating
  }

  // Delete a product from the database
  Future<void> deleteProduct(int id) async {
    await DatabaseHelper().deleteProduct(id);
    await loadProducts(); // Reload products after deletion
  }
}
