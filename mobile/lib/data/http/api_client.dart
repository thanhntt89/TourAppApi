// lib/data/http/api_client.dart
//
// Dio HTTP client — single instance, pre-configured for the ToursApp API.
// Features:
//  - Base URL from Env
//  - Timeout configuration
//  - Device UUID injection (DeviceAuthInterceptor)
//  - Response envelope unwrapping (ApiResponseInterceptor)
//  - Typed error conversion (ApiErrorInterceptor)

import 'package:dio/dio.dart';
import '../../core/config/app_config.dart';
import '../../core/config/env.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/utils/device_id.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient._() : _dio = _buildDio();

  static final ApiClient instance = ApiClient._();

  final Dio _dio;

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: '${Env.apiBaseUrl}${ApiEndpoints.namespace}',
        connectTimeout: kApiTimeout,
        receiveTimeout: kApiTimeout,
        sendTimeout: kApiTimeout,
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      DeviceAuthInterceptor(),
      ApiResponseInterceptor(),
      ApiErrorInterceptor(),
      // In debug: log requests
      // LogInterceptor(requestBody: true, responseBody: true),
    ]);

    return dio;
  }

  Dio get dio => _dio;
}

// ── Interceptors ───────────────────────────────────────────────────────────

/// Injects X-Device-UUID header on every request (required for device-auth endpoints).
/// Safe to inject on public endpoints — server simply ignores it.
class DeviceAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final uuid = DeviceIdService.current;
    if (uuid.isNotEmpty) {
      options.headers['X-Device-UUID'] = uuid;
    }
    handler.next(options);
  }
}

/// Unwraps the standard API response envelope:
///   { "success": true, "data": {...}, "meta": {...} }
/// Replaces the response data with just the `data` field.
class ApiResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final body = response.data;
    if (body is Map<String, dynamic>) {
      final success = body['success'] as bool? ?? false;
      if (success) {
        // Replace response data with the unwrapped `data` field
        response.data = body['data'];
        // Attach meta to the response's extra map for pagination
        if (body.containsKey('meta')) {
          response.extra['meta'] = body['meta'];
        }
        handler.next(response);
        return;
      }
      // API returned { success: false, error: {...} }
      final error = body['error'] as Map<String, dynamic>? ?? {};
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: ApiException.fromApiError(error),
        ),
        true,
      );
    } else {
      handler.next(response);
    }
  }
}

/// Converts DioException into typed [ApiException].
class ApiErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.error is ApiException) {
      handler.next(err);
      return;
    }

    final ApiException apiEx;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        apiEx = const ApiException.timeout();
        break;
      case DioExceptionType.connectionError:
        apiEx = const ApiException.network();
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        final body = err.response?.data;
        if (body is Map<String, dynamic> && body.containsKey('error')) {
          apiEx = ApiException.fromApiError(body['error'] as Map<String, dynamic>);
        } else {
          apiEx = ApiException.httpError(statusCode);
        }
        break;
      default:
        apiEx = const ApiException.unknown();
    }

    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: apiEx,
      ),
    );
  }
}
