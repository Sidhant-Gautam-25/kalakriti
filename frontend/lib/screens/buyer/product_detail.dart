import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  static const Color background = Color(0xFFF8F5EC);
  static const Color primary = Color(0xFF3F704F);
  static const Color cream = Color(0xFFE8E0CF);
  static const Color dark = Color(0xFF333333);
  static const Color muted = Color(0xFF777777);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: dark,

        title: const Text(
          'Product',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wishlist will be connected later.'),
                ),
              );
            },
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 5, 22, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // --------------------------------------------------
              // PRODUCT IMAGE PLACEHOLDER
              // --------------------------------------------------

              Container(
                width: double.infinity,
                height: 300,

                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(24),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Container(
                      width: 82,
                      height: 82,

                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.image_outlined,
                        size: 42,
                        color: primary,
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'Product image',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Will be provided by the artisan',
                      style: TextStyle(fontSize: 12, color: muted),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --------------------------------------------------
              // PRODUCT INFORMATION
              // --------------------------------------------------
              const Text(
                'Craft details',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Product name',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Product description will be generated and displayed here once the artisan listing is connected.',
                style: TextStyle(fontSize: 14, height: 1.5, color: muted),
              ),

              const SizedBox(height: 20),

              // --------------------------------------------------
              // PRICE
              // --------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(fontSize: 15, color: muted),
                    ),

                    Text(
                      '₹ —',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --------------------------------------------------
              // ARTISAN
              // --------------------------------------------------
              const Text(
                'About the artisan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),

                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: const Icon(
                        Icons.person_outline,
                        size: 30,
                        color: primary,
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Artisan information',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: dark,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            'The artisan profile and story will appear here.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.35,
                              color: muted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(Icons.arrow_forward_ios, size: 15, color: muted),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------
              // ADD TO CART
              // --------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 54,

                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Cart functionality will be connected to the backend later.',
                        ),
                      ),
                    );
                  },

                  icon: const Icon(Icons.shopping_bag_outlined),

                  label: const Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // BACK TO EXPLORE
              // --------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 50,

                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  style: OutlinedButton.styleFrom(
                    foregroundColor: primary,
                    side: const BorderSide(color: primary),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'Back to Crafts',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
