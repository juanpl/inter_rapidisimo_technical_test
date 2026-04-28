import 'package:inter_rapidisimo_technical_test/features/cart/domain/entities/cart_product_entity.dart';

sealed class CartState {
  const CartState();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartSuccess extends CartState {
  const CartSuccess({
    required this.items,
    this.loadingProductIds = const {},
  });

  final List<CartProductEntity> items;
  final Set<int> loadingProductIds;

  bool isProductLoading(int productId) => loadingProductIds.contains(productId);

  double get totalPrice => items.fold(
        0,
        (sum, item) => sum + (item.product.discountedPrice * item.quantity),
      );

  CartSuccess copyWith({
    List<CartProductEntity>? items,
    Set<int>? loadingProductIds,
  }) => CartSuccess(
        items: items ?? this.items,
        loadingProductIds: loadingProductIds ?? this.loadingProductIds,
      );
}

class CartError extends CartState {
  const CartError(this.message);

  final String message;
}
