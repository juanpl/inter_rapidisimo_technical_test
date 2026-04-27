enum ListRoutes { productCatalog }

extension RouteExtension on ListRoutes {
  String get path {
    switch (this) {
      case ListRoutes.productCatalog:
        return '/product_catalog';
    }
  }
}
