import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:routiner/core/constants/string_constants.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/core/services/network/http_method.dart';

class HttpNetworkService {
  HttpNetworkService({
    this.baseUrl,
    this.header,
    this.interceptors = const <Interceptor>[],
  }) {
    dio.options.baseUrl = baseUrl ?? '';
    dio.options.headers = header;
    initInterceptors();
  }

  final Dio dio = Dio(
    BaseOptions(
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30),
    ),
  );
  final List<CancelToken> cancelTokens = <CancelToken>[];
  Map<String, dynamic>? header;
  final String? baseUrl;
  final List<Interceptor> interceptors;

  void initInterceptors() {
    dio.interceptors.addAll(interceptors);
  }

  Future<Either<Failure, T>> request<T>({
    required final String url,
    required final HttpMethod method,
    required final T Function(Map<String, dynamic> response) responseParser,
    final dynamic data,
    final Options? options,
  }) async {
    Response<dynamic> response;

    try {
      final CancelToken cancelToken = CancelToken();
      cancelTokens.add(cancelToken);
      switch (method) {
        case HttpMethod.post:
          response = await dio.post(
            url,
            data: data,
            options: options,
            cancelToken: cancelToken,
          );
        case HttpMethod.delete:
          response = await dio.delete(
            url,
            data: data,
            options: options,
            cancelToken: cancelToken,
          );
        case HttpMethod.patch:
          response = await dio.patch(
            url,
            data: data,
            options: options,
            cancelToken: cancelToken,
          );
        case HttpMethod.get:
          response = await dio.get(
            url,
            queryParameters: data is Map<String, dynamic> ? data : null,
            options: options,
            cancelToken: cancelToken,
          );
        case HttpMethod.put:
          response = await dio.put(
            url,
            data: data,
            options: options,
            cancelToken: cancelToken,
          );
      }

      return parseResponse<T>(
        response: response,
        responseParser: responseParser,
      );
    } on FormatException catch (e) {
      log(e.message);
      return Left<Failure, T>(const FormattingFailure());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left<Failure, T>(const TimeoutFailure());
      }

      if (<int>[403, 412].contains(e.response?.statusCode)) {
        return getUnauthorizedFailure(e);
      }

      if (e.response?.statusCode == 404) {
        return Left<Failure, T>(
          BadRequestFailure(
            statusCode: '404',
            message: extractErrorMessage(e.response),
          ),
        );
      }
      if (e.response?.statusCode == 400) {
        return Left<Failure, T>(
          BadRequestFailure(
            statusCode: '400',
            message: extractErrorMessage(e.response),
            data: e.response?.data,
          ),
        );
      }
      if (e.response?.statusCode == 502) {
        return Left<Failure, T>(
          const ServerFailure(
            statusCode: '502',
            message:
                'The server is temporarily unavailable. Please try again later.',
          ),
        );
      }
      if ((e.response?.statusCode ?? 0) >= 500 &&
          (e.response?.statusCode ?? 0) <= 599) {
        return Left<Failure, T>(
          ServerFailure(
            statusCode:
                e.response?.statusCode.toString() ??
                StringConstants.emptyString,
            message: extractErrorMessage(e.response),
          ),
        );
      }

      return Left<Failure, T>(
        UnknownFailure(
          statusCode: e.response?.statusCode.toString() ?? 'Unknown',
          message: extractErrorMessage(e.response),
        ),
      );
    }
  }

  String extractErrorMessage(final Response<dynamic>? response) {
    if (response == null) {
      return 'Oops! Something went wrong.';
    }

    final dynamic body = response.data;

    if (body is String) {
      return body;
    }

    if (body is Map<String, dynamic>) {
      if (body['message'] is String) {
        return body['message'] as String;
      }

      if (body['errors'] is List && body['errors'].isNotEmpty) {
        final dynamic firstError = body['errors'].first;
        if (firstError is Map<String, dynamic>) {
          return (firstError['errorMessage'] as String?) ??
              'Oops! Something went wrong.';
        }
      }

      return 'Oops! Something went wrong.';
    }

    return body?.toString() ?? 'Oops! Something went wrong.';
  }

  Either<Failure, T> parseResponse<T>({
    required final Response<dynamic> response,
    required final T Function(Map<String, dynamic> response) responseParser,
  }) {
    try {
      if (response.statusCode == 204) {
        return Right<Failure, T>(responseParser(<String, dynamic>{}));
      }
      if (response.data is List<dynamic>) {
        return Right<Failure, T>(
          responseParser(<String, dynamic>{'data': response.data}),
        );
      }
      return Right<Failure, T>(
        responseParser(response.data as Map<String, dynamic>),
      );
    } catch (e) {
      return Left<Failure, T>(const FormattingFailure());
    }
  }

  Future<Either<Failure, T>> getUnauthorizedFailure<T>(
    final DioException e,
  ) async {
    if (e.requestOptions.headers['Authorization'] == null &&
        e.response?.statusCode == 401) {
      return Left<Failure, T>(
        AuthenticationFailure(
          statusCode: e.response?.statusCode.toString() ?? 'Forbidden',
          message: extractErrorMessage(e.response),
        ),
      );
    } else {
      cancelTokens
        ..remove(e.requestOptions.cancelToken)
        ..forEach((final CancelToken token) {
          token.cancel();
        });
      return Left<Failure, T>(
        AuthenticationFailure(
          statusCode: e.response?.statusCode.toString() ?? 'Unauthorized',
          message: extractErrorMessage(e.response),
        ),
      );
    }
  }
}
