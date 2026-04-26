import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_catalog_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/repositories/product_catalog_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/use_cases/get_product_catalog_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockProductCatalogRepository extends Mock
    implements ProductCatalogRepository {}

void main() {
  late MockProductCatalogRepository mockRepository;
  late GetProductCatalogUseCase useCase;

  final tProduct = ProductEntity(
    id: 1,
    title: 'Essence Mascara',
    description: 'Test',
    category: 'beauty',
    price: 10.00,
    raiting: 4.5,
    discountPercentage: 10.0,
    brand: 'Essence',
    images: ['https://cdn.dummyjson.com/1.webp'],
  );

  final tCatalog = ProductCatalogEntity(
    products: [tProduct],
    total: 100,
    skip: 0,
    limit: 10,
  );

  setUp(() {
    mockRepository = MockProductCatalogRepository();
    if (GetIt.I.isRegistered<ProductCatalogRepository>()) {
      GetIt.I.unregister<ProductCatalogRepository>();
    }
    GetIt.I.registerSingleton<ProductCatalogRepository>(mockRepository);
    useCase = GetProductCatalogUseCase();
  });

  tearDown(() => GetIt.I.reset());

  group('GetProductCatalogUseCase', () {
    test('calcula discountedPrice redondeado a 2 decimales', () async {
      when(() => mockRepository.getProductCatalog(any(), any()))
          .thenAnswer((_) async => tCatalog);

      final result = await useCase(10, 0);

      expect(result.products.first.discountedPrice, equals(9.00));
    });

    test('lanza CustomException cuando el repositorio falla', () {
      when(() => mockRepository.getProductCatalog(any(), any()))
          .thenThrow(const CustomException(message: 'Sin conexión', code: 'NO_CONNECTION'));

      expect(
        () => useCase(10, 0),
        throwsA(isA<CustomException>().having((e) => e.code, 'code', 'NO_CONNECTION')),
      );
    });

    test('retorna catalog con discountedPrice en todos los productos', () async {
      final catalogWithMultiple = tCatalog.copyWith(
        products: [
          tProduct,
          tProduct.copyWith(id: 2, price: 20.00, discountPercentage: 20.0),
        ],
      );
      when(() => mockRepository.getProductCatalog(any(), any()))
          .thenAnswer((_) async => catalogWithMultiple);

      final result = await useCase(10, 0);

      expect(result.products[0].discountedPrice, equals(9.00));
      expect(result.products[1].discountedPrice, equals(16.00));
    });
  });
}
