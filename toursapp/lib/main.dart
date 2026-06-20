import 'package:flutter/material.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stoneecho/app.dart';
import 'package:stoneecho/core/config/env_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FMTCObjectBoxBackend().initialise();
  await FMTCStore('toursapp_tiles').manage.create();

  await SentryFlutter.init(
    (options) {
      options
        ..dsn = EnvConfig.sentryDsn
        ..tracesSampleRate = 0.3;
    },
    appRunner: () => runApp(
      const ProviderScope(child: StoneEchoApp()),
    ),
  );
}
