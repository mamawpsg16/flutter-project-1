import 'package:flutter/foundation.dart';
import '../models/order.dart';

class OrderViewModel extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(String customer, double amount) {
    final newOrder = Order(
      id: _orders.length + 1,
      customerName: customer,
      amount: amount,
    );
    _orders.add(newOrder);
    notifyListeners();
  }
}
