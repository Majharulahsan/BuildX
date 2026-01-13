import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items; // Changed from single item to List
  final Function(String) onRemoveItem;
  final VoidCallback onNavigateBack;
  final VoidCallback onCheckout;

  const CartScreen({
    super.key,
    required this.items,
    required this.onRemoveItem,
    required this.onNavigateBack,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCartEmpty = items.isEmpty;
    
    // Calculate totals for the whole list
    double subtotal = 0;
    for (var item in items) {
      subtotal += item['price'];
    }
    
    final tax = subtotal * 0.08;
    final shipping = isCartEmpty ? 0.0 : 15.99;
    final total = subtotal + tax + shipping;

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onNavigateBack,
        ),
        title: const Text('Back', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isCartEmpty
          ? _buildEmptyCart(context)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Cart', 
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)
                      ),
                      Text(
                        '${items.length} items selected', 
                        style: TextStyle(color: Colors.grey[500], fontSize: 16)
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildProductCard(items[index]),
                      );
                    },
                  ),
                ),
                _buildSummaryPanel(subtotal, tax, shipping, total),
              ],
            ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'], 
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['category'], 
                      style: const TextStyle(color: Color(0xFFE50914), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item['details'], 
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                onPressed: () => onRemoveItem(item['category']),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$${item['price'].toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPanel(double subtotal, double tax, double shipping, double total) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _summaryRow('Subtotal', subtotal),
          _summaryRow('Tax (8%)', tax),
          _summaryRow('Shipping', shipping),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Colors.white10),
          ),
          _summaryRow('Total', total, isTotal: true),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE50914),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: onCheckout,
              child: Text(
                'Checkout - \$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isTotal ? Colors.white : Colors.grey[400], fontSize: isTotal ? 19 : 15, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text('\$${value.toStringAsFixed(2)}', style: TextStyle(color: Colors.white, fontSize: isTotal ? 19 : 15, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[800]),
          const SizedBox(height: 20),
          const Text('Your cart is empty', style: TextStyle(fontSize: 20, color: Colors.white70)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onNavigateBack,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50914)),
            child: const Text('Start Building'),
          )
        ],
      ),
    );
  }
}