import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_catalog_entity.dart';

abstract interface class ProductCatalogRepository {
  Future<ProductCatalogEntity> getProductCatalog(int limit, int offset);
}
