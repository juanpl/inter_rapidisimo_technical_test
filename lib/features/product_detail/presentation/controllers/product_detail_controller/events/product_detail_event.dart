import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

sealed class ProductDetailEvent {
  const ProductDetailEvent();
}

class LoadProductDetail extends ProductDetailEvent {
  const LoadProductDetail(this.productId);

  final int productId;
}

class AddToCart extends ProductDetailEvent {
  const AddToCart(this.product);

  final ProductEntity product;
}

class RemoveFromCart extends ProductDetailEvent {
  const RemoveFromCart(this.product);

  final ProductEntity product;
}
