import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/config/configuration.dart';
import 'package:inter_rapidisimo_technical_test/core/api/api_client.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';

class ProductDetailDatasource {
  late final ApiClient _apiClient;

  ProductDetailDatasource() {
    _apiClient = GetIt.I<ApiClient>();
  }

  Future<Map<String, dynamic>> getProductById(int id) async {
    try {
      final response = await _apiClient.get(
        '${Configuration.config.endpoints.productEndPoint}/$id',
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _apiClient.handleError(e);
    } catch (_) {
      throw CustomException(
        message: 'ProductDetailDatasource_getProductById_error',
        code: 'UNKNOWN',
      );
    }
  }
}
