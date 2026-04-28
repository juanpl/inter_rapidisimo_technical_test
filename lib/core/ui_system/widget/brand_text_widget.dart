import 'package:flutter/material.dart';

class BrandTextWidget extends StatelessWidget {
  const BrandTextWidget({super.key, required this.brand, this.fontSize = 11});

  final String brand;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Marca: ${brand.isEmpty ? 'No tiene' : brand}',
      style: TextStyle(fontSize: fontSize, color: Colors.black54),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
