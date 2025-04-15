class Order {
  final int? id;
  final String customerName;
  final double totalAmount; // CHANGED from amount
  final DateTime? createdAt; // CHANGED from timestamp
  final DateTime? updatedAt;

  Order({
    this.id,
    required this.customerName,
    required this.totalAmount, // CHANGED from amount
    this.createdAt, // CHANGED from timestamp
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'name': customerName,
      'total_amount': totalAmount,
    };

    // Only include id if it's not null
    if (id != null) {
      map['id'] = id as int;  // Explicit cast to non-nullable int
    }

    // Only include these if they're explicitly set
    if (createdAt != null) {
      map['created_at'] = createdAt!.toIso8601String();
    }

    if (updatedAt != null) {
      map['updated_at'] = updatedAt!.toIso8601String();
    }

    return map;
  }


  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      customerName: map['name'],
      totalAmount: map['total_amount'], // CHANGED from amount
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at']) // CHANGED from timestamp
          : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }
}
