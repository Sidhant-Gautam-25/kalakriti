import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'my_products.dart';

class ProductReviewScreen extends StatefulWidget {
  final Map<String, dynamic> draftProductData;
  final String catalogDraftToken;
  final File localImageFile;

  const ProductReviewScreen({
    super.key,
    required this.draftProductData,
    required this.catalogDraftToken,
    required this.localImageFile,
  });

  @override
  State<ProductReviewScreen> createState() => _ProductReviewScreenState();
}

class _ProductReviewScreenState extends State<ProductReviewScreen> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _craftController;
  late TextEditingController _materialController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  bool _isLoading = false;
  bool _underpriceWarningDismissed = false;

  @override
  void initState() {
    super.initState();
    final data = widget.draftProductData;
    _nameController = TextEditingController(text: data['productName'] ?? '');
    _categoryController = TextEditingController(text: data['category'] ?? '');
    _craftController = TextEditingController(text: data['craftTechnique'] ?? '');
    
    final materialsList = data['materials'];
    final materialsStr = (materialsList is List) ? materialsList.join(', ') : '';
    _materialController = TextEditingController(text: materialsStr);
    
    _descriptionController = TextEditingController(text: data['description'] ?? '');
    _priceController = TextEditingController(text: (data['sellingPrice'] ?? '').toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _craftController.dispose();
    _materialController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _handlePublish() async {
    final double? sellingPrice = double.tryParse(_priceController.text.trim());
    if (sellingPrice == null || sellingPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid selling price.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.confirmCatalog(
        catalogDraftToken: widget.catalogDraftToken,
        sellingPrice: sellingPrice,
        underpriceWarningDismissed: _underpriceWarningDismissed,
        imageUrls: widget.draftProductData['images'] != null
            ? List<String>.from(widget.draftProductData['images'])
            : [],
      );

      final priceProtection = response['priceProtection'];
      final bool isUnderpriced = priceProtection['isUnderpriced'] ?? false;

      if (mounted) {
        if (isUnderpriced && !_underpriceWarningDismissed) {
          // Show the Fair Price Protection Shield alert!
          _showFairPriceShieldAlert(
            warningMessage: priceProtection['warning'] ?? 'Price is below fair market value.',
            fairPriceGap: priceProtection['fairPriceGap']?.toDouble() ?? 0.0,
            aiMinPrice: priceProtection['aiMinPrice']?.toDouble() ?? 0.0,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product published successfully!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyProductsScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Publishing failed: ${e.toString().replaceAll('Exception:', '')}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showFairPriceShieldAlert({
    required String warningMessage,
    required double fairPriceGap,
    required double aiMinPrice,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F5EC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: const [
              Icon(Icons.shield_outlined, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text(
                'Fair Price Shield',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333)),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                warningMessage,
                style: const TextStyle(fontSize: 16, height: 1.4, color: Color(0xFF333333)),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Evaluated Fair Minimum: ₹${aiMinPrice.round()}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Potential Earning Loss: ₹${fairPriceGap.round()}',
                      style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Adjust Price',
                style: TextStyle(color: Color(0xFF3F704F), fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _underpriceWarningDismissed = true;
                });
                _handlePublish(); // Re-trigger publish with warning dismissed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Publish Anyway'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5EC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF333333),
        title: const Text(
          'Review Listing',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 5, 22, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your listing is ready',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F704F),
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Review the details before publishing your craft.',
                style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),
              const SizedBox(height: 24),
              // ------------------------------------------------
              // PRODUCT IMAGE
              // ------------------------------------------------
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.file(
                  widget.localImageFile,
                  width: double.infinity,
                  height: 230,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 25),
              // ------------------------------------------------
              // PRODUCT DETAILS
              // ------------------------------------------------
              const Text(
                'Product Details',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 14),
              _editFieldCard(
                title: 'Product Name',
                controller: _nameController,
                icon: Icons.sell_outlined,
              ),
              const SizedBox(height: 12),
              _editFieldCard(
                title: 'Craft Type',
                controller: _craftController,
                icon: Icons.palette_outlined,
              ),
              const SizedBox(height: 12),
              _editFieldCard(
                title: 'Material',
                controller: _materialController,
                icon: Icons.category_outlined,
              ),
              const SizedBox(height: 12),
              _editFieldCard(
                title: 'Description',
                controller: _descriptionController,
                icon: Icons.description_outlined,
                multiline: true,
              ),
              const SizedBox(height: 25),
              // ------------------------------------------------
              // PRICE
              // ------------------------------------------------
              const Text(
                'Set Price',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E0CF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.currency_rupee,
                        color: Color(0xFF3F704F),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Selling Price',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF777777),
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Enter Price',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.auto_awesome, color: Color(0xFF3F704F)),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // ------------------------------------------------
              // PUBLISH BUTTONS
              // ------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handlePublish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F704F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Publish Listing',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF3F704F),
                    side: const BorderSide(color: Color(0xFF3F704F)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Edit Listing',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editFieldCard({
    required String title,
    required TextEditingController controller,
    required IconData icon,
    bool multiline = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E0CF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF3F704F), size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF888888),
                  ),
                ),
                TextField(
                  controller: controller,
                  maxLines: multiline ? null : 1,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 4, bottom: 4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
