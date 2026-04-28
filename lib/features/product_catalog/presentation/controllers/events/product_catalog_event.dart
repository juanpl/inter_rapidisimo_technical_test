import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

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

class AddToCart extends ProductCatalogEvent {
  const AddToCart(this.product);
  final ProductEntity product;
}

class RemoveFromCart extends ProductCatalogEvent {
  const RemoveFromCart(this.product);
  final ProductEntity product;
}
