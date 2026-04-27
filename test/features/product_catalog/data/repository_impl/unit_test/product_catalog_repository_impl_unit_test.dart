import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/datasources/product_catalog_datasource.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/repository_impl/product_catalog_repository_impl.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_catalog_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockProductCatalogDatasource extends Mock
    implements ProductCatalogDatasource {}

void main() {
  late MockProductCatalogDatasource mockDatasource;
  late ProductCatalogRepositoryImpl repository;

  final tResponse = {
    'products': [
      {
        'id': 1,
        'title': 'Essence Mascara',
        'description': 'Test description',
        'category': 'beauty',
        'price': 9.99,
        'rating': 4.94,
        'discountPercentage': 7.17,
        'brand': 'Essence',
        'images': ['https://cdn.dummyjson.com/1.webp'],
      },
    ],
    'total': 194,
    'skip': 0,
    'limit': 10,
  };

  setUp(() {
    mockDatasource = MockProductCatalogDatasource();
    if (GetIt.I.isRegistered<ProductCatalogDatasource>()) {
      GetIt.I.unregister<ProductCatalogDatasource>();
    }
    GetIt.I.registerSingleton<ProductCatalogDatasource>(mockDatasource);
    repository = ProductCatalogRepositoryImpl();
  });

  tearDown(() => GetIt.I.reset());

  group('ProductCatalogRepositoryImpl', () {
    test('retorna ProductCatalogEntity cuando el datasource responde correctamente', () async {
      when(() => mockDatasource.getProductCatalog(limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer((_) async => tResponse);

      final result = await repository.getProductCatalog(10, 0);

      expect(result, isA<ProductCatalogEntity>());
      expect(result.total, equals(194));
      expect(result.products.length, equals(1));
      expect(result.products.first.title, equals('Essence Mascara'));
    });

    test('lanza CustomException cuando el datasource lanza CustomException', () {
      when(() => mockDatasource.getProductCatalog(limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenThrow(const CustomException(message: 'Sin conexión', code: 'NO_CONNECTION'));

      expect(
        () => repository.getProductCatalog(10, 0),
        throwsA(isA<CustomException>().having((e) => e.code, 'code', 'NO_CONNECTION')),
      );
    });

    test('lanza CustomException con code UNKNOWN cuando el parseo falla', () {
      when(() => mockDatasource.getProductCatalog(limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer((_) async => {'unexpected': 'data'});

      expect(
        () => repository.getProductCatalog(10, 0),
        throwsA(isA<CustomException>().having((e) => e.code, 'code', 'UNKNOWN')),
      );
    });
  });
}
