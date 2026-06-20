import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/l10n/generated/app_localizations.dart';
import 'package:stoneecho/core/router/app_router.dart';
import 'package:stoneecho/core/theme/app_theme.dart';
import 'package:stoneecho/providers/locale_providers.dart';
import 'package:stoneecho/providers/theme_providers.dart';

class StoneEchoApp extends ConsumerWidget {
  const StoneEchoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(uiLocaleProvider);

    return MaterialApp.router(
      title: 'StoneEcho',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
