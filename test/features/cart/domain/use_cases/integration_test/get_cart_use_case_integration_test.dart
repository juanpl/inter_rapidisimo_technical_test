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
  late GetCartUseCase useCase;

  final tProduct = ProductEntity(
    id: 10,
    title: 'Test Product',
    description: 'Desc',
    category: 'electronics',
    price: 200.0,
    rating: 4.0,
    discountPercentage: 20.0,
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
    useCase = GetIt.I<GetCartUseCase>();
  });

  setUp(() async {
    final database = await db.database;
    await database.delete('cart');
  });

  tearDownAll(() => GetIt.I.reset());

  group('GetCartUseCase - integración', () {
    test('retorna lista vacía cuando el carrito está vacío', () async {
      final result = await useCase();

      expect(result, isEmpty);
    });

    test('retorna items con discountedPrice calculado', () async {
      final addUseCase = GetIt.I<AddProductToCartUseCase>();
      await addUseCase(tProduct, 1);

      final result = await useCase();

      expect(result.length, equals(1));
      expect(result.first.product.discountedPrice, equals(160.0));
    });

    test('preserva la cantidad de cada item', () async {
      final addUseCase = GetIt.I<AddProductToCartUseCase>();
      await addUseCase(tProduct, 1);
      await addUseCase(tProduct, 1);

      final result = await useCase();

      expect(result.first.quantity, equals(2));
    });
  });
}
