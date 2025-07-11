/// Application-wide constants for consistent values across the app
/// Centralizes common strings, dimensions, and configuration values
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // Authentication related constants
  static const String loggingIn = 'Logging in...';
  static const String loginFailed = 'Login failed';
  static const String networkError =
      'Network error. Please check your connection.';
  static const String unknownError =
      'An unknown error occurred. Please try again.';

  // UI related constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultElevation = 2.0;
  static const double buttonHeight = 56.0;

  // API related constants
  static const String baseUrl = 'https://api.example.com';
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration apiTimeout = Duration(seconds: 10);
  static const Duration mockApiDelay = Duration(seconds: 2);

  // Security related constants
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  static const int lockoutDurationMinutes = 15;
  static const String lockoutKey = 'login_lockout_until';
  static const String failedAttemptsKey = 'failed_login_attempts';

  // Storage keys for local data persistence
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';

  // Error messages
  static const String serverError = 'Server error. Please try again later.';

  // Success messages
  static const String loginSuccess = 'Login successful!';

  // Loading messages
  static const String pleaseWait = 'Please wait...';
}
