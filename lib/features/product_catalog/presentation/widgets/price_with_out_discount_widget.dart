import 'package:flutter/material.dart';

class PriceWithOutDiscountWidget extends StatelessWidget {
  final double price;

  const PriceWithOutDiscountWidget({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${price.toStringAsFixed(2)}',
      style: const TextStyle(
        decoration: TextDecoration.lineThrough,
        color: Colors.grey,
        fontSize: 12,
      ),
    );
  }
}
