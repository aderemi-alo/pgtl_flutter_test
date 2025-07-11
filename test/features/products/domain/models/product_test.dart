import 'package:flutter_test/flutter_test.dart';
import 'package:pgtl_flutter_test/features/products/domain/models/product.dart';

void main() {
  group('Product Model Tests', () {
    test('should create Product with all required fields', () {
      const product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        category: 'Electronics',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        reviewCount: 100,
        inStock: true,
        tags: ['test', 'electronics'],
      );

      expect(product.id, '1');
      expect(product.name, 'Test Product');
      expect(product.description, 'Test Description');
      expect(product.price, 99.99);
      expect(product.category, 'Electronics');
      expect(product.imageUrl, 'https://example.com/image.jpg');
      expect(product.rating, 4.5);
      expect(product.reviewCount, 100);
      expect(product.inStock, true);
      expect(product.tags, ['test', 'electronics']);
    });

    test('should create Product from JSON', () {
      final json = {
        'id': '2',
        'name': 'JSON Product',
        'description': 'JSON Description',
        'price': 149.99,
        'category': 'Wearables',
        'imageUrl': 'https://example.com/json-image.jpg',
        'rating': 4.8,
        'reviewCount': 250,
        'inStock': false,
        'tags': ['json', 'wearables'],
      };

      final product = Product.fromJson(json);

      expect(product.id, '2');
      expect(product.name, 'JSON Product');
      expect(product.description, 'JSON Description');
      expect(product.price, 149.99);
      expect(product.category, 'Wearables');
      expect(product.imageUrl, 'https://example.com/json-image.jpg');
      expect(product.rating, 4.8);
      expect(product.reviewCount, 250);
      expect(product.inStock, false);
      expect(product.tags, ['json', 'wearables']);
    });

    test('should convert Product to JSON', () {
      const product = Product(
        id: '3',
        name: 'ToJSON Product',
        description: 'ToJSON Description',
        price: 299.99,
        category: 'Home Appliances',
        imageUrl: 'https://example.com/tojson-image.jpg',
        rating: 4.2,
        reviewCount: 75,
        inStock: true,
        tags: ['tojson', 'appliances'],
      );

      final json = product.toJson();

      expect(json['id'], '3');
      expect(json['name'], 'ToJSON Product');
      expect(json['description'], 'ToJSON Description');
      expect(json['price'], 299.99);
      expect(json['category'], 'Home Appliances');
      expect(json['imageUrl'], 'https://example.com/tojson-image.jpg');
      expect(json['rating'], 4.2);
      expect(json['reviewCount'], 75);
      expect(json['inStock'], true);
      expect(json['tags'], ['tojson', 'appliances']);
    });

    test('should handle price as integer in JSON', () {
      final json = {
        'id': '4',
        'name': 'Integer Price Product',
        'description': 'Test Description',
        'price': 100, // integer instead of double
        'category': 'Electronics',
        'imageUrl': 'https://example.com/image.jpg',
        'rating': 4.0,
        'reviewCount': 50,
        'inStock': true,
        'tags': ['test'],
      };

      final product = Product.fromJson(json);

      expect(product.price, 100.0);
    });

    test('should handle rating as integer in JSON', () {
      final json = {
        'id': '5',
        'name': 'Integer Rating Product',
        'description': 'Test Description',
        'price': 99.99,
        'category': 'Electronics',
        'imageUrl': 'https://example.com/image.jpg',
        'rating': 5, // integer instead of double
        'reviewCount': 50,
        'inStock': true,
        'tags': ['test'],
      };

      final product = Product.fromJson(json);

      expect(product.rating, 5.0);
    });

    test('should handle empty tags list', () {
      final json = {
        'id': '6',
        'name': 'Empty Tags Product',
        'description': 'Test Description',
        'price': 99.99,
        'category': 'Electronics',
        'imageUrl': 'https://example.com/image.jpg',
        'rating': 4.5,
        'reviewCount': 50,
        'inStock': true,
        'tags': [],
      };

      final product = Product.fromJson(json);

      expect(product.tags, isEmpty);
    });
  });
}
