import 'package:go_router/go_router.dart';
import 'package:pgtl_flutter_test/features/auth/presentation/views/login_screen.dart';
import 'package:pgtl_flutter_test/features/products/presentation/views/products_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductsScreen(),
    ),
    // Add more routes as needed
  ],
);
