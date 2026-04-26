import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/config/configuration.dart';
import 'package:inter_rapidisimo_technical_test/config/schema_configuration.dart';
import 'package:inter_rapidisimo_technical_test/core/api/api_client.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/datasources/product_catalog_datasource.dart';

void main() {
  late ProductCatalogDatasource datasource;

  setUpAll(() {
    Configuration.config = SchemaConfiguration(
      appName: 'Test',
      companyName: 'Test',
      endpoints: ConfigurationEndpoints(
        productEndPoint: 'https://dummyjson.com/products',
      ),
    );
    GetIt.I.registerSingleton<ApiClient>(ApiClient());
  });

  tearDownAll(() => GetIt.I.reset());

  setUp(() {
    datasource = ProductCatalogDatasource();
  });

  group('getProductCatalog - integración', () {
    test('retorna la estructura correcta de la API', () async {
      final result = await datasource.getProductCatalog(limit: 10, offset: 0);

      expect(result, contains('products'));
      expect(result, contains('total'));
      expect(result, contains('skip'));
      expect(result, contains('limit'));
      expect(result['products'], isA<List>());
    });

    test('respeta el parámetro limit', () async {
      final result = await datasource.getProductCatalog(limit: 5, offset: 0);

      final products = result['products'] as List;
      expect(products.length, equals(5));
    });

    test('respeta el parámetro offset', () async {
      final resultPage1 = await datasource.getProductCatalog(limit: 1, offset: 0);
      final resultPage2 = await datasource.getProductCatalog(limit: 1, offset: 1);

      final firstProduct = (resultPage1['products'] as List).first;
      final secondProduct = (resultPage2['products'] as List).first;
      expect(firstProduct['id'], isNot(equals(secondProduct['id'])));
    });

  });
}
