import 'order.dart';

class CartModel {
  static final List<Order> _orders = [];

  static void addOrder(Order order) {
    _orders.add(order);
  }

  static List<Order> getOrders() {
    return _orders;
  }

  static void clearOrders() {
    _orders.clear();
  }

  static void removeOrder(Order order) {
    _orders.remove(order);
  }
}
