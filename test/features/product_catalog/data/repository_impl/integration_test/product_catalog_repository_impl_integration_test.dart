import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/config/configuration.dart';
import 'package:inter_rapidisimo_technical_test/config/schema_configuration.dart';
import 'package:inter_rapidisimo_technical_test/core/api/api_client.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/datasources/product_catalog_datasource.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/repository_impl/product_catalog_repository_impl.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_catalog_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

void main() {
  late ProductCatalogRepositoryImpl repository;

  setUpAll(() {
    Configuration.config = SchemaConfiguration(
      appName: 'Test',
      companyName: 'Test',
      endpoints: ConfigurationEndpoints(
        productEndPoint: 'https://dummyjson.com/products',
      ),
    );
    GetIt.I.registerSingleton<ApiClient>(ApiClient());
    GetIt.I.registerSingleton<ProductCatalogDatasource>(
      ProductCatalogDatasource(),
    );
  });

  tearDownAll(() => GetIt.I.reset());

  setUp(() {
    repository = ProductCatalogRepositoryImpl();
  });

  group('getProductCatalog - integración', () {
    test('retorna ProductCatalogEntity con la estructura correcta', () async {
      final result = await repository.getProductCatalog(10, 0);

      expect(result, isA<ProductCatalogEntity>());
      expect(result.total, isA<int>());
      expect(result.skip, equals(0));
      expect(result.limit, equals(10));
      expect(result.products, isA<List<ProductEntity>>());
      expect(result.products, isNotEmpty);
    });

    test('products contiene entidades con los campos correctos', () async {
      final result = await repository.getProductCatalog(1, 0);
      final product = result.products.first;

      expect(product.id, isA<int>());
      expect(product.title, isA<String>());
      expect(product.description, isA<String>());
      expect(product.category, isA<String>());
      expect(product.price, isA<double>());
      expect(product.brand, isA<String>());
      expect(product.images, isA<List<String>>());
    });

    test('respeta el parámetro limit', () async {
      final result = await repository.getProductCatalog(5, 0);

      expect(result.products.length, equals(5));
      expect(result.limit, equals(5));
    });

    test('respeta el parámetro offset', () async {
      final page1 = await repository.getProductCatalog(1, 0);
      final page2 = await repository.getProductCatalog(1, 1);

      expect(page1.products.first.id, isNot(equals(page2.products.first.id)));
      expect(page2.skip, equals(1));
    });

    test('lanza CustomException cuando el parseo falla', () async {
      GetIt.I.unregister<ProductCatalogDatasource>();
      GetIt.I.registerSingleton<ProductCatalogDatasource>(_BrokenDatasource());
      repository = ProductCatalogRepositoryImpl();

      expect(
        () => repository.getProductCatalog(10, 0),
        throwsA(isA<CustomException>().having((e) => e.code, 'code', 'UNKNOWN')),
      );

      GetIt.I.unregister<ProductCatalogDatasource>();
      GetIt.I.registerSingleton<ProductCatalogDatasource>(
        ProductCatalogDatasource(),
      );
    });
  });
}

class _BrokenDatasource extends ProductCatalogDatasource {
  @override
  Future<Map<String, dynamic>> getProductCatalog({
    required int limit,
    required int offset,
  }) async =>
      {'unexpected_key': 'bad_data'};
}
