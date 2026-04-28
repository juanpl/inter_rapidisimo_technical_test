enum ListRoutes { productCatalog, cart }

extension RouteExtension on ListRoutes {
  String get path {
    switch (this) {
      case ListRoutes.productCatalog:
        return '/product_catalog';
      case ListRoutes.cart:
        return '/cart';
    }
  }
}
