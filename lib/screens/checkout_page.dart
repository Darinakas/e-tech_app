import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_model.dart';
import '../models/order.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatefulWidget {
  final Product product;

  const CheckoutPage({super.key, required this.product});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  String _deliveryMethod = 'Delivery';
  String? _pickupPoint;
  int _quantity = 1;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _submitOrder() {
    if (!_formKey.currentState!.validate() ||
        (_deliveryMethod == 'Pickup' && _pickupPoint == null) ||
        (_deliveryMethod == 'Delivery' && _addressController.text.isEmpty) ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    final order = Order(
      product: widget.product,
      quantity: _quantity,
      recipientName: _nameController.text,
      address: _deliveryMethod == 'Delivery' ? _addressController.text : _pickupPoint!,
      isDelivery: _deliveryMethod == 'Delivery',
      dateTime: DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      ),
    );

    CartModel.addOrder(order);

    Navigator.pop(context); // go back to previous page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order successfully placed')),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.product.price * _quantity;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(widget.product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // Quantity selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Quantity:', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                      ),
                      Text(_quantity.toString(), style: const TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => _quantity++),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Recipient Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter a name' : null,
              ),

              const SizedBox(height: 16),

              // Delivery or Pickup
              DropdownButtonFormField<String>(
                value: _deliveryMethod,
                decoration: const InputDecoration(labelText: 'Delivery Method'),
                items: const [
                  DropdownMenuItem(value: 'Delivery', child: Text('Delivery')),
                  DropdownMenuItem(value: 'Pickup', child: Text('Pickup')),
                ],
                onChanged: (value) {
                  setState(() {
                    _deliveryMethod = value!;
                    _pickupPoint = null;
                    _addressController.clear();
                  });
                },
              ),

              const SizedBox(height: 16),

              // Address or Pickup Point
              if (_deliveryMethod == 'Delivery')
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Delivery Address'),
                  validator: (value) => _deliveryMethod == 'Delivery' && (value == null || value.isEmpty)
                      ? 'Enter address'
                      : null,
                )
              else
                DropdownButtonFormField<String>(
                  value: _pickupPoint,
                  decoration: const InputDecoration(labelText: 'Pickup Point'),
                  items: const [
                    DropdownMenuItem(value: 'AITU', child: Text('AITU')),
                    DropdownMenuItem(value: 'Bayterek', child: Text('Bayterek')),
                    DropdownMenuItem(value: 'Khan Shatyr', child: Text('Khan Shatyr')),
                  ],
                  onChanged: (value) => setState(() => _pickupPoint = value),
                  validator: (value) => _deliveryMethod == 'Pickup' && value == null
                      ? 'Select pickup point'
                      : null,
                ),

              const SizedBox(height: 16),

              // Select date and time
              ListTile(
                title: const Text('Select Date'),
                subtitle: Text(_selectedDate == null
                    ? 'No date chosen'
                    : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),

              ListTile(
                title: const Text('Select Time'),
                subtitle: Text(_selectedTime == null
                    ? 'No time chosen'
                    : _selectedTime!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: _pickTime,
              ),

              const SizedBox(height: 16),

              // Total price
              Text(
                'Total Price: ${totalPrice.toStringAsFixed(2)} ₸',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitOrder,
                child: const Text('Submit Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
