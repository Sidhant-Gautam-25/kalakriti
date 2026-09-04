import 'package:flutter/material.dart';

import 'customization_requests.dart';
import 'artisan_profile.dart';
import 'add_product.dart';

class ArtisanHomeScreen extends StatefulWidget {
  const ArtisanHomeScreen({super.key});

  @override
  State<ArtisanHomeScreen> createState() => _ArtisanHomeScreenState();
}

class _ArtisanHomeScreenState extends State<ArtisanHomeScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color background = Color(0xFFF8F5EC);
  static const Color primary = Color(0xFF3F704F);
  static const Color cream = Color(0xFFE8E0CF);
  static const Color dark = Color(0xFF333333);
  static const Color muted = Color(0xFF777777);
  static const Color border = Color(0xFFE2DDD2);
  static const Color terracotta = Color(0xFFC2754B);

  // ============================================================
  // STATE
  // ============================================================

  int selectedIndex = 0;

  // ============================================================
  // CRAFT CATEGORIES
  // ============================================================

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Pottery',
      'image': 'assets/images/pottery.png',
      'icon': Icons.local_drink_outlined,
    },
    {
      'name': 'Jewellery',
      'image': 'assets/images/jewelry.png',
      'icon': Icons.diamond_outlined,
    },
    {
      'name': 'Textiles',
      'image': 'assets/images/textiles.png',
      'icon': Icons.checkroom_outlined,
    },
    {
      'name': 'Woodcraft',
      'image': 'assets/images/woodcraft.png',
      'icon': Icons.carpenter_outlined,
    },
    {
      'name': 'Bamboo & Cane',
      'image': 'assets/images/bamboo.png',
      'icon': Icons.shopping_basket_outlined,
    },
    {
      'name': 'Metalcraft',
      'image': 'assets/images/metalcraft.png',
      'icon': Icons.hardware_outlined,
    },
    {
      'name': 'Paintings',
      'image': 'assets/images/painting.png',
      'icon': Icons.palette_outlined,
    },
    {
      'name': 'Leather Craft',
      'image': 'assets/images/leather.png',
      'icon': Icons.work_outline,
    },
    {
      'name': 'Home Décor',
      'image': 'assets/images/decor.png',
      'icon': Icons.home_outlined,
    },
    {
      'name': 'Toys & Dolls',
      'image': 'assets/images/toys.png',
      'icon': Icons.toys_outlined,
    },
    {
      'name': 'Others',
      'image': 'assets/images/others.png',
      'icon': Icons.category_outlined,
    },
  ];

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 66,
        titleSpacing: 16,

        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(3),
                child: Image.asset(
                  'assets/images/kklogo-removebg-preview.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),

            const SizedBox(width: 10),

            const Text(
              'KalaKriti',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: dark, size: 28),
            onPressed: () {
              _showComingSoon('Notifications');
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: _buildBody(),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody() {
    switch (selectedIndex) {
      case 0:
        return _buildDashboard();

      case 1:
        return _buildProducts();

      case 2:
        return _buildOrders();

      default:
        return _buildDashboard();
    }
  }

  // ============================================================
  // DASHBOARD
  // ============================================================

  Widget _buildDashboard() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(26, 4, 26, 35),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================================
            // WELCOME
            // ==================================================

            const Text(
              'Welcome, Artisan!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Manage your crafts and connect with buyers.',
              style: TextStyle(fontSize: 16, color: muted),
            ),

            const SizedBox(height: 22),

            // ==================================================
            // CRAFT CATEGORIES
            // ==================================================
            _buildCraftCategories(),

            const SizedBox(height: 28),

            // ==================================================
            // ADD NEW PRODUCT
            // ==================================================
            _buildAddProductCard(),

            const SizedBox(height: 32),

            // ==================================================
            // OVERVIEW
            // ==================================================
            const Text(
              'Your Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // STATISTICS
            // ==================================================
            LayoutBuilder(
              builder: (context, constraints) {
                final bool wide = constraints.maxWidth > 800;

                if (wide) {
                  return Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          icon: Icons.inventory_2_outlined,
                          title: 'Products',
                          value: '0',
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: _statCard(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Orders',
                          value: '0',
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: _statCard(
                          icon: Icons.favorite_border,
                          title: 'Favorites',
                          value: '0',
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: _statCard(
                          icon: Icons.star_border,
                          title: 'Rating',
                          value: '—',
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            icon: Icons.inventory_2_outlined,
                            title: 'Products',
                            value: '0',
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _statCard(
                            icon: Icons.shopping_bag_outlined,
                            title: 'Orders',
                            value: '0',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            icon: Icons.favorite_border,
                            title: 'Favorites',
                            value: '0',
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _statCard(
                            icon: Icons.star_border,
                            title: 'Rating',
                            value: '—',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // ==================================================
            // QUICK ACTIONS
            // ==================================================
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // CUSTOMIZATION REQUESTS
            // ==================================================
            _actionCard(
              icon: Icons.auto_fix_high_outlined,
              title: 'Customization Requests',
              description: 'See requests matching your crafts from buyers.',
              badge: 'Requests',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomizationRequestsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ==================================================
            // MANAGE PRODUCTS
            // ==================================================
            _actionCard(
              icon: Icons.inventory_2_outlined,
              title: 'Manage Products',
              description: 'View and manage your listed handmade crafts.',
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
            ),

            const SizedBox(height: 12),

            // ==================================================
            // VIEW ORDERS
            // ==================================================
            _actionCard(
              icon: Icons.shopping_bag_outlined,
              title: 'View Orders',
              description: 'Check your recent buyer orders.',
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
            ),

            const SizedBox(height: 12),

            // ==================================================
            // EDIT PROFILE
            // ==================================================
            _actionCard(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              description: 'Update your artisan information.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArtisanProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CRAFT CATEGORIES
  // ============================================================

  Widget _buildCraftCategories() {
    return SizedBox(
      height: 112,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),

        // FIX:
        // This was incorrectly written as craftCategories.
        // The actual variable declared above is categories.
        itemCount: categories.length,

        separatorBuilder: (context, index) {
          return const SizedBox(width: 17);
        },

        itemBuilder: (context, index) {
          final category = categories[index];

          return GestureDetector(
            onTap: () {
              _showComingSoon(category['name'] as String);
            },

            child: SizedBox(
              width: 70,

              child: Column(
                children: [
                  // ==============================================
                  // IMAGE CIRCLE
                  // ==============================================

                  Container(
                    width: 68,
                    height: 68,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cream,

                      border: Border.all(
                        color: const Color(0xFFE0D8C9),
                        width: 1,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: ClipOval(
                      child: Image.asset(
                        category['image'] as String,

                        width: 68,
                        height: 68,

                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: cream,

                            child: Icon(
                              category['icon'] as IconData,
                              color: primary,
                              size: 27,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 7),

                  // ==============================================
                  // NAME
                  // ==============================================
                  Text(
                    category['name'] as String,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: dark,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // ADD PRODUCT CARD
  // ============================================================

  Widget _buildAddProductCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(22),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddProductScreen()),
        );
      },

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 20),

        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(22),
        ),

        child: Row(
          children: [
            // ==================================================
            // PLUS
            // ==================================================

            Container(
              width: 64,
              height: 64,

              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.20),
                shape: BoxShape.circle,
              ),

              child: const Icon(Icons.add, color: Colors.white, size: 36),
            ),

            const SizedBox(width: 17),

            // ==================================================
            // TEXT
            // ==================================================
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'Add New Product',

                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    'List a handmade craft for buyers.',

                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // ==================================================
            // ARROW
            // ==================================================
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 19),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      height: 162,

      padding: const EdgeInsets.all(19),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: border),
      ),

      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ================================================
              // ICON
              // ================================================

              Container(
                width: 46,
                height: 46,

                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(13),
                ),

                child: Icon(icon, color: primary, size: 24),
              ),

              const SizedBox(height: 14),

              // ================================================
              // VALUE
              // ================================================
              Text(
                value,

                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              const SizedBox(height: 3),

              Text(title, style: const TextStyle(fontSize: 14, color: muted)),
            ],
          ),

          // ================================================
          // DECORATIVE LEAF
          // ================================================
          Positioned(
            right: 3,
            bottom: 0,

            child: Icon(
              Icons.eco_outlined,
              size: 39,
              color: cream.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTION CARD
  // ============================================================

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    String? badge,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),

      onTap: onTap,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(17),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border),
        ),

        child: Row(
          children: [
            // ==================================================
            // ICON
            // ==================================================

            Container(
              width: 55,
              height: 55,

              decoration: BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Icon(icon, color: primary, size: 27),
            ),

            const SizedBox(width: 16),

            // ==================================================
            // TEXT
            // ==================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    description,

                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(fontSize: 13, color: muted),
                  ),
                ],
              ),
            ),

            // ==================================================
            // BADGE
            // ==================================================
            if (badge != null) ...[
              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: terracotta.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  badge,

                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: terracotta,
                  ),
                ),
              ),
            ],

            const SizedBox(width: 8),

            // ==================================================
            // ARROW
            // ==================================================
            const Icon(Icons.arrow_forward_ios, size: 15, color: muted),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCTS
  // ============================================================

  Widget _buildProducts() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                width: 105,
                height: 105,

                decoration: const BoxDecoration(
                  color: cream,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 50,
                  color: primary,
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Your Products',

                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'You have not added any products yet.',

                textAlign: TextAlign.center,

                style: TextStyle(fontSize: 15, color: muted),
              ),

              const SizedBox(height: 25),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddProductScreen(),
                    ),
                  );
                },

                icon: const Icon(Icons.add),

                label: const Text('Add Product'),

                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  elevation: 0,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ORDERS
  // ============================================================

  Widget _buildOrders() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                width: 105,
                height: 105,

                decoration: const BoxDecoration(
                  color: cream,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 50,
                  color: primary,
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Your Orders',

                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'No orders yet.',

                textAlign: TextAlign.center,

                style: TextStyle(fontSize: 15, color: muted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: selectedIndex,

      type: BottomNavigationBarType.fixed,

      backgroundColor: Colors.white,

      elevation: 8,

      selectedItemColor: primary,

      unselectedItemColor: muted,

      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),

      unselectedLabelStyle: const TextStyle(fontSize: 12),

      onTap: (index) {
        // ======================================================
        // PROFILE
        // ======================================================

        if (index == 3) {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) => const ArtisanProfileScreen(),
            ),
          );

          return;
        }

        // ======================================================
        // OTHER TABS
        // ======================================================

        setState(() {
          selectedIndex = index;
        });
      },

      items: const [
        // ------------------------------------------------------
        // HOME
        // ------------------------------------------------------

        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),

        // ------------------------------------------------------
        // PRODUCTS
        // ------------------------------------------------------
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          activeIcon: Icon(Icons.inventory_2),
          label: 'Products',
        ),

        // ------------------------------------------------------
        // ORDERS
        // ------------------------------------------------------
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          activeIcon: Icon(Icons.shopping_bag),
          label: 'Orders',
        ),

        // ------------------------------------------------------
        // PROFILE
        // ------------------------------------------------------
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  // ============================================================
  // COMING SOON
  // ============================================================

  void _showComingSoon(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title will be available soon.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
