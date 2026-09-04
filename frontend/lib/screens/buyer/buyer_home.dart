import 'package:flutter/material.dart';

import 'explore_screen.dart';
import 'search_screen.dart';
import 'cart_screen.dart';
import 'buyer_profile.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color background = Color(0xFFF8F5EC);
  static const Color primary = Color(0xFF3F704F);
  static const Color cream = Color(0xFFE8E0CF);
  static const Color dark = Color(0xFF333333);
  static const Color muted = Color(0xFF777777);
  static const Color border = Color(0xFFE0DACD);

  // ============================================================
  // STATE
  // ============================================================

  int _selectedIndex = 0;

  // ============================================================
  // CATEGORY DATA
  // ============================================================

  static const List<Map<String, dynamic>> categories = [
    {
      'name': 'Pottery',
      'image': 'assets/images/pottery.png',
      'icon': Icons.emoji_food_beverage_outlined,
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
  ];

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _openExplore() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExploreScreen()),
    );
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BuyerProfileScreen()),
    );
  }

  void _onNavigationTap(int index) {
    // ==========================================================
    // HOME
    // ==========================================================

    if (index == 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return;
    }

    // ==========================================================
    // EXPLORE
    // ==========================================================

    if (index == 1) {
      setState(() {
        _selectedIndex = 1;
      });

      _openExplore();
      return;
    }

    // ==========================================================
    // SEARCH
    // ==========================================================

    if (index == 2) {
      setState(() {
        _selectedIndex = 2;
      });

      _openSearch();
      return;
    }

    // ==========================================================
    // CART
    // ==========================================================

    if (index == 3) {
      setState(() {
        _selectedIndex = 3;
      });

      _openCart();
      return;
    }

    // ==========================================================
    // PROFILE
    // ==========================================================

    if (index == 4) {
      setState(() {
        _selectedIndex = 4;
      });

      _openProfile();
      return;
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: const TextStyle(color: primary, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: const TextStyle(color: muted, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Okay',
                style: TextStyle(color: primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),

                    const SizedBox(height: 20),

                    _buildHero(),

                    const SizedBox(height: 18),

                    _buildSearchBar(),

                    const SizedBox(height: 28),

                    _buildCategoryHeader(),

                    const SizedBox(height: 15),

                    _buildCategoryScroller(),

                    const SizedBox(height: 28),

                    _buildArtisanMessage(),

                    const SizedBox(height: 20),

                    _buildSupportBanner(),
                  ],
                ),
              ),
            ),

            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        // ========================================================
        // LOGO
        // ========================================================
        //
        // No green Container behind the logo.
        // The logo now sits directly on the beige background.
        //

        SizedBox(
          width: 48,
          height: 48,
          child: Image.asset(
            'assets/images/kklogo-removebg-preview.png',
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) {
              return const Icon(Icons.eco_outlined, color: primary, size: 30);
            },
          ),
        ),

        const SizedBox(width: 12),

        // ========================================================
        // WELCOME TEXT
        // ========================================================
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Namaste! 👋', style: TextStyle(fontSize: 13, color: muted)),

              SizedBox(height: 3),

              Text(
                'Discover Indian craftsmanship',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),
            ],
          ),
        ),

        // ========================================================
        // NOTIFICATIONS
        // ========================================================
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: () {
              _showMessage(
                'Notifications',
                'New artisan updates and order notifications will appear here.',
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: border),
              ),
              child: const Icon(
                Icons.notifications_none_outlined,
                color: primary,
                size: 23,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 225),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // ======================================================
          // DECORATIVE CIRCLE 1
          // ======================================================

          Positioned(
            right: -45,
            top: -55,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // ======================================================
          // DECORATIVE CIRCLE 2
          // ======================================================
          Positioned(
            right: 10,
            bottom: -65,
            child: Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .06),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // ======================================================
          // HERO CONTENT
          // ======================================================
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.auto_awesome_outlined,
                  color: Colors.white,
                  size: 27,
                ),
              ),

              const SizedBox(height: 17),

              const Text(
                'Crafted with tradition.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Explore handmade crafts, discover unique stories,\nand support artisan communities.',
                style: TextStyle(
                  color: Color(0xFFDCE9DF),
                  fontSize: 14,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 17),

              ElevatedButton(
                onPressed: _openExplore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Explore Crafts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    SizedBox(width: 8),

                    Icon(Icons.arrow_forward, size: 17),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearchBar() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _openSearch,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: muted, size: 23),

              SizedBox(width: 12),

              Expanded(
                child: Text(
                  'Search crafts, artisans and traditions',
                  style: TextStyle(color: muted, fontSize: 14),
                ),
              ),

              Icon(Icons.tune_outlined, color: primary, size: 21),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY HEADER
  // ============================================================

  Widget _buildCategoryHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore craftsmanship',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              SizedBox(height: 5),

              Text(
                'Discover handmade traditions and unique creations.',
                style: TextStyle(fontSize: 13, color: muted),
              ),
            ],
          ),
        ),

        TextButton(
          onPressed: _openExplore,
          child: const Text(
            'View all',
            style: TextStyle(color: primary, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CATEGORY SCROLLER
  // ============================================================

  Widget _buildCategoryScroller() {
    return SizedBox(
      height: 157,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, _) {
          return const SizedBox(width: 12);
        },
        itemBuilder: (context, index) {
          final category = categories[index];

          return _homeCategoryCard(
            name: category['name'] as String,
            image: category['image'] as String,
            icon: category['icon'] as IconData,
            onTap: _openExplore,
          );
        },
      ),
    );
  }

  // ============================================================
  // HOME CATEGORY CARD
  // ============================================================

  Widget _homeCategoryCard({
    required String name,
    required String image,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          width: 116,
          padding: const EdgeInsets.fromLTRB(9, 9, 9, 11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
              // ==================================================
              // CATEGORY IMAGE
              // ==================================================

              ClipOval(
                child: Image.asset(
                  image,
                  width: 82,
                  height: 82,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) {
                    return Container(
                      width: 82,
                      height: 82,
                      color: cream,
                      child: Icon(icon, color: primary, size: 31),
                    );
                  },
                ),
              ),

              const Spacer(),

              // ==================================================
              // CATEGORY NAME
              // ==================================================
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: dark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ARTISAN MESSAGE
  // ============================================================

  Widget _buildArtisanMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.palette_outlined, color: primary, size: 29),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Beautiful things take time.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Browse craft categories to discover handmade creations from Indian artisans.',
                  style: TextStyle(fontSize: 13, height: 1.45, color: muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUPPORT BANNER
  // ============================================================

  Widget _buildSupportBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 53,
            height: 53,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.handshake_outlined,
              color: primary,
              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Support the hands behind the craft',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: dark,
                    fontSize: 14,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Every purchase helps preserve traditional Indian craftsmanship.',
                  style: TextStyle(color: muted, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: border)),
      ),
      child: SafeArea(
        top: false,
        child: NavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          selectedIndex: _selectedIndex,
          indicatorColor: cream,
          onDestinationSelected: _onNavigationTap,
          destinations: const [
            // ====================================================
            // HOME
            // ====================================================

            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),

            // ====================================================
            // EXPLORE
            // ====================================================
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Explore',
            ),

            // ====================================================
            // SEARCH
            // ====================================================
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: 'Search',
            ),

            // ====================================================
            // CART
            // ====================================================
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined),
              selectedIcon: Icon(Icons.shopping_bag),
              label: 'Cart',
            ),

            // ====================================================
            // PROFILE
            // ====================================================
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
