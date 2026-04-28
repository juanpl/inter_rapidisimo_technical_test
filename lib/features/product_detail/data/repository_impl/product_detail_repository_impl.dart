import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/models/product_model.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/data/datasources/product_detail_datasource.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/domain/repository/product_detail_repository.dart';

class ProductDetailRepositoryImpl implements ProductDetailRepository {
  final ProductDetailDatasource _datasource;

  ProductDetailRepositoryImpl()
    : _datasource = GetIt.I<ProductDetailDatasource>();

  @override
  Future<ProductEntity> getProductById(int id) async {
    final response = await _datasource.getProductById(id);
    try {
      final model = ProductModel.fromJson(response);
      return ProductEntity.fromModel(model);
    } on CustomException {
      rethrow;
    } catch (_) {
      throw CustomException(
        message: 'ProductDetailRepositoryImpl_getProductById_Error',
        code: 'UNKNOWN',
      );
    }
  }
}
