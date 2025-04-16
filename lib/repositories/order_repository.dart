import 'package:erp_application/models/order.dart';
import 'package:erp_application/models/order_detail.dart';
import 'package:erp_application/models/product.dart';
import 'package:erp_application/database/tables/order_table.dart';
import 'package:erp_application/database/tables/order_detail_table.dart';
import 'product_repository.dart';

class OrderRepository {
  final ProductRepository _productRepository = ProductRepository();

  Future<List<Order>> getAllOrders() async {
    return await OrderTable.getAll();
  }

  Future<int> insertOrder(Order order) async {
    return await OrderTable.insert(order);
  }

  Future<void> insertOrderDetail(OrderDetail detail) async {
    await OrderDetailTable.insert(detail);
  }

  Future<void> deleteOrder(int id) async {
    await OrderTable.delete(id);
  }

  Future<void> addOrderWithDetails(String customerName, double totalAmount, Map<Product, int> productQuantities) async {
    final order = Order(customerName: customerName, totalAmount: totalAmount);
    final orderId = await insertOrder(order);

    for (var product in productQuantities.keys) {
      final quantity = productQuantities[product]!;
      final amount = product.price ?? 0.0;

      final orderDetail = OrderDetail(
        orderId: orderId,
        productId: product.id!,
        productName: product.name,
        amount: amount,
        quantity: quantity,
      );
      await insertOrderDetail(orderDetail);

      final updatedProduct = product.copyWith(
        quantity: (product.quantity ?? 0) - quantity,
      );
      
      await _productRepository.update(updatedProduct);
    }
  }
}
