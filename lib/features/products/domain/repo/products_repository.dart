import '../models/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProducts();
  Future<List<String>> getCategories();
}
