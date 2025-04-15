import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/product_view_model.dart';
import '../../../models/product.dart';
class AddProductForm extends StatefulWidget {
  final void Function(Product) onAddProduct;

  const AddProductForm({super.key, required this.onAddProduct});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        name: _nameController.text,
        quantity: int.parse(_quantityController.text),
        price: double.parse(_priceController.text),
      );
      widget.onAddProduct(product);

      _nameController.clear();
      _quantityController.clear();
      _priceController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    InputDecoration inputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurface),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: inputDecoration("Name"),
            validator: (value) =>
                (value == null || value.isEmpty) ? "Enter name" : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _quantityController,
            decoration: inputDecoration("Quantity"),
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
            decoration: inputDecoration("Price"),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
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
            icon: const Icon(Icons.add),
            label: const Text("Add Product"),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final productVM = Provider.of<ProductViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
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
          child: AddProductForm(
            onAddProduct: (Product product) {
              productVM.addProduct(product);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
