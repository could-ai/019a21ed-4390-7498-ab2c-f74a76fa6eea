import 'package:couldai_user_app/models/product.dart';

class Sale {
  final String id;
  final Product product;
  final int quantity;
  final double totalPrice;
  final DateTime date;

  Sale({
    required this.id,
    required this.product,
    required this.quantity,
    required this.totalPrice,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': product.id,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'date': date.toIso8601String(),
    };
  }

  factory Sale.fromJson(Map<String, dynamic> json, Product product) {
    return Sale(
      id: json['id'],
      product: product,
      quantity: json['quantity'],
      totalPrice: json['totalPrice'],
      date: DateTime.parse(json['date']),
    );
  }
}