import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/order_view_model.dart'; // Ensure correct path
import '../../../models/order.dart'; // Import the Order model
import 'add.dart';

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
                child: orderVM.orders.isEmpty
                    ? Center(
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
                      )
                    : ListView.separated(
                        itemCount: orderVM.orders.length,
                        separatorBuilder: (_, __) => Divider(color: colorScheme.outlineVariant),
                        itemBuilder: (context, index) {
                          final order = orderVM.orders[index];
                          return OrderCard(order: order);
                        },
                      ),
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
        child: const Icon(Icons.add),
      ),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_cart, color: colorScheme.primary),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Amount: \$${order.totalAmount.toStringAsFixed(2)}"),
                  ],
                ),
              ],
            ),
            Text(order.createdAt != null ? order.createdAt.toString() : 'N/A'),
          ],
        ),
      ),
    );
  }
}
