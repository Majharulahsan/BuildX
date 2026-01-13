import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class OrderConfirmedScreen extends StatelessWidget {
  final VoidCallback onStartNewBuild;

  const OrderConfirmedScreen({
    super.key,
    required this.onStartNewBuild,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Confirmation Icon
                Icon(
                  Icons.check_circle_outline,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),
                
                // Title
                const Text(
                  'Order Confirmed!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle/Message
                Text(
                  'Your component order is being processed and will ship soon.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 40),

                // Action Button
                PrimaryButton(
                  text: 'Start New Build',
                  onPressed: onStartNewBuild,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}