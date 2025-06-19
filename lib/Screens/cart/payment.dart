import 'package:flutter/material.dart';

class Payment extends StatelessWidget {
  static const routeName = "/PaymentScreen";
  const Payment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Placed')),
      body: Center(
        child: Text(
          'Your Order has been placed successfully!',
          textAlign: TextAlign.center, // Optional for multi-line alignment
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
