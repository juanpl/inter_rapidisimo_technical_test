import 'package:flutter/material.dart';

class PriceWithDicountWidget extends StatelessWidget {
  const PriceWithDicountWidget({
    super.key,
    required this.discountedPrice,
    this.fontSize = 14,
  });

  final double discountedPrice;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${discountedPrice.toStringAsFixed(2)}',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        color: Colors.black87,
      ),
    );
  }
}
