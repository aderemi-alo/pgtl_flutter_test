import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pgtl_flutter_test/core/core.dart';
import 'package:pgtl_flutter_test/features/features.dart';

/// Repository provider for products data access
final productsRepositoryProvider = Provider((ref) => ProductsRepositoryImpl());

/// Represents the current filter state for products
/// Manages search query, category filter, and sorting preferences
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

  /// Converts filter state to JSON for persistent storage
  Map<String, dynamic> toJson() => {
    'searchQuery': searchQuery,
    'category': category,
    'sortBy': sortBy,
  };

  /// Creates filter state from JSON for persistent storage
  factory ProductsFilterState.fromJson(Map<String, dynamic> json) =>
      ProductsFilterState(
        searchQuery: json['searchQuery'] ?? '',
        category: json['category'],
        sortBy: json['sortBy'] ?? 'name',
      );
}

/// Manages products filter state with persistent storage
/// Automatically saves filter preferences to local storage
class ProductsFilterNotifier
    extends AutoDisposeAsyncNotifier<ProductsFilterState> {
  static const _prefsKey = 'products_filter_state';

  @override
  Future<ProductsFilterState> build() async {
    // Load saved filter state from local storage
    final localStorage = LocalStorageService();
    final jsonString = localStorage.getString(_prefsKey);
    if (jsonString != null) {
      return ProductsFilterState.fromJson(json.decode(jsonString));
    }
    return const ProductsFilterState();
  }

  /// Updates filter state and persists to local storage
  Future<void> updateFilter(ProductsFilterState newState) async {
    state = AsyncValue.data(newState);
    final localStorage = LocalStorageService();
    await localStorage.saveString(_prefsKey, json.encode(newState.toJson()));
  }
}

/// Provider for products filter state with auto-disposal
final productsFilterProvider = AutoDisposeAsyncNotifierProvider<
  ProductsFilterNotifier,
  ProductsFilterState
>(ProductsFilterNotifier.new);

/// Provider that fetches and provides the list of products
/// Auto-disposes when no longer needed to free memory
final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final repo = ref.watch(productsRepositoryProvider);
  return repo.getProducts();
});
