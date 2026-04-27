import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/database/sqlite_db.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/data/datasources/local_datasource.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/models/product_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late CartLocalDatasource datasource;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    GetIt.I.registerLazySingleton<SqliteDB>(() => SqliteDB());
  });

  tearDownAll(() => GetIt.I.reset());

  setUp(() {
    datasource = CartLocalDatasource();
  });

  final product = ProductModel(
    id: 1,
    title: 'Test Product',
    description: 'Desc',
    category: 'Cat',
    price: 10.0,
    raiting: 4.5,
    discountPercentage: 10.0,
    brand: 'Brand',
    images: ['img1.jpg'],
  );

  group('CartLocalDatasource - integración', () {
    test('getCart retorna lista vacía inicialmente', () async {
      final result = await datasource.getCart();
      expect(result, isEmpty);
    });

    test('addProduct agrega un producto al carrito', () async {
      await datasource.addProduct(product, 2);
      final cart = await datasource.getCart();

      expect(cart.length, equals(1));
      expect(cart.first['product_id'], equals(product.id));
      expect(cart.first['quantity'], equals(2));
    });

    test('addProduct acumula cantidad si el producto ya existe', () async {
      await datasource.addProduct(product, 3);
      final cart = await datasource.getCart();

      expect(cart.first['quantity'], equals(5)); // 2 + 3
    });

    test('removeProduct reduce la cantidad', () async {
      await datasource.removeProduct(product, 2);
      final cart = await datasource.getCart();

      expect(cart.first['quantity'], equals(3));
    });

    test('removeProduct elimina el producto si la cantidad llega a 0', () async {
      await datasource.removeProduct(product, 3);
      final cart = await datasource.getCart();

      expect(cart, isEmpty);
    });

    test('removeProduct no falla si el producto no existe', () async {
      await expectLater(
        datasource.removeProduct(product, 1),
        completes,
      );
    });
  });
}
