import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/entities/cart_product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/repositories/cart_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/add_product_to_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/remove_product_from_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/domain/repository/product_detail_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/domain/use_cases/get_product_by_id_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/presentation/controllers/product_detail_controller/events/product_detail_event.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/presentation/controllers/product_detail_controller/providers/product_detail_provider.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/presentation/controllers/product_detail_controller/states/product_detail_state.dart';
import 'package:mocktail/mocktail.dart';

class MockProductDetailRepository extends Mock implements ProductDetailRepository {}
class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late MockProductDetailRepository mockDetailRepo;
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
    mockDetailRepo = MockProductDetailRepository();
    mockCartRepo = MockCartRepository();

    GetIt.I.registerSingleton<ProductDetailRepository>(mockDetailRepo);
    GetIt.I.registerSingleton<CartRepository>(mockCartRepo);
    GetIt.I.registerSingleton<GetProductByIdUseCase>(GetProductByIdUseCase());
    GetIt.I.registerSingleton<GetCartUseCase>(GetCartUseCase());
    GetIt.I.registerSingleton<AddProductToCartUseCase>(AddProductToCartUseCase());
    GetIt.I.registerSingleton<RemoveProductFromCartUseCase>(RemoveProductFromCartUseCase());

    when(() => mockDetailRepo.getProductById(any())).thenAnswer((_) async => tProduct);
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

  group('ProductDetailNotifier', () {
    test('estado inicial es ProductDetailLoading', () {
      final container = buildContainer();
      expect(container.read(productDetailProvider(1)), isA<ProductDetailLoading>());
    });

    test('después de LoadProductDetail exitoso el estado es ProductDetailSuccess', () async {
      final container = buildContainer();
      container.read(productDetailProvider(1));
      await Future.delayed(Duration.zero);

      expect(container.read(productDetailProvider(1)), isA<ProductDetailSuccess>());
    });

    test('ProductDetailSuccess contiene el producto correcto', () async {
      final container = buildContainer();
      container.read(productDetailProvider(1));
      await Future.delayed(Duration.zero);

      final state = container.read(productDetailProvider(1)) as ProductDetailSuccess;
      expect(state.product.id, equals(1));
      expect(state.product.title, equals('Test Product'));
    });

    test('cartQuantity inicial es 0 cuando el carrito está vacío', () async {
      final container = buildContainer();
      container.read(productDetailProvider(1));
      await Future.delayed(Duration.zero);

      final state = container.read(productDetailProvider(1)) as ProductDetailSuccess;
      expect(state.cartQuantity, equals(0));
    });

    test('cartQuantity refleja la cantidad en carrito cuando existe el producto', () async {
      final cartItem = CartProductEntity(product: tProduct, quantity: 3);
      when(() => mockCartRepo.getCart()).thenAnswer((_) async => [cartItem]);

      final container = buildContainer();
      container.read(productDetailProvider(1));
      await Future.delayed(Duration.zero);

      final state = container.read(productDetailProvider(1)) as ProductDetailSuccess;
      expect(state.cartQuantity, equals(3));
    });

    test('después de LoadProductDetail fallido el estado es ProductDetailError', () async {
      when(() => mockDetailRepo.getProductById(any())).thenThrow(
        const CustomException(message: 'Producto no encontrado', code: '404'),
      );

      final container = buildContainer();
      container.read(productDetailProvider(1));
      await Future.delayed(Duration.zero);

      expect(container.read(productDetailProvider(1)), isA<ProductDetailError>());
    });

    test('AddToCart incrementa cartQuantity en el estado', () async {
      final container = buildContainer();
      container.read(productDetailProvider(1));
      await Future.delayed(Duration.zero);

      await container.read(productDetailProvider(1).notifier).add(AddToCart(tProduct));

      final state = container.read(productDetailProvider(1)) as ProductDetailSuccess;
      expect(state.cartQuantity, equals(1));
    });

    test('RemoveFromCart decrementa cartQuantity en el estado', () async {
      final cartItem = CartProductEntity(product: tProduct, quantity: 2);
      when(() => mockCartRepo.getCart()).thenAnswer((_) async => [cartItem]);

      final container = buildContainer();
      container.read(productDetailProvider(1));
      await Future.delayed(Duration.zero);

      await container.read(productDetailProvider(1).notifier).add(RemoveFromCart(tProduct));

      final state = container.read(productDetailProvider(1)) as ProductDetailSuccess;
      expect(state.cartQuantity, equals(1));
    });

    test('RemoveFromCart no baja de 0 en cartQuantity', () async {
      final container = buildContainer();
      container.read(productDetailProvider(1));
      await Future.delayed(Duration.zero);

      await container.read(productDetailProvider(1).notifier).add(RemoveFromCart(tProduct));

      final state = container.read(productDetailProvider(1)) as ProductDetailSuccess;
      expect(state.cartQuantity, equals(0));
    });
  });
}
