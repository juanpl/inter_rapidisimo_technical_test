import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_catalog_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/repositories/product_catalog_repository.dart';

class GetProductCatalogUseCase {
  final ProductCatalogRepository _repository;

  GetProductCatalogUseCase()
    : _repository = GetIt.I<ProductCatalogRepository>();

  Future<ProductCatalogEntity> call(int limit, int offset) async {
    final catalog = await _repository.getProductCatalog(limit, offset);
    return catalog.copyWith(
      products: catalog.products
          .map(
            (product) => product.copyWith(
              discountedPrice: double.parse(
                (product.price * (1 - product.discountPercentage / 100))
                    .toStringAsFixed(2),
              ),
            ),
          )
          .toList(),
    );
  }
}
