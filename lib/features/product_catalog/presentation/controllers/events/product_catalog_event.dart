sealed class ProductCatalogEvent {
  const ProductCatalogEvent();
}

class LoadProductCatalog extends ProductCatalogEvent {
  const LoadProductCatalog();
}

class LoadMoreProducts extends ProductCatalogEvent {
  const LoadMoreProducts();
}

class RefreshProductCatalog extends ProductCatalogEvent {
  const RefreshProductCatalog();
}
