class Order {
  final int? id;         // Make id nullable as it's auto-generated
  final String customerName;
  final double amount;
  final DateTime? timestamp; // Add timestamp

  Order({
    this.id,               // Make id optional
    required this.customerName,
    required this.amount,
    this.timestamp,        // Make timestamp optional
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': customerName,
      'total_amount': amount,
      'timestamp': timestamp?.toIso8601String(),  // Convert DateTime to String
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      customerName: map['name'],
      amount: map['total_amount'],
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])  // Convert String to DateTime
          : null,
    );
  }
}
