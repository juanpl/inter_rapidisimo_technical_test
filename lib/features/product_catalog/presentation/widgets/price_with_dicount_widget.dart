import 'package:flutter/material.dart';

class PriceWithDicountWidget extends StatelessWidget {
  final double discountedPrice;

  const PriceWithDicountWidget({super.key, required this.discountedPrice});

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: TextAlign.center,
      '\$${discountedPrice.toStringAsFixed(2)}',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }
}
