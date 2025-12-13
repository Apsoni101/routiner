import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiLogInterceptor extends Interceptor {
  @override
  void onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      log('📤 REQUEST: ${options.method} ${options.uri}');
      if (options.headers.isNotEmpty) {
        log('📤 Headers: ${_formatJson(options.headers)}');
      }
      if (options.data != null) {
        log('📤 Body: ${_formatData(options.data)}');
      }
      log(
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    final Response<dynamic> response,
    final ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      log(
        '📥 RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
      );
      // if (response.headers.map.isNotEmpty) {
      //   log('📥 Headers: ${_formatJson(response.headers.map)}');
      // }
      if (response.data != null) {
        log('📥 Body: ${_formatData(response.data)}');
      }
      log(
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
      );
    }
    handler.next(response);
  }

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log('❌ ERROR: ${err.requestOptions.method} ${err.requestOptions.uri}');
      log('❌ Status: ${err.response?.statusCode}');
      log('❌ Message: ${err.message}');
      if (err.response?.data != null) {
        log('❌ Error Body: ${_formatData(err.response!.data)}');
      }
      log(
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
      );
    }
    handler.next(err);
  }

  String _formatData(final Object? data) {
    try {
      if (data is String) {
        return data;
      } else if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      } else {
        return data.toString();
      }
    } catch (e) {
      return data.toString();
    }
  }

  String _formatJson(final Map<String, Object?> json) {
    try {
      return const JsonEncoder.withIndent('  ').convert(json);
    } catch (e) {
      return json.toString();
    }
  }
}
