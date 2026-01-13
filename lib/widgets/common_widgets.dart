import 'package:flutter/material.dart';

// --- Global Enum for Navigation ---
enum ScreenType {
  login,
  signUp,
  components,
  listing, // New screen type for product listing
  cart,
  confirmOrder,
  orderConfirmed,
}

// Path for the local logo image asset
// IMPORTANT: Ensure you have added 'assets/images/logo.png' and updated pubspec.yaml
const String _logoImagePath = 'assets/images/logo.png'; 

// --- 1. AppCard Widget ---
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

// --- 2. Primary Button Widget ---
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          shadowColor: Theme.of(context).primaryColor.withOpacity(0.5),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

// --- 3. Logo Header Widget ---
class LogoHeader extends StatelessWidget {
  final String subtitle;

  const LogoHeader({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Using Image.asset for the local logo picture
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.asset(
            _logoImagePath,
            width: 48,
            height: 48,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.precision_manufacturing_outlined,
              color: Colors.black,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'BuildX',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

// --- 4. Product List Item Widget ---
class ProductListItem extends StatelessWidget {
  final String name;
  final String specs;
  final double rating;
  final double price;
  final VoidCallback onAdd;

  const ProductListItem({
    super.key,
    required this.name,
    required this.specs,
    required this.rating,
    required this.price,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specs,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Stock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Add Button
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// --- 5. Navigation Controls Widget (NEW) ---
class NavigationControls extends StatelessWidget {
  final VoidCallback onGoBack;
  final VoidCallback onGoForward;
  final bool enableBack;
  final bool enableForward;

  const NavigationControls({
    super.key,
    required this.onGoBack,
    required this.onGoForward,
    this.enableBack = true,
    this.enableForward = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          color: enableBack ? Colors.white : Colors.grey[700],
          onPressed: enableBack ? onGoBack : null,
          tooltip: 'Go Back',
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          color: enableForward ? Colors.white : Colors.grey[700],
          onPressed: enableForward ? onGoForward : null,
          tooltip: 'Go Forward',
        ),
      ],
    );
  }
}