import 'package:pgtl_flutter_test/core/core.dart';
import 'package:pgtl_flutter_test/features/features.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Register LocalStorageService
  if (!locator.isRegistered<LocalStorageService>()) {
    locator.registerLazySingleton<LocalStorageService>(
      () => LocalStorageService(),
    );
  }

  // Initialize LocalStorageService
  if (!locator.isRegistered<LocalStorageService>()) {
    await locator.get<LocalStorageService>().init();
  } else {
    // If already registered, ensure it's initialized
    final localStorage = locator.get<LocalStorageService>();
    await localStorage.init();
  }

  // Register AuthRepository
  if (!locator.isRegistered<AuthRepository>()) {
    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(locator.get<LocalStorageService>()),
    );
  }
}
