import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/order_view_model.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final _formKey = GlobalKey<FormState>();
  final _customerController = TextEditingController();                                              
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _customerController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderVM = Provider.of<OrderViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: const Text("Orders"),
      ),
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
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: Icon(Icons.shopping_cart, color: colorScheme.primary),
                              title: Text(
                                order.customerName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "Amount: \$${order.amount.toStringAsFixed(2)}",
                                style: TextStyle(color: colorScheme.onSurfaceVariant),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _customerController,
                      decoration: InputDecoration(
                        labelText: "Customer Name",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        labelStyle: TextStyle(color: colorScheme.onSurface),
                      ),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? "Enter name" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        labelStyle: TextStyle(color: colorScheme.onSurface),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final amount = double.tryParse(value ?? '');
                        if (amount == null || amount <= 0) {
                          return "Enter valid amount";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: const Text("Add Order"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          orderVM.addOrder(
                            _customerController.text,
                            double.parse(_amountController.text),
                          );
                          _customerController.clear();
                          _amountController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Could open a dialog for adding order
          _customerController.clear();
          _amountController.clear();
          // Show bottom sheet or dialog for adding order
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}