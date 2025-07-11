import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pgtl_flutter_test/core/core.dart';
import 'package:pgtl_flutter_test/features/features.dart';

final productsRepositoryProvider = Provider((ref) => ProductsRepositoryImpl());

class ProductsFilterState {
  final String searchQuery;
  final String? category;
  final String sortBy;

  const ProductsFilterState({
    this.searchQuery = '',
    this.category,
    this.sortBy = 'name',
  });

  ProductsFilterState copyWith({
    String? searchQuery,
    String? category,
    String? sortBy,
  }) {
    return ProductsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      category: category,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  Map<String, dynamic> toJson() => {
    'searchQuery': searchQuery,
    'category': category,
    'sortBy': sortBy,
  };

  factory ProductsFilterState.fromJson(Map<String, dynamic> json) =>
      ProductsFilterState(
        searchQuery: json['searchQuery'] ?? '',
        category: json['category'],
        sortBy: json['sortBy'] ?? 'name',
      );
}

class ProductsFilterNotifier
    extends AutoDisposeAsyncNotifier<ProductsFilterState> {
  static const _prefsKey = 'products_filter_state';

  @override
  Future<ProductsFilterState> build() async {
    final localStorage = LocalStorageService();
    final jsonString = localStorage.getString(_prefsKey);
    if (jsonString != null) {
      return ProductsFilterState.fromJson(json.decode(jsonString));
    }
    return const ProductsFilterState();
  }

  Future<void> updateFilter(ProductsFilterState newState) async {
    state = AsyncValue.data(newState);
    final localStorage = LocalStorageService();
    await localStorage.saveString(_prefsKey, json.encode(newState.toJson()));
  }
}

final productsFilterProvider = AutoDisposeAsyncNotifierProvider<
  ProductsFilterNotifier,
  ProductsFilterState
>(ProductsFilterNotifier.new);

final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final repo = ref.watch(productsRepositoryProvider);
  return repo.getProducts();
});
