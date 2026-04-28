import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_catalog_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/repositories/product_catalog_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/use_cases/search_products_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockProductCatalogRepository extends Mock implements ProductCatalogRepository {}

void main() {
  late MockProductCatalogRepository mockRepository;
  late SearchProductsUseCase useCase;

  final tProduct = ProductEntity(
    id: 1,
    title: 'iPhone',
    description: 'Test Description',
    category: 'smartphones',
    price: 1000.0,
    rating: 4.5,
    discountPercentage: 10.0,
    brand: 'Apple',
    images: ['https://example.com/image.jpg'],
  );

  final tCatalog = ProductCatalogEntity(
    products: [tProduct],
    total: 1,
    skip: 0,
    limit: 10,
  );

  setUp(() {
    mockRepository = MockProductCatalogRepository();
    if (GetIt.I.isRegistered<ProductCatalogRepository>()) {
      GetIt.I.unregister<ProductCatalogRepository>();
    }
    GetIt.I.registerSingleton<ProductCatalogRepository>(mockRepository);
    useCase = SearchProductsUseCase();
  });

  tearDown(() => GetIt.I.reset());

  group('SearchProductsUseCase', () {
    test('calcula discountedPrice redondeado a 2 decimales en resultados de búsqueda', () async {
      when(() => mockRepository.searchProducts(any())).thenAnswer((_) async => tCatalog);

      final result = await useCase('iPhone');

      expect(result.products.first.discountedPrice, equals(900.0));
    });

    test('retorna catalog con todos los productos del resultado', () async {
      final catalogWithMultiple = tCatalog.copyWith(
        products: [
          tProduct,
          tProduct.copyWith(id: 2, price: 500.0, discountPercentage: 20.0),
        ],
        total: 2,
      );
      when(() => mockRepository.searchProducts(any())).thenAnswer((_) async => catalogWithMultiple);

      final result = await useCase('phone');

      expect(result.products.length, equals(2));
      expect(result.products[0].discountedPrice, equals(900.0));
      expect(result.products[1].discountedPrice, equals(400.0));
    });

    test('pasa el query correctamente al repositorio', () async {
      when(() => mockRepository.searchProducts('laptop')).thenAnswer((_) async => tCatalog);

      await useCase('laptop');

      verify(() => mockRepository.searchProducts('laptop')).called(1);
    });

    test('propaga CustomException cuando el repositorio falla', () {
      when(() => mockRepository.searchProducts(any())).thenThrow(
        const CustomException(message: 'Sin conexión', code: 'NO_CONNECTION'),
      );

      expect(
        () => useCase('phone'),
        throwsA(isA<CustomException>().having((e) => e.code, 'code', 'NO_CONNECTION')),
      );
    });
  });
}
