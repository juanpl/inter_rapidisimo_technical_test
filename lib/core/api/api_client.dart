import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';

class ApiClient extends DioForNative {
  ApiClient([super.options]) {
    options.connectTimeout ??= const Duration(seconds: 10);
    options.receiveTimeout ??= const Duration(seconds: 10);
    options.sendTimeout ??= const Duration(seconds: 10);
  }

  CustomException handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return CustomException(
          message: 'Tiempo de conexión agotado. Verifica tu conexión a internet.',
          code: 'TIMEOUT',
        );
      case DioExceptionType.connectionError:
        return CustomException(
          message: 'Sin conexión a internet.',
          code: 'NO_CONNECTION',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final serverMessage =
            error.response?.data?['message'] ?? 'Error del servidor';
        return CustomException(
          message: serverMessage,
          code: statusCode?.toString(),
        );
      default:
        return CustomException(
          message: 'Error inesperado. Intenta de nuevo.',
          code: 'UNKNOWN',
        );
    }
  }
}
