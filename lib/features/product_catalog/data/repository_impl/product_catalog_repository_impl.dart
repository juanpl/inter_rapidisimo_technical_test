import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/datasources/product_catalog_datasource.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/models/product_catalog_model.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_catalog_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/repositories/product_catalog_repository.dart';

class ProductCatalogRepositoryImpl implements ProductCatalogRepository {
  final ProductCatalogDatasource _productCatalogDatasource;

  ProductCatalogRepositoryImpl()
    : _productCatalogDatasource = GetIt.I<ProductCatalogDatasource>();

  @override
  Future<ProductCatalogEntity> getProductCatalog(int limit, int offset) async {
    final response = await _productCatalogDatasource.getProductCatalog(
      limit: limit,
      offset: offset,
    );
    try {
      final productCatalogModel = ProductCatalogModel.fromJson(response);
      return ProductCatalogEntity.fromModel(productCatalogModel);
    } on CustomException {
      rethrow;
    } catch (_) {
      throw CustomException(message: 'Error inesperado', code: 'UNKNOWN');
    }
  }

  @override
  Future<ProductCatalogEntity> searchProducts(String query) async {
    final response = await _productCatalogDatasource.searchProducts(
      query: query,
    );
    try {
      final productCatalogModel = ProductCatalogModel.fromJson(response);
      return ProductCatalogEntity.fromModel(productCatalogModel);
    } on CustomException {
      rethrow;
    } catch (_) {
      throw CustomException(message: 'Error inesperado', code: 'UNKNOWN');
    }
  }
}
