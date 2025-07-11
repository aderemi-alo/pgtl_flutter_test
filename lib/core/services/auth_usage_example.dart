import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pgtl_flutter_test/core/core.dart';
import 'package:pgtl_flutter_test/features/features.dart';
import 'secure_auth_service.dart';

/// Example of how to properly use the SecureAuthService in a UI component
/// This demonstrates separation of concerns, proper error handling, and security best practices
class SecureLoginExample extends ConsumerStatefulWidget {
  const SecureLoginExample({super.key});

  @override
  ConsumerState<SecureLoginExample> createState() => _SecureLoginExampleState();
}

class _SecureLoginExampleState extends ConsumerState<SecureLoginExample> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Secure login method that properly handles async operations and context
  Future<void> _performSecureLogin() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get the secure auth service from dependency injection
      final authService = ref.read(secureAuthServiceProvider);

      // Perform secure login
      final result = await authService.secureLogin(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (result.isSuccess) {
        // Handle successful login
        _handleSuccessfulLogin(result);
      } else {
        // Handle login failure
        setState(() {
          _errorMessage = result.errorMessage;
        });
      }
    } catch (e) {
      // Handle unexpected errors
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      // Always reset loading state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Handle successful login - navigate to home screen
  void _handleSuccessfulLogin(AuthResult result) {
    // Clear sensitive data from controllers
    _passwordController.clear();

    // Navigate to home screen
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secure Login Example')),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email field with validation
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                enableSuggestions: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!_isValidEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password field with security features
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Error message display
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(
                      AppConstants.defaultRadius,
                    ),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              const SizedBox(height: 16),

              // Login button
              SizedBox(
                width: double.infinity,
                height: AppConstants.buttonHeight,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _performSecureLogin,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Secure Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Email validation helper
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(email);
  }
}

/// Provider for the secure auth service
final secureAuthServiceProvider = Provider<SecureAuthService>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  final localStorage = ref.read(localStorageServiceProvider);

  return SecureAuthService(
    authRepository: authRepository,
    localStorage: localStorage,
  );
});

/// Provider for auth repository (assuming it exists)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final localStorage = ref.read(localStorageServiceProvider);
  return AuthRepositoryImpl(localStorage);
});

/// Provider for localStorage service (assuming it exists)
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});
