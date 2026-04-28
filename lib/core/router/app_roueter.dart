import 'package:go_router/go_router.dart';
import 'package:inter_rapidisimo_technical_test/core/router/list_routes.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/app_shell.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/presentation/pages/cart_page.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/pages/product_catalog_page.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/presentation/page/product_detail_page.dart';

final appRouter = GoRouter(
  initialLocation: ListRoutes.productCatalog.path,
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: ListRoutes.productCatalog.path,
          name: ListRoutes.productCatalog.name,
          builder: (context, state) => const ProductCatalogPage(),
        ),
      ],
    ),
    GoRoute(
      path: ListRoutes.cart.path,
      name: ListRoutes.cart.name,
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      path: ListRoutes.productDetail.path,
      name: ListRoutes.productDetail.name,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductDetailPage(productId: id);
      },
    ),
  ],
);
