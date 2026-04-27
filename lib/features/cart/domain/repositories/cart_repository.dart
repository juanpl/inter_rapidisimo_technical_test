import 'package:inter_rapidisimo_technical_test/features/cart/domain/entities/cart_product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

abstract interface class CartRepository {
  Future<List<CartProductEntity>> getCart();
  Future<void> addProduct(ProductEntity product, int quantity);
  Future<void> removeProduct(ProductEntity product, int quantity);
}
