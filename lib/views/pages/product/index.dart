import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/product_view_model.dart';
import '../../../models/product.dart';
import 'add.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {

  @override
  void initState() {
    super.initState();
    // Load products when the screen is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Loading products... PRODUCT VIEW');
      Provider.of<ProductViewModel>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final productVM = Provider.of<ProductViewModel>(context); // 👈 Declare here

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
                child: productVM.products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 80,
                              color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No products yet",
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
                        itemCount: productVM.products.length,
                        separatorBuilder: (_, __) =>
                            Divider(color: colorScheme.outlineVariant),
                        itemBuilder: (context, index) {
                          final product = productVM.products[index];
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
                                      Icon(Icons.shopping_bag, color: colorScheme.primary),
                                      SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(product.name),
                                          Text("Quantity: ${product.quantity}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text("PHP ${product.price?.toStringAsFixed(2) ?? '0.00'}"),
                                ],
                              ),
                            ),
                          );
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
            MaterialPageRoute(builder: (context) => const AddProduct()),
          );
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
