class AppConstants {
  // Security constants
  static const int maxLoginAttempts = 5;
  static const int lockoutDurationMinutes = 15;
  static const String lockoutKey = 'login_lockout_until';
  static const String failedAttemptsKey = 'failed_login_attempts';

  // API constants
  static const Duration apiTimeout = Duration(seconds: 10);
  static const Duration mockApiDelay = Duration(seconds: 2);

  // UI constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double buttonHeight = 56.0;

  // Animation constants
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shakeAnimationDuration = Duration(milliseconds: 500);

  // Error messages
  static const String networkError =
      'Network error. Please check your connection.';
  static const String unknownError = 'An unknown error occurred.';
  static const String serverError = 'Server error. Please try again later.';

  // Success messages
  static const String loginSuccess = 'Login successful!';

  // Loading messages
  static const String loggingIn = 'Logging in...';
  static const String pleaseWait = 'Please wait...';
}
