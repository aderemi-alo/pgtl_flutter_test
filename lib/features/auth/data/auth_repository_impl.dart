import 'dart:async';
import 'package:pgtl_flutter_test/core/core.dart';
import 'package:pgtl_flutter_test/features/features.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalStorageService _localStorage;

  AuthRepositoryImpl(this._localStorage);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    // Check if account is locked out
    if (await isLockedOut()) {
      final lockoutUntil = await getLockoutUntil();
      final remainingTime = lockoutUntil?.difference(DateTime.now());

      if (remainingTime != null && remainingTime.isNegative == false) {
        final minutes = remainingTime.inMinutes;
        final seconds = remainingTime.inSeconds % 60;
        return LoginResponse(
          success: false,
          error: 'Account locked. Try again in ${minutes}m ${seconds}s',
        );
      } else {
        // Lockout period has expired, reset
        await resetFailedAttempts();
      }
    }

    // Simulate API call delay
    await Future.delayed(AppConstants.mockApiDelay);

    // Mock login validation
    if (request.email == 'test@example.com' &&
        request.password == 'Password123!') {
      // Check if account is locked
      if (await isLockedOut()) {
        final lockoutUntil = await getLockoutUntil();
        final remainingTime = lockoutUntil?.difference(DateTime.now());

        if (remainingTime != null && remainingTime.isNegative == false) {
          final minutes = remainingTime.inMinutes;
          final seconds = remainingTime.inSeconds % 60;
          return LoginResponse(
            success: false,
            error: 'Account locked. Try again in ${minutes}m ${seconds}s',
          );
        }
      }
      await resetFailedAttempts();

      // Create user and save to local storage
      final user = User(
        id: '1',
        email: request.email,
        firstName: 'Test',
        lastName: 'User',
      );

      final token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';

      // Save user and token to local storage
      await _localStorage.saveUser(user);
      await _localStorage.saveAuthToken(token);

      return LoginResponse(success: true, token: token, user: user);
    } else {
      await incrementFailedAttempts();
      return LoginResponse(success: false, error: 'Invalid email or password');
    }
  }

  @override
  Future<void> logout() async {
    // Clear stored tokens/user data using LocalStorageService
    await _localStorage.clearAuthData();
  }

  @override
  Future<bool> isLockedOut() async {
    final lockoutUntil = await getLockoutUntil();
    if (lockoutUntil == null) return false;

    return DateTime.now().isBefore(lockoutUntil);
  }

  @override
  Future<void> incrementFailedAttempts() async {
    final currentAttempts =
        _localStorage.getInt(AppConstants.failedAttemptsKey) ?? 0;
    final newAttempts = currentAttempts + 1;

    await _localStorage.saveInt(AppConstants.failedAttemptsKey, newAttempts);

    // If max attempts reached, lock the account
    if (newAttempts >= AppConstants.maxLoginAttempts) {
      final lockoutUntil = DateTime.now().add(
        Duration(minutes: AppConstants.lockoutDurationMinutes),
      );
      await setLockoutUntil(lockoutUntil);
    }
  }

  @override
  Future<void> resetFailedAttempts() async {
    await _localStorage.remove(AppConstants.failedAttemptsKey);
    await _localStorage.remove(AppConstants.lockoutKey);
  }

  @override
  Future<DateTime?> getLockoutUntil() async {
    return _localStorage.getDateTime(AppConstants.lockoutKey);
  }

  @override
  Future<void> setLockoutUntil(DateTime until) async {
    await _localStorage.saveDateTime(AppConstants.lockoutKey, until);
  }

  @override
  Future<int> getFailedAttempts() async {
    return _localStorage.getInt(AppConstants.failedAttemptsKey) ?? 0;
  }
}
