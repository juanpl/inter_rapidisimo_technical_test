import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/repositories/cart_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

class RemoveProductFromCartUseCase {
  final CartRepository _repository;

  RemoveProductFromCartUseCase() : _repository = GetIt.I<CartRepository>();

  Future<void> call(ProductEntity product, int quantity) async {
    return _repository.removeProduct(product, quantity);
  }
}
