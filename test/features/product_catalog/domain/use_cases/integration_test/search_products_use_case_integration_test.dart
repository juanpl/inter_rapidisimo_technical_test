import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/config/configuration.dart';
import 'package:inter_rapidisimo_technical_test/config/configuration_prod/configuration_prod.dart';
import 'package:inter_rapidisimo_technical_test/core/api/api_client.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/datasources/product_catalog_datasource.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/repository_impl/product_catalog_repository_impl.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/repositories/product_catalog_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/use_cases/search_products_use_case.dart';

void main() {
  late SearchProductsUseCase useCase;

  setUpAll(() {
    Configuration.config = ConfigurationProd().config;
    GetIt.I.registerSingleton<ApiClient>(ApiClient());
    GetIt.I.registerSingleton<ProductCatalogDatasource>(ProductCatalogDatasource());
    GetIt.I.registerSingleton<ProductCatalogRepository>(ProductCatalogRepositoryImpl());
    GetIt.I.registerSingleton<SearchProductsUseCase>(SearchProductsUseCase());
    useCase = GetIt.I<SearchProductsUseCase>();
  });

  tearDownAll(() => GetIt.I.reset());

  group('SearchProductsUseCase - integración', () {
    test('retorna productos que coinciden con la búsqueda', () async {
      final result = await useCase('phone');

      expect(result.products, isNotEmpty);
      expect(result.total, greaterThan(0));
    });

    test('calcula discountedPrice en cada producto del resultado', () async {
      final result = await useCase('phone');

      for (final product in result.products) {
        expect(product.discountedPrice, greaterThan(0));
        expect(product.discountedPrice, lessThanOrEqualTo(product.price));
      }
    });

    test('retorna lista vacía para una búsqueda sin resultados', () async {
      final result = await useCase('xyznonexistentproduct123abc');

      expect(result.products, isEmpty);
      expect(result.total, equals(0));
    });

    test('retorna estructura correcta de ProductCatalogEntity', () async {
      final result = await useCase('laptop');

      expect(result.total, isA<int>());
      expect(result.skip, isA<int>());
      expect(result.limit, isA<int>());
    });
  });
}
