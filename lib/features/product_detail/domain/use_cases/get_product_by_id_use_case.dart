import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/domain/repository/product_detail_repository.dart';

class GetProductByIdUseCase {
  final ProductDetailRepository _repository;

  GetProductByIdUseCase() : _repository = GetIt.I<ProductDetailRepository>();

  Future<ProductEntity> call(int id) async {
    final product = await _repository.getProductById(id);
    return product.copyWith(
      discountedPrice: double.parse(
        (product.price * (1 - product.discountPercentage / 100))
            .toStringAsFixed(2),
      ),
    );
  }
}
