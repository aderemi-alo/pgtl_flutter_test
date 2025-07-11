import 'package:flutter_test/flutter_test.dart';
import 'package:pgtl_flutter_test/features/products/data/products_repository_impl.dart';
import 'package:pgtl_flutter_test/features/products/domain/models/product.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductsRepositoryImpl Tests', () {
    late ProductsRepositoryImpl repository;

    setUp(() {
      repository = ProductsRepositoryImpl();
    });

    test('should load products from JSON file', () async {
      final products = await repository.getProducts();

      // Verify that products are loaded (we know the actual data has products)
      expect(products, isNotEmpty);
      expect(products.first, isA<Product>());
      expect(products.first.id, isNotEmpty);
      expect(products.first.name, isNotEmpty);
      expect(products.first.price, isPositive);
    });

    test('should extract unique categories from products', () async {
      final categories = await repository.getCategories();

      // Verify that categories are extracted
      expect(categories, isNotEmpty);
      expect(categories, isA<List<String>>());

      // Verify that categories are unique (no duplicates)
      expect(categories.toSet().length, equals(categories.length));

      // Verify that categories are sorted
      final sortedCategories = List<String>.from(categories)..sort();
      expect(categories, equals(sortedCategories));
    });

    test('should handle products with different categories', () async {
      final products = await repository.getProducts();
      final categories = await repository.getCategories();

      // Verify that all product categories are included in the categories list
      final productCategories = products.map((p) => p.category).toSet();
      final categorySet = categories.toSet();

      expect(
        productCategories.every((cat) => categorySet.contains(cat)),
        isTrue,
      );
    });

    test('should return products with valid structure', () async {
      final products = await repository.getProducts();

      for (final product in products) {
        expect(product.id, isNotEmpty);
        expect(product.name, isNotEmpty);
        expect(product.description, isNotEmpty);
        expect(product.price, isPositive);
        expect(product.category, isNotEmpty);
        expect(product.imageUrl, isNotEmpty);
        expect(product.rating, isA<double>());
        expect(product.rating, greaterThanOrEqualTo(0.0));
        expect(product.rating, lessThanOrEqualTo(5.0));
        expect(product.reviewCount, isA<int>());
        expect(product.reviewCount, greaterThanOrEqualTo(0));
        expect(product.inStock, isA<bool>());
        expect(product.tags, isA<List<String>>());
      }
    });

    test('should handle network delay simulation', () async {
      final stopwatch = Stopwatch()..start();

      await repository.getProducts();

      stopwatch.stop();

      // Verify that there's some delay (at least 400ms to account for the 500ms delay)
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(400));
    });
  });
}
