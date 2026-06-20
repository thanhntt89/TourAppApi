import 'dart:developer' as dev;

import 'package:stoneecho/core/config/env_config.dart';

abstract final class AppLogger {
  static void debug(String message, {String? tag}) {
    if (!EnvConfig.isProduction) {
      dev.log(message, name: tag ?? 'StoneEcho');
    }
  }

  static void info(String message, {String? tag}) {
    dev.log('[INFO] $message', name: tag ?? 'StoneEcho');
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    dev.log(
      '[ERROR] $message',
      name: tag ?? 'StoneEcho',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
