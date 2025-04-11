import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/product_view_model.dart';
import '../../../models/product.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productVM = Provider.of<ProductViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold( // ADD Scaffold here
      appBar: AppBar(title: Text('Add Product')), // Optional AppBar
      body: Container(
        // Add a Container with gradient background
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
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
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    labelStyle: TextStyle(color: colorScheme.onSurface),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final amount = int.tryParse(value ?? '');
                    if (amount == null || amount <= 0) {
                      return "Enter valid quantity";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    labelStyle: TextStyle(color: colorScheme.onSurface),
                  ),
                  keyboardType: TextInputType.number, // or TextInputType.numberWithOptions(decimal: true)
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: const Text("Add Product"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      productVM.addProduct(
                        Product(
                            name: _nameController.text,
                            quantity: int.parse(_quantityController.text),
                            price: double.parse(_priceController.text)),
                      );
                      _nameController.clear();
                      _quantityController.clear();
                      _priceController.clear();

                      Navigator.pop(context); // Close the form after adding
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product added successfully!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
