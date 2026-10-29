enum Environment { dev, prod }

class AppConfig {
  final Environment environment;
  final String appTitle;
  final bool showDebugBanner;
  final bool enableLogging;

  static AppConfig? _instance;
  static AppConfig get instance => _instance ?? prod;
  static set instance(AppConfig config) => _instance = config;

  const AppConfig({
    required this.environment,
    required this.appTitle,
    required this.showDebugBanner,
    required this.enableLogging,
  });

  bool get isDev => environment == Environment.dev;
  bool get isProd => environment == Environment.prod;

  static const AppConfig dev = AppConfig(
    environment: Environment.dev,
    appTitle: 'OutSplitIn (Dev)',
    showDebugBanner: true,
    enableLogging: true,
  );

  static const AppConfig prod = AppConfig(
    environment: Environment.prod,
    appTitle: 'OutSplitIn',
    showDebugBanner: false,
    enableLogging: false,
  );
}
