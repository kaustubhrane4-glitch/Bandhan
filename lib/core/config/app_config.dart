import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { dev, staging, prod }

class AppConfig {
  static late Environment _environment;

  static void init(Environment env) {
    _environment = env;
  }

  static String get envName => _environment.name;

  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get razorpayKey => dotenv.env['RAZORPAY_KEY_ID'] ?? '';
  static String get posthogApiKey => dotenv.env['POSTHOG_API_KEY'] ?? '';
  static String get sentryDsn => dotenv.env['SENTRY_DSN'] ?? '';

  static bool get isDev => _environment == Environment.dev;
  static bool get isProd => _environment == Environment.prod;
}
