import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/database/sqlite_db.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/data/datasources/local_datasource.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/data/repository_impl/cart_repository_impl.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late CartRepositoryImpl repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    GetIt.I.registerLazySingleton<SqliteDB>(() => SqliteDB());
    GetIt.I.registerLazySingleton<LocalDatasource>(() => LocalDatasource());
  });

  tearDownAll(() => GetIt.I.reset());

  setUp(() async {
    repository = CartRepositoryImpl();
    final db = await GetIt.I<SqliteDB>().database;
    await db.delete('cart');
  });

  final product = ProductEntity(
    id: 1,
    title: 'Test Product',
    description: 'Desc',
    category: 'Cat',
    price: 10.0,
    rating: 4.5,
    discountPercentage: 10.0,
    brand: 'Brand',
    images: ['img1.jpg'],
  );

  group('CartRepositoryImpl - integración', () {
    test('getCart retorna lista vacía inicialmente', () async {
      final result = await repository.getCart();
      expect(result, isEmpty);
    });

    test('addProduct agrega un producto y getCart lo retorna', () async {
      await repository.addProduct(product, 2);
      final cart = await repository.getCart();

      expect(cart.length, equals(1));
      expect(cart.first.product.id, equals(product.id));
      expect(cart.first.quantity, equals(2));
    });

    test('addProduct acumula cantidad si el producto ya existe', () async {
      await repository.addProduct(product, 2);
      await repository.addProduct(product, 3);
      final cart = await repository.getCart();

      expect(cart.first.quantity, equals(5));
    });

    test('removeProduct reduce la cantidad', () async {
      await repository.addProduct(product, 5);
      await repository.removeProduct(product, 2);
      final cart = await repository.getCart();

      expect(cart.first.quantity, equals(3));
    });

    test(
      'removeProduct elimina el producto si la cantidad llega a 0',
      () async {
        await repository.addProduct(product, 3);
        await repository.removeProduct(product, 3);
        final cart = await repository.getCart();

        expect(cart, isEmpty);
      },
    );

    test('removeProduct no falla si el producto no existe', () async {
      await expectLater(repository.removeProduct(product, 1), completes);
    });

    test('getCart retorna CartProductEntity con los datos correctos', () async {
      await repository.addProduct(product, 2);
      final cart = await repository.getCart();
      final item = cart.first;

      expect(item.product.title, equals(product.title));
      expect(item.product.price, equals(product.price));
      expect(item.product.brand, equals(product.brand));
      expect(item.quantity, equals(2));
    });
  });
}
