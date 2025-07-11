import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pgtl_flutter_test/core/utils/validators.dart';
import 'package:pgtl_flutter_test/core/constants/app_constants.dart';
import 'package:pgtl_flutter_test/features/shared/widgets/loading_overlay.dart';
import 'package:pgtl_flutter_test/features/auth/presentation/providers/auth_provider.dart';
import 'package:pgtl_flutter_test/features/auth/presentation/widgets/password_field.dart';

/// Login screen that handles user authentication
/// Features real-time form validation and security feedback
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  bool _formValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validates form fields in real-time and updates UI state
  void _validateForm() {
    final email = _emailController.text;
    final password = _passwordController.text;
    final emailError = Validators.validateEmail(email);
    final passwordError = Validators.validatePassword(password);
    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
      _formValid = emailError == null && passwordError == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginStateProvider);

    // Listen to state changes for error handling and navigation
    ref.listen<LoginState>(loginStateProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        _showErrorDialog(next.error!);
      }

      if (next.isSuccess) {
        _showSuccessDialog();
      }
    });

    return Scaffold(
      body: LoadingOverlay(
        isLoading: loginState.isLoading,
        message: AppConstants.loggingIn,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Center(child: _buildLoginForm(loginState)),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the main login form with all UI components
  Widget _buildLoginForm(LoginState loginState) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo/Title Section
          _buildHeader(),
          const SizedBox(height: 48),

          // Form Fields
          _buildFormFields(loginState),
          const SizedBox(height: 24),

          // Login Button
          _buildLoginButton(loginState),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Builds the header section with app branding
  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.person, size: 64, color: Theme.of(context).primaryColor),
        const SizedBox(height: 16),
        Text(
          'Welcome Back',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to your account',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Builds form input fields with validation
  Widget _buildFormFields(LoginState loginState) {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          enabled: !loginState.isLoading,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: const Icon(Icons.email_outlined),
            errorText: _emailError,
          ),
          validator: Validators.validateEmail,
          onChanged: (_) => _validateForm(),
        ),
        const SizedBox(height: 16),
        PasswordField(
          controller: _passwordController,
          enabled: !loginState.isLoading,
          validator: Validators.validatePassword,
          errorText: _passwordError,
          onChanged: (_) => _validateForm(),
        ),
      ],
    );
  }

  /// Builds the login button with dynamic styling based on form state
  Widget _buildLoginButton(LoginState loginState) {
    final isEnabled = _formValid && !loginState.isLoading;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: isEnabled ? _handleLogin : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _formValid ? Theme.of(context).colorScheme.primary : null,
          foregroundColor: _formValid ? Colors.white : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Text(
          loginState.isLoading ? 'Signing In...' : 'Sign In',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// Handles login form submission with validation
  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      ref.read(loginStateProvider.notifier).login(email, password);
    } else {
      _validateForm();
    }
  }

  /// Shows error dialog with lockout countdown if applicable
  void _showErrorDialog(String error) {
    final loginState = ref.read(loginStateProvider);
    final lockoutUntil = loginState.lockoutUntil;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Login Failed'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(error),
                if (lockoutUntil != null &&
                    lockoutUntil.isAfter(DateTime.now())) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Account will be unlocked in:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _CountdownTimer(lockoutUntil: lockoutUntil),
                ],
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
    );
  }

  /// Handles successful login by navigating to products screen
  void _showSuccessDialog() {
    // Navigate to products screen after successful login
    context.go('/products');
    ref.read(loginStateProvider.notifier).resetState();
  }
}

/// Countdown timer widget for displaying lockout remaining time
class _CountdownTimer extends StatefulWidget {
  final DateTime lockoutUntil;

  const _CountdownTimer({required this.lockoutUntil});

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  late Timer _timer;
  late String _timeString;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final difference = widget.lockoutUntil.difference(now);

    if (difference.isNegative) {
      setState(() {
        _timeString = '00:00';
      });
      return;
    }

    // Calculate minutes and seconds
    final totalSeconds = difference.inSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    setState(() {
      _timeString =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeString,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
