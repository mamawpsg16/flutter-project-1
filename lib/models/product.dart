class Product {
  int? id;  // Removed final
  final String name;
  final int quantity;
  final double? price;

  Product({
    this.id,
    required this.name,
    required this.quantity,
    this.price
  });

  // Convert a Product into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,  // ADDED price here
    };
  }

  // Create a Product from a Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],  // ADDED price here
    );
  }
}
