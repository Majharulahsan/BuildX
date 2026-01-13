import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class Product {
  final String name;
  final String specs;
  final double rating;
  final double price;
  final String imageUrl;

  Product({
    required this.name,
    required this.specs,
    required this.rating,
    required this.price,
    required this.imageUrl,
  });
}

class ProductListingScreen extends StatefulWidget {
  final String categoryTitle;
  final List<Product> products;
  final VoidCallback onNavigateBack;
  final Function(Product) onProductAdded;

  const ProductListingScreen({
    super.key,
    required this.categoryTitle,
    required this.products,
    required this.onNavigateBack,
    required this.onProductAdded,
  });

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  late List<Product> _filteredProducts;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.products;
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      if (enteredKeyword.isEmpty) {
        _filteredProducts = widget.products;
      } else {
        _filteredProducts = widget.products
            .where((product) =>
                product.name.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
                product.specs.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: CustomScrollView(
        slivers: [
          // 1. The Dynamic App Bar with Search Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            backgroundColor: const Color(0xFF141414),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: widget.onNavigateBack,
            ),
            title: Text(widget.categoryTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => _runFilter(value),
                  autofocus: false, // Prevents keyboard from jumping up instantly
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search for ${widget.categoryTitle.toLowerCase()}...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.red),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              _runFilter('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF262626), // Lighter than background to stand out
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. The Results List
          _filteredProducts.isEmpty
              ? const SliverFillRemaining(
                  child: Center(
                    child: Text('No products found.', style: TextStyle(color: Colors.grey)),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = _filteredProducts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ProductListItem(
                            name: product.name,
                            specs: product.specs,
                            rating: product.rating,
                            price: product.price,
                            onAdd: () => widget.onProductAdded(product),
                          ),
                        );
                      },
                      childCount: _filteredProducts.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}