import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/database/sqlite_db.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/data/datasources/local_datasource.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/data/repository_impl/cart_repository_impl.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/repositories/cart_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/add_product_to_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late SqliteDB db;
  late AddProductToCartUseCase useCase;
  late GetCartUseCase getCartUseCase;

  final tProduct = ProductEntity(
    id: 20,
    title: 'Test Product',
    description: 'Desc',
    category: 'electronics',
    price: 100.0,
    rating: 4.5,
    discountPercentage: 10.0,
    brand: 'Brand',
    images: ['https://example.com/img.jpg'],
  );

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    db = SqliteDB();
    await db.database;
    GetIt.I.registerSingleton<SqliteDB>(db);
    GetIt.I.registerSingleton<LocalDatasource>(LocalDatasource());
    GetIt.I.registerSingleton<CartRepository>(CartRepositoryImpl());
    GetIt.I.registerSingleton<AddProductToCartUseCase>(AddProductToCartUseCase());
    GetIt.I.registerSingleton<GetCartUseCase>(GetCartUseCase());
    useCase = GetIt.I<AddProductToCartUseCase>();
    getCartUseCase = GetIt.I<GetCartUseCase>();
  });

  setUp(() async {
    final database = await db.database;
    await database.delete('cart');
  });

  tearDownAll(() => GetIt.I.reset());

  group('AddProductToCartUseCase - integración', () {
    test('agrega un producto y puede recuperarse con GetCartUseCase', () async {
      await useCase(tProduct, 1);

      final cart = await getCartUseCase();

      expect(cart.length, equals(1));
      expect(cart.first.product.id, equals(tProduct.id));
      expect(cart.first.quantity, equals(1));
    });

    test('acumula cantidad al agregar el mismo producto dos veces', () async {
      await useCase(tProduct, 1);
      await useCase(tProduct, 1);

      final cart = await getCartUseCase();

      expect(cart.first.quantity, equals(2));
    });

    test('agrega múltiples productos distintos', () async {
      final secondProduct = tProduct.copyWith(id: 21, title: 'Second Product');
      await useCase(tProduct, 1);
      await useCase(secondProduct, 1);

      final cart = await getCartUseCase();

      expect(cart.length, equals(2));
    });
  });
}
