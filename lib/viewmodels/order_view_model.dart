import 'package:flutter/foundation.dart';
import '../models/order.dart';
import 'package:erp_application/database/tables/order_table.dart';
import '../models/order_detail.dart';
import '../database/tables/order_detail_table.dart';
import '../models/product.dart';

class OrderViewModel extends ChangeNotifier {
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
      _orders = await OrderTable.getAll();
    } catch (e) {
      print('Error loading orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrder(String customerName, double totalAmount,
    Map<Product, int> productQuantities) async {
    final newOrder = Order(customerName: customerName, totalAmount: totalAmount);
    int orderId;
    try {
      // 1. Insert the order
      orderId = await OrderTable.insert(newOrder);

      // 2. Insert order details
      for (var product in productQuantities.keys) {
        final quantity = productQuantities[product]!;
        final amount = product.price ?? 0.0; // Get the product's price
        final orderDetail = OrderDetail(
          orderId: orderId,
          productId: product.id!,
          amount: amount,
          quantity: quantity,
        );
        await OrderDetailTable.insert(orderDetail);
      }

      // 3. Refresh the order list
      await loadOrders();
    } catch (e) {
      print('Error adding order: $e');
      rethrow; // Re-throw the exception to be handled by the UI
    }
  }

  Future<void> deleteOrder(int id) async {
    await OrderTable.delete(id);
    await loadOrders();
  }
}
