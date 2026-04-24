import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product.dart';

abstract interface class ProductCatalogRepository {
  List<Product> getProductCatalog(int limit, int offset);
}
