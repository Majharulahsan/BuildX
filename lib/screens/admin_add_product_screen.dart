import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAddProductScreen extends StatefulWidget {
  final VoidCallback onNavigateBack;
  final Map<String, dynamic>? existingProduct; // For editing

  const AdminAddProductScreen({
    super.key,
    required this.onNavigateBack,
    this.existingProduct,
  });

  @override
  State<AdminAddProductScreen> createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends State<AdminAddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specsController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  String _selectedCategory = 'Processor';
  bool _isLoading = false;
  
  final List<String> _categories = [
    'Processor',
    'GPU',
    'Motherboard',
    'RAM',
    'Storage',
    'Cooling',
    'PSU',
    'Case',
  ];

  // Default placeholder images for each category (free images from the web)
  final Map<String, String> _categoryPlaceholders = {
    'Processor': 'https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?w=400',
    'GPU': 'https://images.unsplash.com/photo-1591488320449-011701bb6704?w=400',
    'Motherboard': 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400',
    'RAM': 'https://images.unsplash.com/photo-1562976540-1502c2145186?w=400',
    'Storage': 'https://images.unsplash.com/photo-1597872200969-2b65d56bd16b?w=400',
    'Cooling': 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?w=400',
    'PSU': 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=400',
    'Case': 'https://images.unsplash.com/photo-1587831990711-23ca6441447b?w=400',
  };

  @override
  void initState() {
    super.initState();
    if (widget.existingProduct != null) {
      _nameController.text = widget.existingProduct!['name'] ?? '';
      _specsController.text = widget.existingProduct!['specs'] ?? '';
      _priceController.text = (widget.existingProduct!['price'] ?? 0).toString();
      _selectedCategory = widget.existingProduct!['category'] ?? 'Processor';
      _imageUrlController.text = widget.existingProduct!['imageUrl'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specsController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  String _getImageUrl() {
    final customUrl = _imageUrlController.text.trim();
    if (customUrl.isNotEmpty) {
      return customUrl;
    }
    // Return category placeholder if no custom URL
    return _categoryPlaceholders[_selectedCategory] ?? '';
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final productData = {
        'name': _nameController.text.trim(),
        'specs': _specsController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'category': _selectedCategory,
        'imageUrl': _getImageUrl(),
        'rating': 4.5, // Default rating
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (widget.existingProduct != null) {
        // Update existing product
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.existingProduct!['id'])
            .update(productData)
            .timeout(const Duration(seconds: 15));
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully'), backgroundColor: Colors.green),
          );
        }
      } else {
        // Add new product
        productData['createdAt'] = FieldValue.serverTimestamp();
        await FirebaseFirestore.instance
            .collection('products')
            .add(productData)
            .timeout(const Duration(seconds: 15));
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully'), backgroundColor: Colors.green),
          );
        }
      }

      widget.onNavigateBack();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving product: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingProduct != null;
    final previewImageUrl = _imageUrlController.text.trim().isNotEmpty 
        ? _imageUrlController.text.trim() 
        : _categoryPlaceholders[_selectedCategory] ?? '';
    
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onNavigateBack,
        ),
        title: Text(
          isEditing ? 'Edit Product' : 'Add New Product',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Preview Section
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: previewImageUrl.isNotEmpty
                      ? Image.network(
                          previewImageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder();
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: Colors.amber,
                              ),
                            );
                          },
                        )
                      : _buildImagePlaceholder(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Image preview (uses category default if no URL provided)',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Image URL (Optional)
              TextFormField(
                controller: _imageUrlController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Image URL (Optional)',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.link, color: Colors.amber),
                  hintText: 'https://example.com/image.jpg',
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  filled: true,
                  fillColor: const Color(0xFF1F1F1F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  helperText: 'Leave empty to use category default image',
                  helperStyle: TextStyle(color: Colors.grey[600]),
                ),
                onChanged: (value) {
                  setState(() {}); // Refresh preview
                },
              ),
              const SizedBox(height: 16),

              // Product Name
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Product Name *',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.shopping_bag, color: Colors.amber),
                  filled: true,
                  fillColor: const Color(0xFF1F1F1F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                style: const TextStyle(color: Colors.white),
                dropdownColor: const Color(0xFF1F1F1F),
                decoration: InputDecoration(
                  labelText: 'Category *',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.category, color: Colors.amber),
                  filled: true,
                  fillColor: const Color(0xFF1F1F1F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Specifications
              TextFormField(
                controller: _specsController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Specifications *',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(Icons.description, color: Colors.amber),
                  ),
                  hintText: 'e.g., 16 Cores, 5.7GHz',
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  filled: true,
                  fillColor: const Color(0xFF1F1F1F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter specifications';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price
              TextFormField(
                controller: _priceController,
                style: const TextStyle(color: Colors.white),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Price (USD) *',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.attach_money, color: Colors.amber),
                  hintText: '0.00',
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  filled: true,
                  fillColor: const Color(0xFF1F1F1F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50914),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEditing ? 'Update Product' : 'Add Product',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFF1F1F1F),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 60, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Text(
            'Image Preview',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
