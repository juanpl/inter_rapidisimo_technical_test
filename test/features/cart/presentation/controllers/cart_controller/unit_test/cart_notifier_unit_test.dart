import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/entities/cart_product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/repositories/cart_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/add_product_to_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/remove_product_from_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/presentation/controllers/cart_controller/events/cart_event.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/presentation/controllers/cart_controller/providers/cart_provider.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/presentation/controllers/cart_controller/states/cart_state.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late MockCartRepository mockCartRepo;

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
    description: 'Desc',
    category: 'electronics',
    price: 100.0,
    rating: 4.5,
    discountPercentage: 10.0,
    brand: 'Brand',
    images: ['https://example.com/img.jpg'],
    discountedPrice: 90.0,
  );

  setUp(() {
    mockCartRepo = MockCartRepository();
    GetIt.I.registerSingleton<CartRepository>(mockCartRepo);
    GetIt.I.registerSingleton<GetCartUseCase>(GetCartUseCase());
    GetIt.I.registerSingleton<AddProductToCartUseCase>(AddProductToCartUseCase());
    GetIt.I.registerSingleton<RemoveProductFromCartUseCase>(RemoveProductFromCartUseCase());

    when(() => mockCartRepo.getCart()).thenAnswer((_) async => []);
    when(() => mockCartRepo.addProduct(any(), any())).thenAnswer((_) async {});
    when(() => mockCartRepo.removeProduct(any(), any())).thenAnswer((_) async {});
  });

  tearDown(() => GetIt.I.reset());

  ProviderContainer buildContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('CartNotifier', () {
    test('estado inicial es CartLoading', () {
      final container = buildContainer();
      expect(container.read(cartProvider), isA<CartLoading>());
    });

    test('después de LoadCart exitoso el estado es CartSuccess', () async {
      final container = buildContainer();
      container.read(cartProvider);
      await Future.delayed(Duration.zero);

      expect(container.read(cartProvider), isA<CartSuccess>());
    });

    test('CartSuccess con carrito vacío tiene items vacíos', () async {
      final container = buildContainer();
      container.read(cartProvider);
      await Future.delayed(Duration.zero);

      final state = container.read(cartProvider) as CartSuccess;
      expect(state.items, isEmpty);
    });

    test('CartSuccess con items refleja los productos del repositorio', () async {
      final cartItem = CartProductEntity(product: tProduct, quantity: 2);
      when(() => mockCartRepo.getCart()).thenAnswer((_) async => [cartItem]);

      final container = buildContainer();
      container.read(cartProvider);
      await Future.delayed(Duration.zero);

      final state = container.read(cartProvider) as CartSuccess;
      expect(state.items.length, equals(1));
      expect(state.items.first.quantity, equals(2));
    });

    test('después de LoadCart fallido el estado es CartError', () async {
      when(() => mockCartRepo.getCart()).thenThrow(
        const CustomException(message: 'Error DB', code: 'DB_ERROR'),
      );

      final container = buildContainer();
      container.read(cartProvider);
      await Future.delayed(Duration.zero);

      expect(container.read(cartProvider), isA<CartError>());
    });

    test('AddToCart incrementa la cantidad del producto en el estado', () async {
      final cartItem = CartProductEntity(product: tProduct, quantity: 1);
      when(() => mockCartRepo.getCart()).thenAnswer((_) async => [cartItem]);

      final container = buildContainer();
      container.read(cartProvider);
      await Future.delayed(Duration.zero);

      await container.read(cartProvider.notifier).add(AddToCart(tProduct));

      final state = container.read(cartProvider) as CartSuccess;
      expect(state.items.first.quantity, equals(2));
    });

    test('RemoveFromCart decrementa la cantidad del producto en el estado', () async {
      final cartItem = CartProductEntity(product: tProduct, quantity: 2);
      when(() => mockCartRepo.getCart()).thenAnswer((_) async => [cartItem]);

      final container = buildContainer();
      container.read(cartProvider);
      await Future.delayed(Duration.zero);

      await container.read(cartProvider.notifier).add(RemoveFromCart(tProduct));

      final state = container.read(cartProvider) as CartSuccess;
      expect(state.items.first.quantity, equals(1));
    });

    test('RemoveFromCart elimina el producto cuando la cantidad llega a 0', () async {
      final cartItem = CartProductEntity(product: tProduct, quantity: 1);
      when(() => mockCartRepo.getCart()).thenAnswer((_) async => [cartItem]);

      final container = buildContainer();
      container.read(cartProvider);
      await Future.delayed(Duration.zero);

      await container.read(cartProvider.notifier).add(RemoveFromCart(tProduct));

      final state = container.read(cartProvider) as CartSuccess;
      expect(state.items, isEmpty);
    });

    test('totalPrice calcula correctamente el total del carrito', () async {
      final cartItems = [
        CartProductEntity(product: tProduct, quantity: 2),
        CartProductEntity(product: tProduct.copyWith(id: 2, price: 50.0, discountPercentage: 0.0), quantity: 1),
      ];
      when(() => mockCartRepo.getCart()).thenAnswer((_) async => cartItems);

      final container = buildContainer();
      container.read(cartProvider);
      await Future.delayed(Duration.zero);

      final state = container.read(cartProvider) as CartSuccess;
      expect(state.totalPrice, equals(230.0));
    });
  });
}
