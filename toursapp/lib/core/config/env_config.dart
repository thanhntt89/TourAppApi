abstract final class EnvConfig {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://hagiang.caremycars.com/wp-json/toursapp/v1',
  );

  static const sentryDsn = String.fromEnvironment('SENTRY_DSN');

  static const isProduction = bool.fromEnvironment('dart.vm.product');
}
