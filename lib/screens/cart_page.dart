import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../models/cart_model.dart';
import '../models/order.dart';
import '../providers/theme_provider.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final orders = CartModel.getOrders();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  themeProvider.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                  key: ValueKey(themeProvider.isDarkMode),
                ),
              ),
              onPressed: () {
                final nextIndex = (themeProvider.themeIndex + 1) % 3;
                themeProvider.setTheme(nextIndex);
              },

            ),
          ),
        ],
      ),
      body: orders.isEmpty
          ? Center(
        child: Text(
          'Your cart is empty.',
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return FadeInUp(
            duration: Duration(milliseconds: 300 + index * 100),
            child: Dismissible(
              key: Key(order.product.id.toString() + order.dateTime.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.redAccent,
                child: const Icon(Icons.delete, color: Colors.white, size: 30),
              ),
              onDismissed: (_) {
                setState(() {
                  CartModel.removeOrder(order);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${order.product.name} removed from cart'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      order.product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                  title: Text(order.product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${order.quantity}'),
                      Text('Total: ${order.product.price * order.quantity} ₸'),
                      Text('Recipient: ${order.recipientName}'),
                      Text(order.isDelivery
                          ? 'Delivery: ${order.address}'
                          : 'Pickup at: ${order.address}'),
                      Text('Date: ${order.dateTime.toLocal().toString().split('.').first}'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
