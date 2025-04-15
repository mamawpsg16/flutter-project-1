class OrderDetail {
  final int? id;
  final int orderId;
  final int productId;
  final double amount;
  final int quantity;
  final DateTime? timestamp;

  OrderDetail({
    this.id,
    required this.orderId,
    required this.productId,
    required this.amount,
    required this.quantity,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'amount': amount,
      'quantity': quantity,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      id: map['id'],
      orderId: map['order_id'],
      productId: map['product_id'],
      amount: map['amount'],
      quantity: map['quantity'],
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : null,
    );
  }
}
