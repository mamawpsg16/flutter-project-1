import 'package:flutter/foundation.dart';
import '../models/order.dart';
import 'package:erp_application/database/tables/order_table.dart'; // Import the OrderTable
import '../viewmodels/order_view_model.dart'; // Import the OrderTable
// Import the OrderTable

class OrderViewModel extends ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders => _orders;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  OrderViewModel() {
    loadOrders(); // Load orders when the view model is created
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();
    try {
      _orders = await OrderTable.getAll(); // Fetch all orders from the database
    } catch (e) {
      print('Error loading orders: $e'); // Handle potential errors
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrder(String customerName, double amount) async {
    final newOrder = Order(customerName: customerName, amount: amount);
    await OrderTable.insert(newOrder);
    await loadOrders(); // Refresh the list after adding
  }

  Future<void> deleteOrder(int id) async {
    await OrderTable.delete(id);
    await loadOrders(); // Refresh the list after deleting
  }
}
