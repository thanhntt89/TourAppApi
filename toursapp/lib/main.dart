import 'package:flutter/material.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stoneecho/app.dart';
import 'package:stoneecho/core/config/env_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await FMTCObjectBoxBackend().initialise();
    await FMTCStore('toursapp_tiles').manage.create();
  } catch (e) {
    debugPrint('FMTC init error: $e');
  }

  final dsn = EnvConfig.sentryDsn;
  if (dsn.isNotEmpty) {
    await SentryFlutter.init(
      (options) {
        options
          ..dsn = dsn
          ..tracesSampleRate = 0.3;
      },
      appRunner: () => runApp(
        const ProviderScope(child: StoneEchoApp()),
      ),
    );
  } else {
    runApp(const ProviderScope(child: StoneEchoApp()));
  }
}
