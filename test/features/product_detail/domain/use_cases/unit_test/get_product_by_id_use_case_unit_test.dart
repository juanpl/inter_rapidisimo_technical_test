import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/domain/repository/product_detail_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/domain/use_cases/get_product_by_id_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockProductDetailRepository extends Mock implements ProductDetailRepository {}

void main() {
  late MockProductDetailRepository mockRepository;
  late GetProductByIdUseCase useCase;

  final tProduct = ProductEntity(
    id: 1,
    title: 'Essence Mascara',
    description: 'Test Description',
    category: 'beauty',
    price: 10.0,
    rating: 4.94,
    discountPercentage: 10.0,
    brand: 'Essence',
    images: ['https://cdn.dummyjson.com/1.webp'],
  );

  setUp(() {
    mockRepository = MockProductDetailRepository();
    if (GetIt.I.isRegistered<ProductDetailRepository>()) {
      GetIt.I.unregister<ProductDetailRepository>();
    }
    GetIt.I.registerSingleton<ProductDetailRepository>(mockRepository);
    useCase = GetProductByIdUseCase();
  });

  tearDown(() => GetIt.I.reset());

  group('GetProductByIdUseCase', () {
    test('calcula discountedPrice redondeado a 2 decimales', () async {
      when(() => mockRepository.getProductById(1)).thenAnswer((_) async => tProduct);

      final result = await useCase(1);

      expect(result.discountedPrice, equals(9.0));
    });

    test('retorna el producto con el id correcto', () async {
      when(() => mockRepository.getProductById(1)).thenAnswer((_) async => tProduct);

      final result = await useCase(1);

      expect(result.id, equals(1));
      expect(result.title, equals('Essence Mascara'));
    });

    test('pasa el id correctamente al repositorio', () async {
      when(() => mockRepository.getProductById(42)).thenAnswer((_) async => tProduct.copyWith(id: 42));

      await useCase(42);

      verify(() => mockRepository.getProductById(42)).called(1);
    });

    test('propaga CustomException cuando el repositorio falla', () {
      when(() => mockRepository.getProductById(any())).thenThrow(
        const CustomException(message: 'Producto no encontrado', code: '404'),
      );

      expect(
        () => useCase(1),
        throwsA(isA<CustomException>().having((e) => e.code, 'code', '404')),
      );
    });

    test('discountedPrice es menor que price cuando hay descuento', () async {
      when(() => mockRepository.getProductById(1)).thenAnswer((_) async => tProduct);

      final result = await useCase(1);

      expect(result.discountedPrice, lessThan(result.price));
    });
  });
}
