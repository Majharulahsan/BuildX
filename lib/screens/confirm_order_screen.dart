import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class ConfirmOrderScreen extends StatelessWidget {
  // Keeping dynamic for compatibility, but expecting Map<String, dynamic> or null
  final dynamic item; 
  final VoidCallback onNavigateBack;
  final VoidCallback onConfirm;

  const ConfirmOrderScreen({
    super.key,
    required this.item,
    required this.onNavigateBack,
    required this.onConfirm,
  });

  // Static values based on screenshot for consistency
  final double subtotal = 550.00;
  final double tax = 44.00;
  final double shipping = 15.99;
  final double total = 609.99; // Adjusted sum: 550 + 44 + 15.99 = 609.99

  @override
  Widget build(BuildContext context) {
    // Determine the component name and ensure it's not null.
    // Assuming 'item' is either null, a Product object, or a Map<String, dynamic>
    String itemName;
    if (item == null) {
      itemName = 'No Component Selected';
    } else if (item is Map<String, dynamic> && item.containsKey('name')) {
      // Case 1: item is correctly passed as a Map
      itemName = item['name'] as String;
    } else if (item != null && item.name is String) {
      // Case 2: item is incorrectly passed as a Product object (assuming Product has a 'name' field)
      // This line relies on the external Product class having a 'name' property.
      itemName = item.name as String;
    } 
    else {
      // Fallback for all other cases (non-map object without a 'name' field, etc.)
      itemName = 'Selected Component';
    }


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onNavigateBack,
        ),
        title: const Text('Back'),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Confirm Order',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Review purchase', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),

                  // Items Card
                  _ConfirmSectionCard(
                    // Update Item count based on whether an item is present
                    title: 'Items (${item != null ? 1 : 0})',
                    icon: Icons.inventory_2_outlined,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // FIX: Use the safely determined itemName
                              Text(itemName, style: const TextStyle(fontSize: 16)),
                              const Text('Processor', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                          Text('\$${subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Shipping Card
                  _ConfirmSectionCard(
                    title: 'Shipping',
                    icon: Icons.location_on_outlined,
                    children: [
                      const Text('123 Main St, NY 10001',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Payment Card
                  _ConfirmSectionCard(
                    title: 'Payment',
                    icon: Icons.credit_card,
                    children: [
                      const Text('•••• •••• •••• 4242',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),

                  // Add more space to push summary to the bottom
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          // Sticky Bottom Section (Total and Button)
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  // FIX: Replaced deprecated withOpacity
                  color: const Color.fromRGBO(0, 0, 0, 0.5), 
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                _PriceRow(label: 'Subtotal', price: subtotal),
                _PriceRow(label: 'Tax', price: tax),
                _PriceRow(label: 'Shipping', price: shipping),
                const Divider(height: 24, color: Colors.grey),
                _PriceRow(
                  label: 'Total',
                  price: total,
                  isTotal: true,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: 'Confirm - \$${total.toStringAsFixed(2)}',
                  onPressed: onConfirm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _ConfirmSectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          const Divider(height: 16, color: Colors.white12),
          ...children,
        ],
      ),
    );
  }
}

// Reusing _PriceRow from cart_screen for price display consistency
class _PriceRow extends StatelessWidget {
  final String label;
  final double price;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.price,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.white : Colors.grey[400],
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}