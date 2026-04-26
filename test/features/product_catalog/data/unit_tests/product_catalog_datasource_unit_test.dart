import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/config/configuration.dart';
import 'package:inter_rapidisimo_technical_test/config/schema_configuration.dart';
import 'package:inter_rapidisimo_technical_test/core/api/api_client.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/datasources/product_catalog_datasource.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late ProductCatalogDatasource datasource;

  setUpAll(() {
    Configuration.config = SchemaConfiguration(
      appName: 'Test',
      companyName: 'Test',
      endpoints: ConfigurationEndpoints(
        productEndPoint: 'https://test.com/products',
      ),
    );
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(DioException(requestOptions: RequestOptions(path: '')));
  });

  setUp(() {
    mockApiClient = MockApiClient();
    if (GetIt.I.isRegistered<ApiClient>()) GetIt.I.unregister<ApiClient>();
    GetIt.I.registerSingleton<ApiClient>(mockApiClient);
    datasource = ProductCatalogDatasource();
  });

  tearDown(() => GetIt.I.reset());

  group('getProductCatalog', () {
    test('retorna data cuando la petición es exitosa', () async {
      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => Response<dynamic>(
          data: {'products': [], 'total': 0},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await datasource.getProductCatalog(limit: 10, offset: 0);

      expect(result, equals({'products': [], 'total': 0}));
    });

    test('lanza CustomException con code TIMEOUT cuando hay timeout', () {
      final dioException = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: ''),
      );
      when(() => mockApiClient.get(any())).thenThrow(dioException);
      when(() => mockApiClient.handleError(any())).thenReturn(
        const CustomException(message: 'Tiempo agotado', code: 'TIMEOUT'),
      );

      expect(
        () => datasource.getProductCatalog(limit: 10, offset: 0),
        throwsA(isA<CustomException>().having((e) => e.code, 'code', 'TIMEOUT')),
      );
    });

    test('lanza CustomException con code NO_CONNECTION cuando no hay conexión', () {
      final dioException = DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: ''),
      );
      when(() => mockApiClient.get(any())).thenThrow(dioException);
      when(() => mockApiClient.handleError(any())).thenReturn(
        const CustomException(message: 'Sin conexión', code: 'NO_CONNECTION'),
      );

      expect(
        () => datasource.getProductCatalog(limit: 10, offset: 0),
        throwsA(isA<CustomException>().having((e) => e.code, 'code', 'NO_CONNECTION')),
      );
    });

    test('lanza CustomException con code UNKNOWN cuando hay un error inesperado', () {
      when(() => mockApiClient.get(any())).thenThrow(Exception('Error inesperado'));

      expect(
        () => datasource.getProductCatalog(limit: 10, offset: 0),
        throwsA(isA<CustomException>().having((e) => e.code, 'code', 'UNKNOWN')),
      );
    });
  });
}
