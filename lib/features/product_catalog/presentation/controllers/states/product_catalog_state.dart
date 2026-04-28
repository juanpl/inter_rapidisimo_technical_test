import 'package:inter_rapidisimo_technical_test/features/cart/domain/entities/cart_product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

sealed class ProductCatalogState {
  const ProductCatalogState();
}

class ProductCatalogInitial extends ProductCatalogState {
  const ProductCatalogInitial();
}

class ProductCatalogLoading extends ProductCatalogState {
  const ProductCatalogLoading();
}

class ProductCatalogSuccess extends ProductCatalogState {
  const ProductCatalogSuccess({
    required this.products,
    required this.total,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.cartProducts = const [],
    this.loadingProductIds = const {},
  });

  final List<ProductEntity> products;
  final List<CartProductEntity> cartProducts;
  final int total;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final Set<int> loadingProductIds;

  int cartQuantity(int productId) =>
      cartProducts.where((e) => e.product.id == productId).firstOrNull?.quantity ?? 0;

  bool isProductLoading(int productId) => loadingProductIds.contains(productId);

  ProductCatalogSuccess copyWith({
    List<ProductEntity>? products,
    int? total,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    List<CartProductEntity>? cartProducts,
    Set<int>? loadingProductIds,
  }) => ProductCatalogSuccess(
    products: products ?? this.products,
    total: total ?? this.total,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    cartProducts: cartProducts ?? this.cartProducts,
    loadingProductIds: loadingProductIds ?? this.loadingProductIds,
  );
}

class ProductCatalogError extends ProductCatalogState {
  const ProductCatalogError(this.message);

  final String message;
}
