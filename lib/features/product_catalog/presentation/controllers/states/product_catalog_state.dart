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
  });

  final List<ProductEntity> products;
  final int total;
  final bool isLoadingMore;
  final bool hasReachedEnd;

  ProductCatalogSuccess copyWith({
    List<ProductEntity>? products,
    int? total,
    bool? isLoadingMore,
    bool? hasReachedEnd,
  }) => ProductCatalogSuccess(
    products: products ?? this.products,
    total: total ?? this.total,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
  );
}

class ProductCatalogError extends ProductCatalogState {
  const ProductCatalogError(this.message);

  final String message;
}
