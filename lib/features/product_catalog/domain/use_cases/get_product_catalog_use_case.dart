import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/repositories/product_catalog_repository.dart';

class GetProductCatalogUseCase {
  final ProductCatalogRepository _repository;

  GetProductCatalogUseCase()
    : _repository = GetIt.I<ProductCatalogRepository>();

  Future<List<Product>> call(int limit, int offset) async {
    return _repository.getProductCatalog(limit, offset);
  }
}
