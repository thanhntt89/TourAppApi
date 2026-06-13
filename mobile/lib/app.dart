// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
// TODO: Generate and import AppLocalizations from flutter_gen
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ToursApp extends StatelessWidget {
  const ToursApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ToursApp - Tour Guide Trong Túi',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      
      // i18n
      localizationsDelegates: const [
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
        Locale('ko'),
        Locale('zh'),
        Locale('fr'),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
