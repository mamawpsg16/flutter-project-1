import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/order_view_model.dart';
import '../../../viewmodels/product_view_model.dart';
import '../../../models/product.dart';
// Customer Name Input Widget

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerController = TextEditingController();
  final Map<Product, int> _productQuantities = {};

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductViewModel>(context, listen: false).loadProducts(onlyAvailable: true);
    });
  }

  @override
  void dispose() {
    _customerController.dispose();
    super.dispose();
  }

  double calculateTotalAmount(List<Product> products) {
    double total = 0;
    for (var product in products) {
      if (_productQuantities.containsKey(product)) {
        total += (product.price ?? 0) * _productQuantities[product]!;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final orderVM = Provider.of<OrderViewModel>(context);
    final productVM = Provider.of<ProductViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final List<Product> products = productVM.products;

    final totalAmount = calculateTotalAmount(products);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Order')),
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomerNameInput(
                  customerController: _customerController,
                  colorScheme: colorScheme,
                  validator: (value) => (value == null || value.isEmpty)
                      ? "Enter customer name"
                      : null,
                ),
                const SizedBox(height: 16),
                TotalAmountDisplay(totalAmount: totalAmount),
                const SizedBox(height: 16),
                const Text("Select Products and Quantities:"),
                Expanded(
                  child: ProductList(
                    isLoading: productVM.isLoading,
                    products: products,
                    productQuantities: _productQuantities,
                    onQuantityChanged: (product, quantity) {
                      setState(() {
                        _productQuantities[product] = quantity;
                      });
                    },
                    colorScheme: colorScheme,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Create Order"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final customerName = _customerController.text;
                      await orderVM.addOrder(
                          customerName, totalAmount, _productQuantities);

                      Navigator.pop(context); // Go back to the order list
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

class ProductCounter extends StatefulWidget {
  final Product product;
  final int quantity;
  final Function(int) onQuantityChanged;

  const ProductCounter({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  State<ProductCounter> createState() => _ProductCounterState();
}

class _ProductCounterState extends State<ProductCounter> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isOutOfStock = widget.product.quantity == 0;
    final int availableStock = widget.product.quantity ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.product.name ?? '',
              style: TextStyle(
                fontSize: 18,
                color: isOutOfStock ? colorScheme.error : null,
              ),
            ),
          ),
          Text(
            '\$${widget.product.price?.toStringAsFixed(2) ?? '0.00'}',
            style: TextStyle(
              fontSize: 16,
              color: isOutOfStock ? colorScheme.error : null,
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.remove, size: 28),
                  onPressed: isOutOfStock
                      ? null
                      : () {
                          setState(() {
                            if (_quantity > 0) {
                              _quantity--;
                              widget.onQuantityChanged(_quantity);
                            }
                          });
                        },
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  '$_quantity',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.add, size: 28),
                  onPressed: isOutOfStock
                      ? null
                      : () {
                          setState(() {
                            if (_quantity < availableStock) {
                              _quantity++;
                              widget.onQuantityChanged(_quantity);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Maximum quantity reached.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          });
                        },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomerNameInput extends StatelessWidget {
  final TextEditingController customerController;
  final ColorScheme colorScheme;
  final String? Function(String?)? validator;

  const CustomerNameInput({
    super.key,
    required this.customerController,
    required this.colorScheme,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: customerController,
      decoration: InputDecoration(
        labelText: "Customer Name",
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurface),
      ),
      validator: validator,
    );
  }
}

// Product List Widget
class ProductList extends StatelessWidget {
  final bool isLoading;
  final List<Product> products;
  final Map<Product, int> productQuantities;
  final Function(Product, int) onQuantityChanged;
  final ColorScheme colorScheme;

  const ProductList({
    super.key,
    required this.isLoading,
    required this.products,
    required this.productQuantities,
    required this.onQuantityChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (products.isEmpty) {
      return const Center(child: Text("No available products"));
    } else {
      return ListView.separated(
        itemCount: products.length,
        separatorBuilder: (context, index) =>
            Divider(color: colorScheme.outlineVariant),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCounter(
            product: product,
            quantity: productQuantities[product] ?? 0,
            onQuantityChanged: (int quantity) {
              onQuantityChanged(product, quantity);
            },
          );
        },
      );
    }
  }
}

// Total Amount Display Widget
class TotalAmountDisplay extends StatelessWidget {
  final double totalAmount;

  const TotalAmountDisplay({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}');
  }
}
