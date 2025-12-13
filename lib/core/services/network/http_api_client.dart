import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/core/services/network/http_method.dart';
import 'package:routiner/core/services/network/http_network_service.dart';
import 'package:routiner/core/services/network/interceptors/api_log_interceptor.dart';

/// Use [HttpApiClient] where we have tokenize API calls
class HttpApiClient extends HttpNetworkService {
  HttpApiClient()
    : super(
        baseUrl: '',
        interceptors: <Interceptor>[ApiLogInterceptor()],
        header: <String, String>{'Content-Type': 'application/json'},
      );

  @override
  Future<Either<Failure, T>> request<T>({
    required final String url,
    required final HttpMethod method,
    required final T Function(Map<String, dynamic> response) responseParser,
    //ignore:avoid_annotating_with_dynamic
    final dynamic data,
    final Options? options,
  }) {
    return super.request(
      url: url,
      method: method,
      responseParser: responseParser,
      data: data,
      options: options,
    );
  }
}
