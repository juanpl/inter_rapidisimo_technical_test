import 'package:flutter/material.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/colors/application_colors.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ApplicationColors.thirdBrandColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: ApplicationColors.secondBrandColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(child: child),
    );
  }
}
