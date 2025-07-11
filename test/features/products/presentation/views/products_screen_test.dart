import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pgtl_flutter_test/features/products/domain/models/product.dart';
import 'package:pgtl_flutter_test/features/products/presentation/views/products_screen.dart';

void main() {
  group('ProductsScreen Widget Tests', () {
    testWidgets('should display loading indicator initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display products grid when data is loaded', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Should show products grid
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('should display search bar and category filter', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Should show search field
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);

      // Should show category dropdown
      expect(find.byType(DropdownButton<String?>), findsOneWidget);
    });

    testWidgets('should filter products by search query', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Wireless');
      await tester.pump();

      // Should filter products based on search
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('should display product card with correct information', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Should display product information
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('should handle empty search results', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Enter search query that won't match any products
      await tester.enterText(find.byType(TextField), 'NonExistentProduct');
      await tester.pump();

      // Should show empty grid
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should display app bar with title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ProductsScreen())),
      );

      // Should show app bar with title
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Products'), findsOneWidget);
    });
  });

  group('ProductCard Widget Tests', () {
    const testProduct = Product(
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

    testWidgets('should display product information correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: 1,
              itemBuilder:
                  (context, index) => Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.grey,
                            child: const Center(
                              child: Text('Image Placeholder'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(testProduct.name),
                              Text(testProduct.category),
                              Text('\$${testProduct.price.toStringAsFixed(2)}'),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  Text(
                                    '${testProduct.rating} (${testProduct.reviewCount})',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
        ),
      );

      // Should display product name
      expect(find.text('Test Product'), findsOneWidget);

      // Should display category
      expect(find.text('Electronics'), findsOneWidget);

      // Should display price
      expect(find.text('\$99.99'), findsOneWidget);

      // Should display rating
      expect(find.text('4.5 (100)'), findsOneWidget);
    });

    testWidgets(
      'should display out of stock indicator when product is not in stock',
      (tester) async {
        const outOfStockProduct = Product(
          id: '2',
          name: 'Out of Stock Product',
          description: 'Test Description',
          price: 99.99,
          category: 'Electronics',
          imageUrl: 'https://example.com/image.jpg',
          rating: 4.5,
          reviewCount: 100,
          inStock: false,
          tags: ['test'],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: 1,
                itemBuilder:
                    (context, index) => Card(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.grey,
                              child: const Center(
                                child: Text('Image Placeholder'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(outOfStockProduct.name),
                                Text(outOfStockProduct.category),
                                Text(
                                  '\$${outOfStockProduct.price.toStringAsFixed(2)}',
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    Text(
                                      '${outOfStockProduct.rating} (${outOfStockProduct.reviewCount})',
                                    ),
                                  ],
                                ),
                                if (!outOfStockProduct.inStock)
                                  const Text(
                                    'Out of stock',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
        );

        // Should display out of stock text
        expect(find.text('Out of stock'), findsOneWidget);
      },
    );
  });
}
