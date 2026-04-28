import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

sealed class ProductDetailState {
  const ProductDetailState();
}

class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

class ProductDetailSuccess extends ProductDetailState {
  const ProductDetailSuccess({
    required this.product,
    this.cartQuantity = 0,
    this.isCartLoading = false,
  });

  final ProductEntity product;
  final int cartQuantity;
  final bool isCartLoading;

  ProductDetailSuccess copyWith({
    ProductEntity? product,
    int? cartQuantity,
    bool? isCartLoading,
  }) => ProductDetailSuccess(
    product: product ?? this.product,
    cartQuantity: cartQuantity ?? this.cartQuantity,
    isCartLoading: isCartLoading ?? this.isCartLoading,
  );
}

class ProductDetailError extends ProductDetailState {
  const ProductDetailError(this.message);

  final String message;
}
