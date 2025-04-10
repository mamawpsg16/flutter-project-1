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
  Widget build(BuildContext context) {
    final orderVM = Provider.of<OrderViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: orderVM.orders.isEmpty
                ? const Center(child: Text("No orders yet."))
                : ListView.separated(
                    itemCount: orderVM.orders.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final order = orderVM.orders[index];
                      return ListTile(
                        leading: const Icon(Icons.shopping_bag),
                        title: Text(order.customerName),
                        subtitle: Text("Amount: \$${order.amount.toStringAsFixed(2)}"),
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
                  decoration: const InputDecoration(
                    labelText: "Customer Name",
                    border: OutlineInputBorder()
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? "Enter name" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(),
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
                  icon: const Icon(Icons.add),
                  label: const Text("Add Order"),
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
    );
  }
}
