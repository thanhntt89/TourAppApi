import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/utils/device_info.dart';

class DeviceUuidInterceptor extends Interceptor {
  DeviceUuidInterceptor(this._ref);

  final Ref _ref;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final uuid = await _ref.read(deviceUuidProvider.future);
    options.headers[ApiConstants.deviceUuidHeader] = uuid;
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: Map API errors to typed exceptions
    handler.next(err);
  }
}
