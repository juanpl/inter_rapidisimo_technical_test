import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inter_rapidisimo_technical_test/core/router/list_routes.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/colors/application_colors.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/app_toolbar.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/controllers/product_catalog_contoller/events/product_catalog_event.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/controllers/product_catalog_contoller/providers/product_catalog_provider.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppToolbar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: ApplicationColors.secondBrandColor,
            ),
            onPressed: () async {
              await context.pushNamed(ListRoutes.cart.name);
              ref
                  .read(productCatalogProvider.notifier)
                  .add(const ReloadCart());
            },
          ),
        ],
      ),
      body: SafeArea(child: child),
    );
  }
}
