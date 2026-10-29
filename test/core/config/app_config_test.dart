import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/core/config/app_config.dart';

void main() {
  group('AppConfig Environment Tests', () {
    test('default instance is prod when not explicitly set', () {
      expect(AppConfig.prod.isProd, isTrue);
      expect(AppConfig.prod.isDev, isFalse);
      expect(AppConfig.prod.appTitle, equals('OutSplitIn'));
      expect(AppConfig.prod.showDebugBanner, isFalse);
      expect(AppConfig.prod.enableLogging, isFalse);
    });

    test('dev profile has correct properties', () {
      expect(AppConfig.dev.isDev, isTrue);
      expect(AppConfig.dev.isProd, isFalse);
      expect(AppConfig.dev.appTitle, equals('OutSplitIn (Dev)'));
      expect(AppConfig.dev.showDebugBanner, isTrue);
      expect(AppConfig.dev.enableLogging, isTrue);
    });

    test('setting AppConfig.instance switches global active config', () {
      AppConfig.instance = AppConfig.dev;
      expect(AppConfig.instance.environment, equals(Environment.dev));
      expect(AppConfig.instance.isDev, isTrue);

      AppConfig.instance = AppConfig.prod;
      expect(AppConfig.instance.environment, equals(Environment.prod));
      expect(AppConfig.instance.isProd, isTrue);
    });
  });
}
