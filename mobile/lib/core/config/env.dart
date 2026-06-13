// lib/core/config/env.dart
//
// Environment variables loaded at compile-time via `envied`.
// Copy `.env.example` → `.env` and fill in values before building.
//
// NEVER commit `.env` to source control.
//
// Usage:
//   final baseUrl = Env.apiBaseUrl;

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  /// Base URL of the WordPress REST API, e.g. https://your-wp-site.com/wp-json
  @EnviedField(varName: 'API_BASE_URL', defaultValue: 'https://demo.toursapp.vn/wp-json')
  static final String apiBaseUrl = _Env.apiBaseUrl;

  /// Sentry DSN for error tracking (optional, can be empty in dev).
  @EnviedField(varName: 'SENTRY_DSN', defaultValue: '')
  static final String sentryDsn = _Env.sentryDsn;
}
