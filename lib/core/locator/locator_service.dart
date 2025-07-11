import 'package:pgtl_flutter_test/core/core.dart';
import 'package:pgtl_flutter_test/features/features.dart';

/// Global dependency injection container instance
final locator = GetIt.instance;

/// Sets up dependency injection container with all required services
/// Registers services as lazy singletons for memory efficiency
Future<void> setupLocator() async {
  // Register LocalStorageService for persistent data storage
  if (!locator.isRegistered<LocalStorageService>()) {
    locator.registerLazySingleton<LocalStorageService>(
      () => LocalStorageService(),
    );
  }

  // Initialize LocalStorageService to ensure it's ready for use
  if (!locator.isRegistered<LocalStorageService>()) {
    await locator.get<LocalStorageService>().init();
  } else {
    // If already registered, ensure it's initialized
    final localStorage = locator.get<LocalStorageService>();
    await localStorage.init();
  }

  // Register AuthRepository for authentication operations
  if (!locator.isRegistered<AuthRepository>()) {
    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(locator.get<LocalStorageService>()),
    );
  }
}
