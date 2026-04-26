import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/config/configuration.dart';
import 'package:inter_rapidisimo_technical_test/config/schema_configuration.dart';
import 'package:inter_rapidisimo_technical_test/core/api/api_client.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/datasources/product_catalog_datasource.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/repository_impl/product_catalog_repository_impl.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_catalog_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/repositories/product_catalog_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/use_cases/get_product_catalog_use_case.dart';

void main() {
  late GetProductCatalogUseCase useCase;

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
    GetIt.I.registerSingleton<ProductCatalogRepository>(
      ProductCatalogRepositoryImpl(),
    );
  });

  tearDownAll(() => GetIt.I.reset());

  setUp(() {
    useCase = GetProductCatalogUseCase();
  });

  group('GetProductCatalogUseCase - integración', () {
    test('retorna ProductCatalogEntity con la estructura correcta', () async {
      final result = await useCase(10, 0);

      expect(result, isA<ProductCatalogEntity>());
      expect(result.products, isA<List<ProductEntity>>());
      expect(result.products, isNotEmpty);
      expect(result.total, isA<int>());
    });

    test('calcula discountedPrice redondeado a 2 decimales', () async {
      final result = await useCase(5, 0);

      for (final product in result.products) {
        final expected = double.parse(
          (product.price * (1 - product.discountPercentage / 100))
              .toStringAsFixed(2),
        );
        expect(product.discountedPrice, equals(expected));
      }
    });

    test('discountedPrice es menor que price', () async {
      final result = await useCase(5, 0);

      for (final product in result.products) {
        expect(product.discountedPrice, lessThan(product.price));
      }
    });

    test('respeta el parámetro limit', () async {
      final result = await useCase(3, 0);

      expect(result.products.length, equals(3));
    });

    test('respeta el parámetro offset', () async {
      final page1 = await useCase(1, 0);
      final page2 = await useCase(1, 1);

      expect(page1.products.first.id, isNot(equals(page2.products.first.id)));
    });
  });
}
