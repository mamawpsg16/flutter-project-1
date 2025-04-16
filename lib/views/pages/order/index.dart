import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/order_view_model.dart'; // Ensure correct path
import '../../../models/order.dart'; // Import the Order model
import 'add.dart';
import 'package:erp_application/helpers/formatter.dart' show formatDate, formatCurrency; // Import the formatter helper


class EmptyOrderMessage extends StatelessWidget {
  const EmptyOrderMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            "No orders yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  final List<Order> orders;
  const OrderList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return orders.isEmpty
        ? const EmptyOrderMessage()
        : ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (_, __) =>
                Divider(color: colorScheme.outlineVariant),
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCard(order: order);
            },
          );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header: Customer name and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.shopping_cart, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      order.customerName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(order.createdAt != null ? formatDate(order.createdAt) : 'N/A'),
              ],
            ),
            const SizedBox(height: 8),
            // Display the details of all products in the order
            ...order.orderDetails.map((detail) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(8.0), // Optional: Add rounded corners
                  ),
                  padding: const EdgeInsets.all(
                      8.0), // Add some padding inside the container
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${detail.productName ?? 'Unknown'}: ${detail.quantity} x ${formatCurrency(detail.amount)}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            // Total Amount
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "Total Amount: ${formatCurrency(order.totalAmount)}",
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderVM = Provider.of<OrderViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withOpacity(0.3),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: OrderList(orders: orderVM.orders),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddOrderScreen()),
          );
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.assignment_add),
      ),
    );
  }
}