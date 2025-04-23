import 'package:dokanpat/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_tile.dart';
import '../controllers/product_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String searchQuery;

  const SearchScreen({super.key, required this.searchQuery});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final ScrollController _scrollController = ScrollController();
  String _sortBy = '';
  int _loadedCount = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() => _loadedCount += 10);
    }
  }

  List<Product> _applyFilters(List<Product> products) {
    List<Product> filtered = products
        .where((p) =>
            p.title.toLowerCase().contains(widget.searchQuery.toLowerCase()))
        .toList();

    switch (_sortBy) {
      case 'price_low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return filtered.take(_loadedCount).toList();
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Price - Low to High"),
            onTap: () {
              setState(() => _sortBy = 'price_low');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Price - High to Low"),
            onTap: () {
              setState(() => _sortBy = 'price_high');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Rating"),
            onTap: () {
              setState(() => _sortBy = 'rating');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productProvider);

    return Scaffold(
      body: Column(
        children: [
          // Search bar and filter button at the top
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: widget.searchQuery),
                    onSubmitted: (value) {
                      setState(() {
                        // Handle the search action if needed
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Products...',
                      filled: true,
                      fillColor: Colors.white
                          .withOpacity(0.8), // Transparent background
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showSortOptions(context),
                ),
              ],
            ),
          ),
          // Main Product List
          Expanded(
            child: Stack(
              children: [
                productsAsync.when(
                  data: (products) {
                    final filteredProducts = _applyFilters(products);
                    return GridView.builder(
                      controller: _scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ProductTile(product: filteredProducts[index]);
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('Error: $err')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
