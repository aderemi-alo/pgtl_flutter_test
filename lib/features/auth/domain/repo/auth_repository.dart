import '../models/auth_models.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<void> logout();
  Future<bool> isLockedOut();
  Future<void> incrementFailedAttempts();
  Future<void> resetFailedAttempts();
  Future<DateTime?> getLockoutUntil();
  Future<void> setLockoutUntil(DateTime until);
  Future<int> getFailedAttempts();
}
