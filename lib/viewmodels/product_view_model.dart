import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false; // Add loading state
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true; // Set loading to true
    notifyListeners(); // Notify listeners

    _products = await _repository.fetchAll();

    _isLoading = false; // Set loading to false
    notifyListeners(); // Notify listeners
  }

  Future<void> addProduct(Product product) async {
    final insertedId = await _repository.insert(product);
    final newProduct = await _repository.fetchById(insertedId);
    if (newProduct != null) {
      _products.insert(0, newProduct); // Add to top of the list
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    await _repository.delete(id);
    _products.removeWhere((p) => p.id == id); // Remove from local list
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final updated = await _repository.update(product);
    if (updated > 0) {
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product; // Replace in-place
        notifyListeners();
      }
    }
  }
}
