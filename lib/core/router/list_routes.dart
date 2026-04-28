enum ListRoutes { productCatalog, cart, productDetail }

extension RouteExtension on ListRoutes {
  String get path {
    switch (this) {
      case ListRoutes.productCatalog:
        return '/product_catalog';
      case ListRoutes.cart:
        return '/cart';
      case ListRoutes.productDetail:
        return '/product/:id';
    }
  }
}
