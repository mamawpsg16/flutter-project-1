class Product {
  final int? id;
  final String name;
  final int quantity;

  Product({
    this.id,
    required this.name,
    required this.quantity,
  });

  // Convert a Product into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
    };
  }

  // Create a Product from a Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
    );
  }
}
