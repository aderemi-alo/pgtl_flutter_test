import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pgtl_flutter_test/features/features.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  @override
  Future<List<Product>> getProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Load mock data from assets
    final jsonString = await rootBundle.loadString('assets/data/products.json');
    final jsonList = json.decode(jsonString) as List;

    return jsonList.map((json) => Product.fromJson(json)).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final products = await getProducts();
    final categories =
        products.map((product) => product.category).toSet().toList();
    categories.sort();
    return categories;
  }
}
