import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/product.dart';
import 'package:erp_application/repositories/order_repository.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();

  List<Order> _orders = [];
  List<Order> get orders => _orders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  OrderViewModel() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();
    try {
      _orders = await _orderRepository.getAllOrders();
    } catch (e) {
      print('Error loading orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrder(String customerName, double totalAmount,
      Map<Product, int> productQuantities) async {
    try {
      await _orderRepository.addOrderWithDetails(customerName, totalAmount, productQuantities);
      await loadOrders();
    } catch (e) {
      print('Error adding order: $e');
      rethrow;
    }
  }

  Future<void> deleteOrder(int id) async {
    try {
      await _orderRepository.deleteOrder(id);
      await loadOrders();
    } catch (e) {
      print('Error deleting order: $e');
    }
  }
}
