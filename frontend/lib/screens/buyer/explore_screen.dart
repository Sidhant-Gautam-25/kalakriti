import 'package:flutter/material.dart';

import 'category_products_screen.dart';
import 'customization_screen.dart';
import 'zone_explore_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

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
  // CATEGORY DATA
  // ============================================================

  static const List<Map<String, dynamic>> categories = [
    {
      'name': 'Textiles',
      'image': 'assets/images/textiles.png',
      'icon': Icons.checkroom_outlined,
      'description': 'Handwoven fabrics, sarees & more',
    },
    {
      'name': 'Pottery',
      'image': 'assets/images/pottery.png',
      'icon': Icons.emoji_food_beverage_outlined,
      'description': 'Clay pots, ceramics & terracotta',
    },
    {
      'name': 'Bamboo & Cane',
      'image': 'assets/images/bamboo.png',
      'icon': Icons.shopping_basket_outlined,
      'description': 'Baskets, storage & utility crafts',
    },
    {
      'name': 'Woodcraft',
      'image': 'assets/images/woodcraft.png',
      'icon': Icons.carpenter_outlined,
      'description': 'Carved wood & handmade décor',
    },
    {
      'name': 'Metalcraft',
      'image': 'assets/images/metalcraft.png',
      'icon': Icons.hardware_outlined,
      'description': 'Brass, copper & traditional metalwork',
    },
    {
      'name': 'Jewellery',
      'image': 'assets/images/jewellery.png',
      'icon': Icons.diamond_outlined,
      'description': 'Handcrafted jewellery & accessories',
    },
    {
      'name': 'Paintings',
      'image': 'assets/images/paintings.png',
      'icon': Icons.palette_outlined,
      'description': 'Folk, tribal & traditional art',
    },
    {
      'name': 'Home Décor',
      'image': 'assets/images/decor.png',
      'icon': Icons.home_outlined,
      'description': 'Handmade pieces for your home',
    },
    {
      'name': 'Leather Craft',
      'image': 'assets/images/leather.png',
      'icon': Icons.work_outline,
      'description': 'Handcrafted bags, wallets & accessories',
    },
    {
      'name': 'Stone Craft',
      'image': 'assets/images/stone.png',
      'icon': Icons.landscape_outlined,
      'description': 'Carved stone & decorative pieces',
    },
    {
      'name': 'Toys & Dolls',
      'image': 'assets/images/toys.png',
      'icon': Icons.toys_outlined,
      'description': 'Traditional handmade toys & dolls',
    },
    {
      'name': 'Baskets & Storage',
      'image': 'assets/images/baskets.png',
      'icon': Icons.inventory_2_outlined,
      'description': 'Natural fibre baskets & organisers',
    },
  ];

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        foregroundColor: dark,

        title: const Text(
          'Explore Crafts',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () {
              _showSearchMessage(context);
            },
            icon: const Icon(Icons.search, color: dark),
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // HEADER
              // ==================================================

              const Text(
                'Explore Indian craftsmanship',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Discover authentic handmade products from artisans across India.',
                style: TextStyle(fontSize: 14, height: 1.4, color: muted),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // ZONE CARD
              // ==================================================
              _actionCard(
                icon: Icons.map_outlined,
                title: 'Explore by zone',
                subtitle: 'Discover crafts based on regions of India',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ZoneExploreScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // ==================================================
              // CUSTOMIZATION CARD
              // ==================================================
              _actionCard(
                icon: Icons.auto_awesome_outlined,
                title: 'Customize',
                subtitle: 'Create your own craft request',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CustomizationScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // ==================================================
              // INFO STRIP
              // ==================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.eco_outlined,
                        color: primary,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Text(
                        'Shop handmade. Support artisans. Choose thoughtfully.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                          color: dark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // CATEGORY TITLE
              // ==================================================
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Craft Categories',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),
                  ),

                  Text(
                    '${categories.length} categories',
                    style: const TextStyle(fontSize: 12, color: muted),
                  ),
                ],
              ),

              const SizedBox(height: 13),

              // ==================================================
              // CATEGORY GRID
              // ==================================================
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;

                  int columns;

                  if (width >= 1200) {
                    columns = 4;
                  } else if (width >= 800) {
                    columns = 3;
                  } else if (width >= 520) {
                    columns = 3;
                  } else {
                    columns = 2;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.25,
                    ),

                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return _categoryCard(
                        context: context,
                        name: category['name'] as String,
                        image: category['image'] as String,
                        icon: category['icon'] as IconData,
                        description: category['description'] as String,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ACTION CARD
  // ============================================================

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 76),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: border),
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

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        height: 1.3,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(Icons.arrow_forward_ios, size: 14, color: primary),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY CARD
  // ============================================================

  Widget _categoryCard({
    required BuildContext context,
    required String name,
    required String image,
    required IconData icon,
    required String description,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryProductsScreen(category: name),
            ),
          );
        },
        borderRadius: BorderRadius.circular(17),

        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: border),
          ),
          clipBehavior: Clip.antiAlias,

          child: Column(
            children: [
              // --------------------------------------------------
              // IMAGE
              // --------------------------------------------------

              Expanded(
                flex: 5,
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return Container(
                        color: cream,
                        alignment: Alignment.center,
                        child: Icon(icon, color: primary, size: 36),
                      );
                    },
                  ),
                ),
              ),

              // --------------------------------------------------
              // INFORMATION
              // --------------------------------------------------
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(11, 9, 10, 9),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: cream,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: primary, size: 17),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: dark,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 9.5,
                                height: 1.2,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 4),

                      const Icon(Icons.chevron_right, size: 18, color: primary),
                    ],
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
  // SEARCH
  // ============================================================

  void _showSearchMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Search Crafts',
            style: TextStyle(color: primary, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Use the Search section to find crafts, products and artisans across KalaKriti.',
            style: TextStyle(color: muted, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Okay', style: TextStyle(color: primary)),
            ),
          ],
        );
      },
    );
  }
}
