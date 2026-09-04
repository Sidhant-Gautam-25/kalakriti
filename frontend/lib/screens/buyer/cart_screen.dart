import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
          'My Cart',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 5, 22, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // --------------------------------------------------
              // CART HEADER
              // --------------------------------------------------

              const Text(
                'Your handmade collection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Items you choose to purchase will appear here.',
                style: TextStyle(fontSize: 14, color: muted),
              ),

              const SizedBox(height: 24),

              // --------------------------------------------------
              // EMPTY CART
              // --------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE2DDD2)),
                ),

                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: cream,
                        borderRadius: BorderRadius.circular(25),
                      ),

                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 44,
                        color: primary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Your cart is empty',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'When you find something you love, '
                      'add it to your cart and it will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, height: 1.5, color: muted),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      height: 48,

                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        icon: const Icon(Icons.explore_outlined),

                        label: const Text(
                          'Continue Exploring',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          elevation: 0,

                          padding: const EdgeInsets.symmetric(horizontal: 18),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------
              // WHY SHOP HANDMADE
              // --------------------------------------------------
              const Text(
                'Why shop handmade?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              const SizedBox(height: 14),

              _benefitCard(
                icon: Icons.favorite_outline,
                title: 'Made with care',
                subtitle: 'Every craft carries the effort and creativity of its maker.',
              ),

              const SizedBox(height: 12),

              _benefitCard(
                icon: Icons.people_outline,
                title: 'Support artisans',
                subtitle: 'Your purchase helps artisan communities grow.',
              ),

              const SizedBox(height: 12),

              _benefitCard(
                icon: Icons.auto_awesome_outlined,
                title: 'Unique creations',
                subtitle: 'Discover traditional crafts and one-of-a-kind work.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BENEFIT CARD
  // ------------------------------------------------------------

  Widget _benefitCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),

      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: primary, size: 24),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: muted,
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
