class OrderDetail {
  final int? id;
  final int orderId;
  final int productId;
  final String productName; // Add this field
  final double amount;
  final int quantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderDetail({
    this.id,
    required this.orderId,
    required this.productId,
    required this.productName, // Add this to the constructor
    required this.amount,
    required this.quantity,
    this.createdAt,
    this.updatedAt,
  });
  
  // Update fromMap to capture the product name
  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      id: map['id'],
      orderId: map['order_id'],
      productId: map['product_id'],
      productName: map['product_name'] ?? 'Unknown Product', // Get product name
      amount: map['amount'],
      quantity: map['quantity'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at']).toLocal()
          : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']).toLocal() : null,
    );
  }

    Map<String, dynamic> toMap() {
      final map = <String, dynamic>{
        'order_id': orderId,
        'product_id': productId,
        'product_name': productName,
        'amount': amount,
        'quantity': quantity,
      };

      // Only include 'id' if it's not null
      if (id != null) {
        map['id'] = id;
      }

      // For datetime fields, you can use either:
      // Option 1: ISO8601 string format
      if (createdAt != null) {
        map['created_at'] = createdAt!.toIso8601String();
      }

      if (updatedAt != null) {
        map['updated_at'] = updatedAt!.toIso8601String();
      }

    return map;
  }

}