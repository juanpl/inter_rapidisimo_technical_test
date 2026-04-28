import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/repositories/cart_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

class AddProductToCartUseCase {
  final CartRepository _repository;

  AddProductToCartUseCase() : _repository = GetIt.I<CartRepository>();

  Future<void> call(ProductEntity product, int quantity) async {
    return _repository.addProduct(product, quantity);
  }
}
