import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/config/configuration.dart';
import 'package:inter_rapidisimo_technical_test/core/api/api_client.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';

class ProductCatalogDatasource {
  late final ApiClient _apiClient;

  ProductCatalogDatasource() {
    _apiClient = GetIt.I<ApiClient>();
  }

  Future<Map<String, dynamic>> getProductCatalog({
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await _apiClient.get(
        '${Configuration.config.endpoints.productEndPoint}?limit=$limit&skip=$offset',
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _apiClient.handleError(e);
    } catch (_) {
      throw CustomException(message: 'Error inesperado', code: 'UNKNOWN');
    }
  }
}
