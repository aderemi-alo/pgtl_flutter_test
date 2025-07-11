import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pgtl_flutter_test/core/core.dart';
import '../providers/products_provider.dart';
import '../../domain/models/product.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterAsync = ref.watch(productsFilterProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: filterAsync.when(
        data: (filter) {
          return Column(
            children: [
              _SearchAndFilterBar(filter: filter),
              Expanded(
                child: productsAsync.when(
                  data: (products) {
                    // Apply filter and search
                    final filtered =
                        products.where((p) {
                          final matchesQuery =
                              filter.searchQuery.isEmpty ||
                              p.name.toLowerCase().contains(
                                filter.searchQuery.toLowerCase(),
                              );
                          final matchesCategory =
                              filter.category == null ||
                              filter.category!.isEmpty ||
                              p.category == filter.category;
                          return matchesQuery && matchesCategory;
                        }).toList();
                    // Sort
                    filtered.sort((a, b) => a.name.compareTo(b.name));
                    return _ProductsGrid(products: filtered);
                  },
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _SearchAndFilterBar extends ConsumerStatefulWidget {
  final ProductsFilterState filter;
  const _SearchAndFilterBar({required this.filter});

  @override
  ConsumerState<_SearchAndFilterBar> createState() =>
      _SearchAndFilterBarState();
}

class _SearchAndFilterBarState extends ConsumerState<_SearchAndFilterBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.filter.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(productsRepositoryProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                ref
                    .read(productsFilterProvider.notifier)
                    .updateFilter(widget.filter.copyWith(searchQuery: value));
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
          const SizedBox(width: 16),
          FutureBuilder<List<String>>(
            future: repo.getCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: 120,
                  height: 48,
                  child: Center(
                    child: Shimmer.fromColors(
                      baseColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.5),
                      highlightColor: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 100,
                        height: 48,
                      ),
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return const SizedBox(
                  width: 120,
                  height: 48,
                  child: Center(child: Icon(Icons.error)),
                );
              }

              final categories = snapshot.data ?? [];

              // Check if the current category value exists in the available categories
              final currentCategory = widget.filter.category;
              final isValidCategory =
                  currentCategory == null ||
                  categories.contains(currentCategory);

              return DropdownButton<String?>(
                borderRadius: BorderRadius.circular(20),
                value: isValidCategory ? currentCategory : null,
                hint: const Text('Category'),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All'),
                  ),
                  ...categories.map(
                    (cat) =>
                        DropdownMenuItem<String?>(value: cat, child: Text(cat)),
                  ),
                ],
                onChanged: (value) {
                  ref
                      .read(productsFilterProvider.notifier)
                      .updateFilter(widget.filter.copyWith(category: value));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProductsGrid extends StatelessWidget {
  final List<Product> products;
  const _ProductsGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.of(context).size.width > 600 ? 4 : 2;
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCard(product: product);
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product.category,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text('${product.rating} (${product.reviewCount})'),
                  ],
                ),
                if (!product.inStock)
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
    );
  }
}
