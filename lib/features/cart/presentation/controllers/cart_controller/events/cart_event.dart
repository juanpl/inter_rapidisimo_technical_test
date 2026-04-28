import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

sealed class CartEvent {
  const CartEvent();
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class AddToCart extends CartEvent {
  const AddToCart(this.product);
  final ProductEntity product;
}

class RemoveFromCart extends CartEvent {
  const RemoveFromCart(this.product);
  final ProductEntity product;
}
