import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/entities/cart_product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository _repository;

  GetCartUseCase() : _repository = GetIt.I<CartRepository>();

  Future<List<CartProductEntity>> call() async {
    return _repository.getCart();
  }
}
