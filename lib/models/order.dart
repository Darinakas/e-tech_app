import 'product.dart';

class Order {
  final Product product;
  final int quantity;
  final String recipientName;
  final String address;
  final bool isDelivery;
  final DateTime dateTime;

  Order({
    required this.product,
    required this.quantity,
    required this.recipientName,
    required this.address,
    required this.isDelivery,
    required this.dateTime,
  });
}
