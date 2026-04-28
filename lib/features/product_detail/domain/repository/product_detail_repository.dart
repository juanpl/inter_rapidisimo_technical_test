import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

abstract interface class ProductDetailRepository {
  Future<ProductEntity> getProductById(int id);
}
