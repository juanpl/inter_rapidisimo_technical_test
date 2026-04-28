import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/config/configuration.dart';
import 'package:inter_rapidisimo_technical_test/config/configuration_prod/configuration_prod.dart';
import 'package:inter_rapidisimo_technical_test/core/api/api_client.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/data/datasources/product_detail_datasource.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/data/repository_impl/product_detail_repository_impl.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/domain/repository/product_detail_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/domain/use_cases/get_product_by_id_use_case.dart';

void main() {
  late GetProductByIdUseCase useCase;

  setUpAll(() {
    Configuration.config = ConfigurationProd().config;
    GetIt.I.registerSingleton<ApiClient>(ApiClient());
    GetIt.I.registerSingleton<ProductDetailDatasource>(ProductDetailDatasource());
    GetIt.I.registerSingleton<ProductDetailRepository>(ProductDetailRepositoryImpl());
    GetIt.I.registerSingleton<GetProductByIdUseCase>(GetProductByIdUseCase());
    useCase = GetIt.I<GetProductByIdUseCase>();
  });

  tearDownAll(() => GetIt.I.reset());

  group('GetProductByIdUseCase - integración', () {
    test('retorna el producto con el id correcto', () async {
      final result = await useCase(1);

      expect(result.id, equals(1));
    });

    test('calcula discountedPrice correctamente', () async {
      final result = await useCase(1);

      expect(result.discountedPrice, greaterThan(0));
      expect(result.discountedPrice, lessThanOrEqualTo(result.price));
    });

    test('retorna producto con todos los campos requeridos', () async {
      final result = await useCase(1);

      expect(result.title, isNotEmpty);
      expect(result.description, isNotEmpty);
      expect(result.images, isNotEmpty);
      expect(result.price, greaterThan(0));
    });

    test('discountedPrice está redondeado a 2 decimales', () async {
      final result = await useCase(1);

      final asString = result.discountedPrice.toStringAsFixed(2);
      expect(result.discountedPrice, equals(double.parse(asString)));
    });
  });
}
