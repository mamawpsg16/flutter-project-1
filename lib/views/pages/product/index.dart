import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/product_view_model.dart';
import '../../../models/product.dart';
import 'add.dart';

class EmptyProductMessage extends StatelessWidget {
  const EmptyProductMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
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
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

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
                Icon(Icons.shopping_bag, color: colorScheme.primary),
                const SizedBox(width: 8),
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
  }
}

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductViewModel>(context, listen: false).loadProducts();
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  List<Product> _filterProducts(List<Product> products, bool available) {
    return products.where((product) => available ? product.quantity > 0 : product.quantity == 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final productVM = Provider.of<ProductViewModel>(context);

    // ✅ Ensure tab controller is initialized before building
    if (_tabController == null) {
      return const SizedBox(); // or a loading indicator
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48.0), // Set to a smaller value if needed
        child: AppBar(
          automaticallyImplyLeading: false,
          title: null,
          elevation: 0, // Optional: removes shadow
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Available"),
              Tab(text: "Out of Stock"),
            ],
          ),
        ),
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
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildProductList(context, _filterProducts(productVM.products, true)),
            _buildProductList(context, _filterProducts(productVM.products, false)),
          ],
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
        child: const Icon(Icons.add_business),
      ),
    );
  }

  Widget _buildProductList(BuildContext context, List<Product> products) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: products.isEmpty
          ? const EmptyProductMessage()
          : ListView.separated(
              itemCount: products.length,
              separatorBuilder: (_, __) =>
                  Divider(color: colorScheme.outlineVariant),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(product: product);
              },
            ),
    );
  }
}
