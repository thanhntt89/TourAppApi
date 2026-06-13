// lib/data/http/api_exception.dart
//
// Typed exceptions for ToursApp API errors.
// Maps HTTP status codes and API error codes to structured exceptions.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exception.freezed.dart';

@freezed
class ApiException with _$ApiException implements Exception {
  /// Network unreachable (no internet connection).
  const factory ApiException.network() = _NetworkException;

  /// Request timed out.
  const factory ApiException.timeout() = _TimeoutException;

  /// Device UUID not registered (HTTP 401, code: DEVICE_NOT_REGISTERED).
  const factory ApiException.deviceNotRegistered() =
      _DeviceNotRegisteredException;

  /// Content not found (HTTP 404).
  const factory ApiException.notFound() = _NotFoundException;

  /// Rate limit exceeded (HTTP 429).
  const factory ApiException.rateLimited() = _RateLimitException;

  /// Endpoint disabled via admin (HTTP 503).
  const factory ApiException.endpointDisabled() = _EndpointDisabledException;

  /// Insufficient flowers for unlock (HTTP 400, code: INSUFFICIENT_BALANCE).
  const factory ApiException.insufficientFlowers({
    required int required_,
    required int current,
  }) = _InsufficientFlowersException;

  /// User journey limit reached (HTTP 403, code: JOURNEY_LIMIT_REACHED).
  const factory ApiException.journeyLimitReached({
    required int limit,
    required int current,
  }) = _JourneyLimitReachedException;

  /// Check-in: device too far from place (HTTP 400, code: CHECKIN_TOO_FAR).
  const factory ApiException.checkinTooFar({
    required int distanceMeters,
    required int radiusMeters,
  }) = _CheckinTooFarException;

  /// Already checked in at this place (HTTP 409, code: ALREADY_CHECKED_IN).
  const factory ApiException.alreadyCheckedIn() = _AlreadyCheckedInException;

  /// Generic HTTP error.
  const factory ApiException.httpError(int statusCode) = _HttpErrorException;

  /// Unknown / unexpected error.
  const factory ApiException.unknown([String? message]) = _UnknownException;

  /// Factory: parse from API error object `{ "code": "...", "message": "...", "details": {...} }`.
  static ApiException fromApiError(Map<String, dynamic> error) {
    final code = error['code'] as String? ?? '';
    final details = error['details'] as Map<String, dynamic>? ?? {};

    switch (code) {
      case 'DEVICE_NOT_REGISTERED':
        return const ApiException.deviceNotRegistered();
      case 'INSUFFICIENT_BALANCE':
        return ApiException.insufficientFlowers(
          required_: (details['required'] as num?)?.toInt() ?? 0,
          current: (details['current'] as num?)?.toInt() ?? 0,
        );
      case 'JOURNEY_LIMIT_REACHED':
        return ApiException.journeyLimitReached(
          limit: (details['limit'] as num?)?.toInt() ?? 5,
          current: (details['current'] as num?)?.toInt() ?? 0,
        );
      case 'CHECKIN_TOO_FAR':
        return ApiException.checkinTooFar(
          distanceMeters: (details['distance_meters'] as num?)?.toInt() ?? 0,
          radiusMeters: (details['radius_meters'] as num?)?.toInt() ?? 300,
        );
      case 'ALREADY_CHECKED_IN':
        return const ApiException.alreadyCheckedIn();
      default:
        return ApiException.unknown(error['message'] as String?);
    }
  }
}
