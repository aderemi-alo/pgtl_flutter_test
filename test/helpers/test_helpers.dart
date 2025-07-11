import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pgtl_flutter_test/features/products/domain/models/product.dart';

/// Test helper utilities for common test operations
class TestHelpers {
  /// Creates a test product with default values
  static Product createTestProduct({
    String id = '1',
    String name = 'Test Product',
    String description = 'Test Description',
    double price = 99.99,
    String category = 'Electronics',
    String imageUrl = 'https://example.com/image.jpg',
    double rating = 4.5,
    int reviewCount = 100,
    bool inStock = true,
    List<String> tags = const ['test', 'electronics'],
  }) {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      category: category,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
      inStock: inStock,
      tags: tags,
    );
  }

  /// Creates a list of test products
  static List<Product> createTestProducts() {
    return [
      createTestProduct(
        id: '1',
        name: 'Wireless Headphones',
        category: 'Electronics',
        price: 199.99,
        inStock: true,
      ),
      createTestProduct(
        id: '2',
        name: 'Smart Watch',
        category: 'Wearables',
        price: 299.99,
        inStock: false,
      ),
      createTestProduct(
        id: '3',
        name: 'Laptop',
        category: 'Electronics',
        price: 999.99,
        inStock: true,
      ),
    ];
  }

  /// Wraps a widget with necessary providers for testing
  static Widget wrapWithProviders(Widget child) {
    return ProviderScope(child: MaterialApp(home: child));
  }

  /// Waits for async operations to complete
  static Future<void> waitForAsync(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(milliseconds: 600));
  }

  /// Finds a widget by type and text
  static Finder findWidgetByTypeAndText(Type type, String text) {
    return find.byWidgetPredicate(
      (widget) =>
          widget.runtimeType == type && widget.toString().contains(text),
    );
  }

  /// Checks if a widget is visible
  static bool isWidgetVisible(Finder finder) {
    return finder.evaluate().isNotEmpty;
  }

  /// Gets the text content of a widget
  static String? getWidgetText(Finder finder) {
    final elements = finder.evaluate();
    if (elements.isEmpty) return null;

    final widget = elements.first.widget;
    if (widget is Text) {
      return widget.data;
    }
    return null;
  }

  /// Simulates user interaction with a text field
  static Future<void> enterTextInField(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.pump();
  }

  /// Simulates tapping on a widget
  static Future<void> tapWidget(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Checks if a widget contains specific text
  static bool containsText(String text) {
    return find.textContaining(text).evaluate().isNotEmpty;
  }

  /// Checks if a widget of specific type exists
  static bool hasWidgetOfType(Type type) {
    return find.byType(type).evaluate().isNotEmpty;
  }

  /// Creates a mock JSON response for products
  static Map<String, dynamic> createMockProductJson({
    String id = '1',
    String name = 'Test Product',
    String description = 'Test Description',
    double price = 99.99,
    String category = 'Electronics',
    String imageUrl = 'https://example.com/image.jpg',
    double rating = 4.5,
    int reviewCount = 100,
    bool inStock = true,
    List<String> tags = const ['test', 'electronics'],
  }) {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'inStock': inStock,
      'tags': tags,
    };
  }

  /// Creates a list of mock JSON responses for products
  static List<Map<String, dynamic>> createMockProductsJson() {
    return [
      createMockProductJson(
        id: '1',
        name: 'Wireless Headphones',
        category: 'Electronics',
        price: 199.99,
        inStock: true,
      ),
      createMockProductJson(
        id: '2',
        name: 'Smart Watch',
        category: 'Wearables',
        price: 299.99,
        inStock: false,
      ),
      createMockProductJson(
        id: '3',
        name: 'Laptop',
        category: 'Electronics',
        price: 999.99,
        inStock: true,
      ),
    ];
  }
}
