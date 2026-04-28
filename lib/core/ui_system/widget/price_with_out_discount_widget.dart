import 'package:flutter/material.dart';

class PriceWithOutDiscountWidget extends StatelessWidget {
  const PriceWithOutDiscountWidget({
    super.key,
    required this.price,
    this.fontSize = 12,
  });

  final double price;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${price.toStringAsFixed(2)}',
      style: TextStyle(
        decoration: TextDecoration.lineThrough,
        color: Colors.grey,
        fontSize: fontSize,
      ),
    );
  }
}
