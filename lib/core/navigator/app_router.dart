import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pgtl_flutter_test/features/features.dart';

/// Application router configuration using GoRouter
/// Defines all app routes and their associated screens
final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // Login route - initial screen for authentication
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    // Products route - main content screen after authentication
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductsScreen(),
    ),
  ],
  // Error handling for invalid routes
  errorBuilder:
      (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'The page you are looking for does not exist.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
);
