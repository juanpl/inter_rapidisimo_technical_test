import 'package:flutter/material.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/colors/application_colors.dart';

class CartControlWidget extends StatelessWidget {
  const CartControlWidget({
    super.key,
    required this.quantity,
    required this.isLoading,
    required this.onAdd,
    required this.onRemove,
  });

  final int quantity;
  final bool isLoading;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 36,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (quantity == 0) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onAdd,
          style: ElevatedButton.styleFrom(
            backgroundColor: ApplicationColors.primerBrandColor,
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Agregar',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.remove),
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 36),
        ),
        Text(
          '$quantity',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 36),
        ),
      ],
    );
  }
}
