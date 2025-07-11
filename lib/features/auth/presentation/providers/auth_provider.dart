import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pgtl_flutter_test/core/core.dart';
import 'package:pgtl_flutter_test/features/features.dart';

// Repository provider using dependency injection
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return locator.get<AuthRepository>();
});

// Login state provider
final loginStateProvider = StateNotifierProvider<LoginNotifier, LoginState>((
  ref,
) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginNotifier(authRepository);
});

class LoginState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final int remainingAttempts;
  final DateTime? lockoutUntil;

  const LoginState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.remainingAttempts = 5,
    this.lockoutUntil,
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
    int? remainingAttempts,
    DateTime? lockoutUntil,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      remainingAttempts: remainingAttempts ?? this.remainingAttempts,
      lockoutUntil: lockoutUntil ?? this.lockoutUntil,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;

  LoginNotifier(this._authRepository) : super(const LoginState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      // Check if account is locked
      final isLocked = await _authRepository.isLockedOut();
      if (isLocked) {
        final lockoutUntil = await _authRepository.getLockoutUntil();
        state = state.copyWith(
          isLoading: false,
          error: 'Account is temporarily locked. Please try again later.',
          lockoutUntil: lockoutUntil,
        );
        return;
      }

      final request = LoginRequest(email: email, password: password);
      final response = await _authRepository.login(request);

      if (response.success) {
        state = state.copyWith(isLoading: false, isSuccess: true, error: null);
      } else {
        // Get remaining attempts
        final failedAttempts = await _authRepository.getFailedAttempts();
        final remainingAttempts = 5 - failedAttempts;

        state = state.copyWith(
          isLoading: false,
          error: response.error,
          remainingAttempts: remainingAttempts,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred. Please try again.',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void resetState() {
    state = const LoginState();
  }
}
