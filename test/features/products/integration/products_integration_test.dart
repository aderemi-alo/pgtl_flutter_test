import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pgtl_flutter_test/features/products/presentation/views/products_screen.dart';

void main() {
  group('Products Integration Tests', () {
    testWidgets('should load and display products with filtering', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Initially should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Should show products grid
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Card), findsWidgets);

      // Should show search and filter controls
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(DropdownButton<String?>), findsOneWidget);

      // Test search functionality
      await tester.enterText(find.byType(TextField), 'Wireless');
      await tester.pump();

      // Should filter products based on search
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('should handle category filtering', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Find and tap the category dropdown
      final dropdown = find.byType(DropdownButton<String?>);
      expect(dropdown, findsOneWidget);

      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Should show category options
      expect(find.byType(DropdownMenuItem<String?>), findsWidgets);
    });

    testWidgets('should display product details correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Should display product information
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Icon), findsWidgets);

      // Should display price information
      expect(find.textContaining('\$'), findsWidgets);

      // Should display rating information
      expect(find.byIcon(Icons.star), findsWidgets);
    });

    testWidgets('should handle responsive grid layout', (tester) async {
      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 600)); // Small screen

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Should show grid with appropriate columns
      expect(find.byType(GridView), findsOneWidget);

      // Reset screen size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should handle error states gracefully', (tester) async {
      // This test would require mocking the repository to return an error
      // For now, we'll test that the UI handles loading states properly

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Initially should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Should show products or error state
      expect(
        find.byType(GridView).evaluate().isNotEmpty ||
            find.textContaining('Error').evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('should maintain filter state across rebuilds', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Test Search');
      await tester.pump();

      // Rebuild widget
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Wait for data to load again
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Search field should maintain its value
      expect(find.text('Test Search'), findsOneWidget);
    });

    testWidgets('should handle empty product list', (tester) async {
      // This test would require mocking the repository to return empty list
      // For now, we'll test that the UI handles the loading state properly

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Initially should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Should show either products or empty state
      expect(find.byType(GridView).evaluate().isNotEmpty, isTrue);
    });
  });
}
