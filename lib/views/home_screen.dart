import 'package:dokanpat/views/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/product_provider.dart';
import 'product_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  void _onSearchSubmitted(String value) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(initialQuery: value.trim()),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productProvider); // Watch product data

    return Scaffold(
      body: Column(
        children: [
          // Search bar at the top
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: _onSearchSubmitted,
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
              ],
            ),
          ),
          // Product list
          Expanded(
            child: productsAsync.when(
              data: (products) {
                // Show all products in a grid
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    childAspectRatio: 0.75, // Aspect ratio of the items
                  ),
                  itemCount: products.length, // Number of items
                  itemBuilder: (context, index) {
                    return ProductTile(
                        product: products[index]); // Display product
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Error: $err')), // Error message
            ),
          ),
        ],
      ),
    );
  }
}

