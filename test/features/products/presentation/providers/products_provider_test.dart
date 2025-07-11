import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pgtl_flutter_test/features/products/domain/models/product.dart';
import 'package:pgtl_flutter_test/features/products/presentation/providers/products_provider.dart';

void main() {
  group('ProductsProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should load products successfully', () async {
      final productsAsync = container.read(productsProvider);

      // Wait for the async value to complete
      await Future.delayed(const Duration(milliseconds: 600));

      final products = productsAsync.value;

      expect(products, isNotNull);
      expect(products, isNotEmpty);
      expect(products!.first, isA<Product>());
    });

    test('should provide products with valid structure', () async {
      final productsAsync = container.read(productsProvider);

      await Future.delayed(const Duration(milliseconds: 600));
      final products = productsAsync.value;

      expect(products, isNotNull);
      for (final product in products!) {
        expect(product.id, isNotEmpty);
        expect(product.name, isNotEmpty);
        expect(product.description, isNotEmpty);
        expect(product.price, isPositive);
        expect(product.category, isNotEmpty);
        expect(product.imageUrl, isNotEmpty);
        expect(product.rating, isA<double>());
        expect(product.reviewCount, isA<int>());
        expect(product.inStock, isA<bool>());
        expect(product.tags, isA<List<String>>());
      }
    });
  });

  group('ProductsFilterState Tests', () {
    test('should create filter state with default values', () {
      const filter = ProductsFilterState();

      expect(filter.searchQuery, '');
      expect(filter.category, isNull);
      expect(filter.sortBy, 'name');
    });

    test('should create filter state with custom values', () {
      const filter = ProductsFilterState(
        searchQuery: 'test',
        category: 'Electronics',
        sortBy: 'price',
      );

      expect(filter.searchQuery, 'test');
      expect(filter.category, 'Electronics');
      expect(filter.sortBy, 'price');
    });

    test('should copy filter state with new values', () {
      const originalFilter = ProductsFilterState(
        searchQuery: 'original',
        category: 'Original',
        sortBy: 'name',
      );

      final newFilter = originalFilter.copyWith(
        searchQuery: 'new',
        category: 'New',
      );

      expect(newFilter.searchQuery, 'new');
      expect(newFilter.category, 'New');
      expect(newFilter.sortBy, 'name'); // unchanged
    });

    test('should copy filter state with partial values', () {
      const originalFilter = ProductsFilterState(
        searchQuery: 'original',
        category: 'Original',
        sortBy: 'name',
      );

      final newFilter = originalFilter.copyWith(searchQuery: 'new');

      expect(newFilter.searchQuery, 'new');
      expect(newFilter.category, 'Original'); // unchanged
      expect(newFilter.sortBy, 'name'); // unchanged
    });

    test('should convert filter state to JSON', () {
      const filter = ProductsFilterState(
        searchQuery: 'test',
        category: 'Electronics',
        sortBy: 'price',
      );

      final json = filter.toJson();

      expect(json['searchQuery'], 'test');
      expect(json['category'], 'Electronics');
      expect(json['sortBy'], 'price');
    });

    test('should create filter state from JSON', () {
      final json = {
        'searchQuery': 'test',
        'category': 'Electronics',
        'sortBy': 'price',
      };

      final filter = ProductsFilterState.fromJson(json);

      expect(filter.searchQuery, 'test');
      expect(filter.category, 'Electronics');
      expect(filter.sortBy, 'price');
    });

    test('should handle null values in JSON', () {
      final json = {'searchQuery': 'test', 'category': null, 'sortBy': 'price'};

      final filter = ProductsFilterState.fromJson(json);

      expect(filter.searchQuery, 'test');
      expect(filter.category, isNull);
      expect(filter.sortBy, 'price');
    });

    test('should use default values for missing JSON fields', () {
      final json = {'searchQuery': 'test'};

      final filter = ProductsFilterState.fromJson(json);

      expect(filter.searchQuery, 'test');
      expect(filter.category, isNull);
      expect(filter.sortBy, 'name'); // default value
    });
  });
}
