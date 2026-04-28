import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/entities/cart_product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/repositories/cart_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/add_product_to_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/remove_product_from_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_catalog_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/repositories/product_catalog_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/use_cases/get_product_catalog_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/use_cases/search_products_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/controllers/product_catalog_contoller/events/product_catalog_event.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/controllers/product_catalog_contoller/providers/product_catalog_provider.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/controllers/product_catalog_contoller/states/product_catalog_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockProductCatalogRepository extends Mock implements ProductCatalogRepository {}
class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late MockProductCatalogRepository mockCatalogRepo;
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

  final tCatalog = ProductCatalogEntity(
    products: [tProduct],
    total: 1,
    skip: 0,
    limit: 10,
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    mockCatalogRepo = MockProductCatalogRepository();
    mockCartRepo = MockCartRepository();

    GetIt.I.registerSingleton<ProductCatalogRepository>(mockCatalogRepo);
    GetIt.I.registerSingleton<CartRepository>(mockCartRepo);
    GetIt.I.registerSingleton<GetProductCatalogUseCase>(GetProductCatalogUseCase());
    GetIt.I.registerSingleton<SearchProductsUseCase>(SearchProductsUseCase());
    GetIt.I.registerSingleton<GetCartUseCase>(GetCartUseCase());
    GetIt.I.registerSingleton<AddProductToCartUseCase>(AddProductToCartUseCase());
    GetIt.I.registerSingleton<RemoveProductFromCartUseCase>(RemoveProductFromCartUseCase());

    when(() => mockCatalogRepo.getProductCatalog(any(), any()))
        .thenAnswer((_) async => tCatalog);
    when(() => mockCatalogRepo.searchProducts(any()))
        .thenAnswer((_) async => tCatalog);
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

  group('ProductCatalogNotifier', () {
    test('estado inicial es ProductCatalogLoading', () {
      final container = buildContainer();
      expect(container.read(productCatalogProvider), isA<ProductCatalogLoading>());
    });

    test('después de LoadProductCatalog exitoso el estado es ProductCatalogSuccess', () async {
      final container = buildContainer();
      container.read(productCatalogProvider);
      await Future.delayed(Duration.zero);

      expect(container.read(productCatalogProvider), isA<ProductCatalogSuccess>());
    });

    test('ProductCatalogSuccess contiene los productos correctos', () async {
      final container = buildContainer();
      container.read(productCatalogProvider);
      await Future.delayed(Duration.zero);

      final state = container.read(productCatalogProvider) as ProductCatalogSuccess;
      expect(state.products.length, equals(1));
      expect(state.products.first.id, equals(1));
    });

    test('después de LoadProductCatalog fallido sin caché el estado es ProductCatalogError', () async {
      when(() => mockCatalogRepo.getProductCatalog(any(), any())).thenThrow(
        const CustomException(message: 'Sin conexión', code: 'NO_CONNECTION'),
      );
      final container = buildContainer();
      container.read(productCatalogProvider);
      await Future.delayed(Duration.zero);

      expect(container.read(productCatalogProvider), isA<ProductCatalogError>());
    });

    test('SearchProducts con query no vacío activa isSearchMode', () async {
      final container = buildContainer();
      container.read(productCatalogProvider);
      await Future.delayed(Duration.zero);

      await container.read(productCatalogProvider.notifier).add(const SearchProducts('phone'));

      final state = container.read(productCatalogProvider) as ProductCatalogSuccess;
      expect(state.isSearchMode, isTrue);
    });

    test('SearchProducts con query vacío recarga el catálogo normal', () async {
      final container = buildContainer();
      container.read(productCatalogProvider);
      await Future.delayed(Duration.zero);

      await container.read(productCatalogProvider.notifier).add(const SearchProducts(''));

      final state = container.read(productCatalogProvider) as ProductCatalogSuccess;
      expect(state.isSearchMode, isFalse);
    });

    test('AddToCart actualiza cartProducts en el estado', () async {
      final container = buildContainer();
      container.read(productCatalogProvider);
      await Future.delayed(Duration.zero);

      await container.read(productCatalogProvider.notifier).add(AddToCart(tProduct));

      final state = container.read(productCatalogProvider) as ProductCatalogSuccess;
      expect(state.cartQuantity(tProduct.id), equals(1));
    });

    test('RemoveFromCart actualiza cartProducts en el estado', () async {
      final cartItem = CartProductEntity(product: tProduct, quantity: 2);
      when(() => mockCartRepo.getCart()).thenAnswer((_) async => [cartItem]);

      final container = buildContainer();
      container.read(productCatalogProvider);
      await Future.delayed(Duration.zero);

      await container.read(productCatalogProvider.notifier).add(RemoveFromCart(tProduct));

      final state = container.read(productCatalogProvider) as ProductCatalogSuccess;
      expect(state.cartQuantity(tProduct.id), equals(1));
    });
  });
}
