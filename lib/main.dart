import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pgtl_flutter_test/core/core.dart';

/// Main entry point for the Flutter application
/// Initializes core services and sets up the app configuration
Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Lock app to portrait orientation for better UX
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependency injection container
  await setupLocator();

  // Start the app with Riverpod provider scope
  runApp(const ProviderScope(child: MyApp()));
}

/// Root application widget with Material Design theme and routing
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Secure Login App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
