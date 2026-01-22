import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/common_widgets.dart';
import '../widgets/side_menu.dart';
import 'product_listing_screen.dart';
import '../data/product_data.dart'; 

class ComponentSelectionScreen extends StatelessWidget {
  final VoidCallback onViewCart;
  final Function(String) onSelectComponent;
  final VoidCallback onLogout;
  final Product? cartItem;
  final Function(String)? onNavigate;

  const ComponentSelectionScreen({
    super.key,
    required this.onViewCart,
    required this.onSelectComponent,
    required this.onLogout,
    this.cartItem,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(onLogout: onLogout, onNavigate: onNavigate),
      appBar: AppBar(
        title: const Text('BuildX', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: onViewCart,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Build Progress', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('Customize your PC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: onViewCart,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50914)),
                    child: const Text('View Full Build'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('products').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFFE50914)));
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                    );
                  }

                  // Get unique categories from products
                  final categories = <String>{};
                  if (snapshot.hasData) {
                    for (var doc in snapshot.data!.docs) {
                      final category = doc.data() as Map<String, dynamic>;
                      if (category['category'] != null) {
                        categories.add(category['category']);
                      }
                    }
                  }

                  final categoryList = categories.toList()..sort();

                  if (categoryList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[700]),
                          const SizedBox(height: 16),
                          const Text(
                            'No categories available',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Admin needs to add products first',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      final category = categoryList[index];
                      final categoryInfo = ProductRepository.getCategoryInfo(category);
                      
                      return _ComponentCard(
                        name: category,
                        iconName: categoryInfo['icon'],
                        iconColorName: categoryInfo['color'],
                        onSelect: () => onSelectComponent(category),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComponentCard extends StatelessWidget {
  final String name;
  final String iconName;
  final String iconColorName;
  final VoidCallback onSelect;

  const _ComponentCard({
    required this.name,
    required this.iconName,
    required this.iconColorName,
    required this.onSelect,
  });

  IconData _getIconData(String iconName) {
    const iconMap = {
      'memory': Icons.memory,
      'developer_board': Icons.developer_board,
      'sd_storage': Icons.sd_storage,
      'dvr': Icons.dvr,
      'videogame_asset': Icons.videogame_asset,
      'ac_unit': Icons.ac_unit,
      'flash_on': Icons.flash_on,
      'all_out': Icons.all_out,
      'category': Icons.category,
    };
    return iconMap[iconName] ?? Icons.category;
  }

  Color _getColor(String colorName) {
    const colorMap = {
      'red': Colors.red,
      'blueGrey': Colors.blueGrey,
      'green': Colors.green,
      'purple': Colors.purple,
      'orange': Colors.orange,
      'cyan': Colors.cyan,
      'yellow': Colors.yellow,
      'pink': Colors.pink,
      'grey': Colors.grey,
    };
    return colorMap[colorName] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getIconData(iconName);
    final iconColor = _getColor(iconColorName);
    
    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onSelect,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: iconColor),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 20, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}