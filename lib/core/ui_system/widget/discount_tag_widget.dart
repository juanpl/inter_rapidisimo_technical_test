import 'package:flutter/material.dart';

class DiscountTagWidget extends StatelessWidget {
  const DiscountTagWidget({
    super.key,
    required this.discountPercentage,
    this.fontSize = 11,
  });

  final double discountPercentage;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '-${discountPercentage.toStringAsFixed(0)}%',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
