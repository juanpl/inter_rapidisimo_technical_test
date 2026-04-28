import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/entities/cart_product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/repositories/cart_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late MockCartRepository mockRepository;
  late GetCartUseCase useCase;

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
    useCase = GetCartUseCase();
  });

  tearDown(() => GetIt.I.reset());

  group('GetCartUseCase', () {
    test('retorna lista vacía cuando el carrito está vacío', () async {
      when(() => mockRepository.getCart()).thenAnswer((_) async => []);

      final result = await useCase();

      expect(result, isEmpty);
    });

    test('calcula discountedPrice correctamente para cada item', () async {
      final cartItem = CartProductEntity(product: tProduct, quantity: 2);
      when(() => mockRepository.getCart()).thenAnswer((_) async => [cartItem]);

      final result = await useCase();

      expect(result.first.product.discountedPrice, equals(90.0));
    });

    test('calcula discountedPrice redondeado a 2 decimales', () async {
      final productWithOddDiscount = tProduct.copyWith(
        price: 9.99,
        discountPercentage: 7.17,
      );
      final cartItem = CartProductEntity(product: productWithOddDiscount, quantity: 1);
      when(() => mockRepository.getCart()).thenAnswer((_) async => [cartItem]);

      final result = await useCase();

      expect(result.first.product.discountedPrice, equals(9.27));
    });

    test('preserva la cantidad de cada item', () async {
      final cartItem = CartProductEntity(product: tProduct, quantity: 3);
      when(() => mockRepository.getCart()).thenAnswer((_) async => [cartItem]);

      final result = await useCase();

      expect(result.first.quantity, equals(3));
    });

    test('propaga CustomException cuando el repositorio falla', () {
      when(() => mockRepository.getCart()).thenThrow(
        const CustomException(message: 'Error al obtener carrito', code: 'DB_ERROR'),
      );

      expect(
        () => useCase(),
        throwsA(isA<CustomException>()),
      );
    });
  });
}
