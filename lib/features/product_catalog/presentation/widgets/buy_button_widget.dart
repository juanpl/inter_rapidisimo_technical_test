import 'package:flutter/material.dart';

class BuyButtonWidget extends StatelessWidget {
  const BuyButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Agregar', style: TextStyle(fontSize: 12)),
      ),
    );
  }
}
