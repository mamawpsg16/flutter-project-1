class OrderDetail {
  final int? id;
  final int orderId;
  final int productId;
  final double amount;
  final int quantity;
  final DateTime? createdAt; // Change timestamp to createdAt
  final DateTime? updatedAt;

  OrderDetail({
    this.id,
    required this.orderId,
    required this.productId,
    required this.amount,
    required this.quantity,
    this.createdAt, // Change timestamp to createdAt
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'order_id': orderId,
      'product_id': productId,
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

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      id: map['id'],
      orderId: map['order_id'],
      productId: map['product_id'],
      amount: map['amount'],
      quantity: map['quantity'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at']) // Use created_at
          : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }
}
