import 'package:flutter/material.dart';

class BrandTextWidget extends StatelessWidget {
  final String brand;
  const BrandTextWidget({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Marca: $brand',
      style: const TextStyle(fontSize: 11, color: Colors.black54),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
