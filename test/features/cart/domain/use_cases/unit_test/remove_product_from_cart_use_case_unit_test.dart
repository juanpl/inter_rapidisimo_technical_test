import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/repositories/cart_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/remove_product_from_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late MockCartRepository mockRepository;
  late RemoveProductFromCartUseCase useCase;

  setUpAll(() {
    registerFallbackValue(ProductEntity(
      id: 0, title: '', description: '', category: '',
      price: 0.0, rating: 0.0, discountPercentage: 0.0,
      brand: '', images: [], discountedPrice: 0.0,
    ));
  });

  final tProduct = ProductEntity(
    id: 1,
    title: 'Test Product',
    description: 'Test Description',
    category: 'electronics',
    price: 100.0,
    rating: 4.5,
    discountPercentage: 10.0,
    brand: 'TestBrand',
    images: ['https://example.com/image.jpg'],
  );

  setUp(() {
    mockRepository = MockCartRepository();
    if (GetIt.I.isRegistered<CartRepository>()) {
      GetIt.I.unregister<CartRepository>();
    }
    GetIt.I.registerSingleton<CartRepository>(mockRepository);
    useCase = RemoveProductFromCartUseCase();
  });

  tearDown(() => GetIt.I.reset());

  group('RemoveProductFromCartUseCase', () {
    test('delega correctamente a repository.removeProduct con los parámetros correctos', () async {
      when(() => mockRepository.removeProduct(tProduct, 1)).thenAnswer((_) async {});

      await useCase(tProduct, 1);

      verify(() => mockRepository.removeProduct(tProduct, 1)).called(1);
    });

    test('propaga CustomException cuando el repositorio falla', () {
      when(() => mockRepository.removeProduct(any(), any())).thenThrow(
        const CustomException(message: 'Error al eliminar', code: 'DB_ERROR'),
      );

      expect(
        () => useCase(tProduct, 1),
        throwsA(isA<CustomException>().having((e) => e.code, 'code', 'DB_ERROR')),
      );
    });

    test('acepta cualquier cantidad positiva', () async {
      when(() => mockRepository.removeProduct(any(), any())).thenAnswer((_) async {});

      await useCase(tProduct, 2);

      verify(() => mockRepository.removeProduct(tProduct, 2)).called(1);
    });
  });
}
