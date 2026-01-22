import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/product_listing_screen.dart';

class ProductRepository {
  // Fetch products from Firestore by category
  static Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          name: data['name'] ?? '',
          specs: data['specs'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
          price: (data['price'] ?? 0).toDouble(),
          imageUrl: data['imageUrl'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Fetch all unique categories from Firestore
  static Future<List<String>> getCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .get();

      final categories = <String>{};
      for (var doc in snapshot.docs) {
        final category = doc.data()['category'];
        if (category != null) {
          categories.add(category);
        }
      }

      return categories.toList()..sort();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Get category icon mapping
  static Map<String, dynamic> getCategoryInfo(String category) {
    const categoryMap = {
      'Processor': {'icon': 'memory', 'color': 'red'},
      'GPU': {'icon': 'videogame_asset', 'color': 'orange'},
      'Motherboard': {'icon': 'developer_board', 'color': 'blueGrey'},
      'RAM': {'icon': 'sd_storage', 'color': 'green'},
      'Storage': {'icon': 'dvr', 'color': 'purple'},
      'Cooling': {'icon': 'ac_unit', 'color': 'cyan'},
      'PSU': {'icon': 'flash_on', 'color': 'yellow'},
      'Case': {'icon': 'all_out', 'color': 'pink'},
    };

    return categoryMap[category] ?? {'icon': 'category', 'color': 'grey'};
  }
}