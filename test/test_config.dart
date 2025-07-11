import 'package:flutter_test/flutter_test.dart';

/// Test configuration and setup utilities
class TestConfig {
  /// Initialize test environment
  static void initialize() {
    TestWidgetsFlutterBinding.ensureInitialized();
  }

  /// Set up test environment with specific configurations
  static void setupTestEnvironment() {
    // Set up any test-specific configurations here
    // For example, mock services, set test data, etc.
  }

  /// Clean up test environment
  static void tearDownTestEnvironment() {
    // Clean up any test-specific resources here
  }
}

/// Test data constants
class TestData {
  static const String testProductId = 'test-product-1';
  static const String testProductName = 'Test Product';
  static const String testProductDescription = 'Test Description';
  static const double testProductPrice = 99.99;
  static const String testProductCategory = 'Electronics';
  static const String testProductImageUrl =
      'https://example.com/test-image.jpg';
  static const double testProductRating = 4.5;
  static const int testProductReviewCount = 100;
  static const bool testProductInStock = true;
  static const List<String> testProductTags = ['test', 'electronics'];
}

/// Test utilities for common assertions
class TestAssertions {
  /// Assert that a widget is visible
  static void assertWidgetIsVisible(Finder finder) {
    expect(finder, findsOneWidget);
  }

  /// Assert that a widget is not visible
  static void assertWidgetIsNotVisible(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Assert that text is present
  static void assertTextIsPresent(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Assert that text is not present
  static void assertTextIsNotPresent(String text) {
    expect(find.text(text), findsNothing);
  }

  /// Assert that a widget type is present
  static void assertWidgetTypeIsPresent(Type type) {
    expect(find.byType(type), findsWidgets);
  }

  /// Assert that a widget type is not present
  static void assertWidgetTypeIsNotPresent(Type type) {
    expect(find.byType(type), findsNothing);
  }
}
