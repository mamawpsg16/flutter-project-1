import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_view_model.dart'; // Import ProductViewModel

class ProductView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();

  ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final productVM = Provider.of<ProductViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: productVM.products.isEmpty
                ? const Center(child: Text("No products yet."))
                : ListView.separated(
                    itemCount: productVM.products.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final order = productVM.products[index];
                      return ListTile(
                        leading: const Icon(Icons.shopping_bag),
                        title: Text(order.name),
                        subtitle: Text("Quantity: \$${order.quantity.toStringAsFixed(2)}"),
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
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder()
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? "Enter name" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final amount = double.tryParse(value ?? '');
                    if (amount == null || amount <= 0) {
                      return "Enter valid quantity";
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
                      productVM.addProduct(
                        _nameController.text,
                        int.parse(_quantityController.text),
                      );
                      _nameController.clear();
                      _quantityController.clear();
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
