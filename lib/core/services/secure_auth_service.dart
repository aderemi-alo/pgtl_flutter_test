import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:pgtl_flutter_test/core/core.dart';
import 'package:pgtl_flutter_test/features/features.dart';

/// Secure authentication service that handles login operations
/// with proper security measures, error handling, and separation of concerns
class SecureAuthService {
  final AuthRepository _authRepository;
  final LocalStorageService _localStorage;

  SecureAuthService({
    required AuthRepository authRepository,
    required LocalStorageService localStorage,
  }) : _authRepository = authRepository,
       _localStorage = localStorage;

  /// Secure login method with proper error handling and validation
  ///
  /// [email] - User's email address
  /// [password] - User's password
  ///
  /// Returns [AuthResult] with success status and appropriate messages
  Future<AuthResult> secureLogin({
    required String email,
    required String password,
  }) async {
    try {
      // Input validation
      final validationResult = _validateInput(email, password);
      if (!validationResult.isValid) {
        return AuthResult.failure(
          validationResult.errorMessage ?? 'Validation failed',
        );
      }

      // Create secure login request
      final loginRequest = LoginRequest(
        email: email.trim().toLowerCase(),
        password: password,
      );

      // Attempt login with repository
      final loginResponse = await _authRepository.login(loginRequest);

      if (loginResponse.success) {
        // Log successful login attempt
        _logSecurityEvent('Login successful', email);

        return AuthResult.success(
          user: loginResponse.user,
          token: loginResponse.token,
        );
      } else {
        // Log failed login attempt
        _logSecurityEvent('Login failed', email);

        return AuthResult.failure(loginResponse.error ?? 'Login failed');
      }
    } on SocketException {
      _logSecurityEvent('Network error during login', email);
      return AuthResult.failure(AppConstants.networkError);
    } on TimeoutException {
      _logSecurityEvent('Timeout during login', email);
      return AuthResult.failure('Request timed out. Please try again.');
    } on FormatException {
      _logSecurityEvent('Data format error during login', email);
      return AuthResult.failure('Invalid response format from server.');
    } catch (error) {
      _logSecurityEvent('Unexpected error during login: $error', email);
      return AuthResult.failure(AppConstants.unknownError);
    }
  }

  /// Validates input parameters for security and data integrity
  InputValidationResult _validateInput(String email, String password) {
    // Email validation
    if (email.isEmpty) {
      return InputValidationResult.invalid('Email is required');
    }

    if (!_isValidEmail(email)) {
      return InputValidationResult.invalid(
        'Please enter a valid email address',
      );
    }

    // Password validation
    if (password.isEmpty) {
      return InputValidationResult.invalid('Password is required');
    }

    if (password.length < 8) {
      return InputValidationResult.invalid(
        'Password must be at least 8 characters',
      );
    }

    // Check for common weak passwords
    if (_isWeakPassword(password)) {
      return InputValidationResult.invalid(
        'Password is too weak. Please choose a stronger password',
      );
    }

    return InputValidationResult.valid();
  }

  /// Validates email format using regex
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(email);
  }

  /// Checks if password meets security requirements
  bool _isWeakPassword(String password) {
    // Check for common weak patterns
    final weakPatterns = ['password', '123456', 'qwerty', 'admin', 'user'];

    final lowerPassword = password.toLowerCase();
    return weakPatterns.any((pattern) => lowerPassword.contains(pattern));
  }

  /// Logs security events for monitoring and auditing
  void _logSecurityEvent(String event, String email) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = {
      'timestamp': timestamp,
      'event': event,
      'email': _hashEmail(email), // Hash email for privacy
      'ip': 'client_ip', // In real app, get from request
    };

    // In production, send to secure logging service
    log('SECURITY_LOG: ${jsonEncode(logEntry)}');
  }

  /// Hashes email for privacy in logs
  String _hashEmail(String email) {
    final bytes = utf8.encode(email);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16); // Truncate for readability
  }

  /// Secure logout method
  Future<void> secureLogout() async {
    try {
      await _authRepository.logout();
      _logSecurityEvent('Logout successful', 'unknown');
    } catch (e) {
      _logSecurityEvent('Error during logout: ${e.toString()}', 'unknown');
      // Still clear local data even if server logout fails
      await _localStorage.clearAuthData();
    }
  }

  /// Checks if user is currently authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = await _localStorage.getAuthToken();
      final user = _localStorage.getUser();
      return token != null && user != null;
    } catch (e) {
      return false;
    }
  }
}

/// Result class for authentication operations
class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final User? user;
  final String? token;

  const AuthResult._({
    required this.isSuccess,
    this.errorMessage,
    this.user,
    this.token,
  });

  factory AuthResult.success({User? user, String? token}) {
    return AuthResult._(isSuccess: true, user: user, token: token);
  }

  factory AuthResult.failure(String errorMessage) {
    return AuthResult._(isSuccess: false, errorMessage: errorMessage);
  }
}

/// Input validation result
class InputValidationResult {
  final bool isValid;
  final String? errorMessage;

  const InputValidationResult._({required this.isValid, this.errorMessage});

  factory InputValidationResult.valid() {
    return const InputValidationResult._(isValid: true);
  }

  factory InputValidationResult.invalid(String errorMessage) {
    return InputValidationResult._(isValid: false, errorMessage: errorMessage);
  }
}
