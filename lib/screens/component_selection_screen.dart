import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import '../widgets/side_menu.dart';
import 'product_listing_screen.dart'; 

class ComponentSelectionScreen extends StatelessWidget {
  final VoidCallback onViewCart;
  final Function(String) onSelectComponent;
  final VoidCallback onLogout;
  final Product? cartItem; // This is used to check if the cart has items

  const ComponentSelectionScreen({
    super.key,
    required this.onViewCart,
    required this.onSelectComponent,
    required this.onLogout,
    this.cartItem,
  });

  static const _componentCategories = [
    {'name': 'Processor', 'icon': Icons.memory, 'color': Colors.red},
    {'name': 'Motherboard', 'icon': Icons.developer_board, 'color': Colors.blueGrey},
    {'name': 'RAM', 'icon': Icons.sd_storage, 'color': Colors.green},
    {'name': 'Storage', 'icon': Icons.dvr, 'color': Colors.purple},
    {'name': 'GPU', 'icon': Icons.videogame_asset, 'color': Colors.orange},
    {'name': 'Cooling', 'icon': Icons.ac_unit, 'color': Colors.cyan},
    {'name': 'PSU', 'icon': Icons.flash_on, 'color': Colors.yellow},
    {'name': 'Case', 'icon': Icons.all_out, 'color': Colors.pink},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(onLogout: onLogout),
      appBar: AppBar(
        title: const Text('BuildX', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // Added a Cart Icon in the AppBar for easier access
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
            // Status bar showing building progress
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
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 16.0, 
                  mainAxisSpacing: 16.0, 
                  childAspectRatio: 0.85
                ),
                itemCount: _componentCategories.length,
                itemBuilder: (context, index) {
                  final item = _componentCategories[index];
                  return _ComponentCard(
                    name: item['name'] as String,
                    icon: item['icon'] as IconData,
                    iconColor: item['color'] as Color,
                    onSelect: () => onSelectComponent(item['name'] as String),
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
  final IconData icon;
  final Color iconColor;
  final VoidCallback onSelect;

  const _ComponentCard({required this.name, required this.icon, required this.iconColor, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell( // Making the whole card clickable
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
                shape: BoxShape.circle
              ),
              child: const Icon(Icons.add, size: 20, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}