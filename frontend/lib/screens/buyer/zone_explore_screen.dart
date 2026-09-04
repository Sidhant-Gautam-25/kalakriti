import 'package:flutter/material.dart';

import 'category_products_screen.dart';

class ZoneExploreScreen extends StatelessWidget {
  const ZoneExploreScreen({super.key});

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
  // ZONE DATA
  // ============================================================

  static const List<Map<String, dynamic>> zones = [
    {
      'name': 'North India',
      'craft': 'Jewellery',
      'icon': Icons.diamond_outlined,
      'category': 'Jewellery',
    },
    {
      'name': 'Central India',
      'craft': 'Leather Craft',
      'icon': Icons.work_outline,
      'category': 'Leather Craft',
    },
    {
      'name': 'Northeast India',
      'craft': 'Bamboo & Cane',
      'icon': Icons.shopping_basket_outlined,
      'category': 'Bamboo & Cane',
    },
    {
      'name': 'South India',
      'craft': 'Woodcraft',
      'icon': Icons.carpenter_outlined,
      'category': 'Woodcraft',
    },
    {
      'name': 'West India',
      'craft': 'Pottery',
      'icon': Icons.emoji_food_beverage_outlined,
      'category': 'Pottery',
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
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: dark),
        ),

        title: const Text(
          'India Craft Zones',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // HEADER
              // ==================================================

              Center(
                child: Column(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: cream,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.map_outlined,
                        color: primary,
                        size: 30,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'India Craft Zones',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Select a zone below',
                      style: TextStyle(fontSize: 14, color: muted),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // INDIA MAP
              // ==================================================
              _buildIndiaMap(context),

              const SizedBox(height: 28),

              // ==================================================
              // ZONE TITLE
              // ==================================================
              const Text(
                'Explore zones',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Choose a region to discover its signature crafts.',
                style: TextStyle(fontSize: 13, color: muted),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // ZONE BUTTONS
              // ==================================================
              LayoutBuilder(
                builder: (context, constraints) {
                  int columns;

                  if (constraints.maxWidth >= 1100) {
                    columns = 5;
                  } else if (constraints.maxWidth >= 700) {
                    columns = 3;
                  } else {
                    columns = 2;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: zones.length,

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.95,
                    ),

                    itemBuilder: (context, index) {
                      final zone = zones[index];

                      return _buildZoneCard(context, zone);
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
  // INDIA MAP
  // ============================================================

  Widget _buildIndiaMap(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        return Container(
          width: double.infinity,

          padding: const EdgeInsets.all(6),

          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),

          child: Stack(
            children: [
              // --------------------------------------------------
              // MAP IMAGE
              // --------------------------------------------------

              ClipRRect(
                borderRadius: BorderRadius.circular(18),

                child: Image.asset(
                  'assets/images/india_craft_zones_map.png',

                  width: width,

                  fit: BoxFit.contain,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 520,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: cream,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_outlined, size: 55, color: primary),
                          SizedBox(height: 12),
                          Text(
                            'India craft map',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Add india_craft_zones_map.png',
                            style: TextStyle(fontSize: 12, color: muted),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // --------------------------------------------------
              // CLICKABLE NORTH BUTTON
              // --------------------------------------------------
              Positioned(
                right: width * 0.16,
                top: width * 0.09,
                child: _mapButton(zone: zones[0], context: context, width: 145),
              ),

              // --------------------------------------------------
              // CLICKABLE CENTRAL BUTTON
              // --------------------------------------------------
              Positioned(
                left: width * 0.32,
                top: width * 0.43,
                child: _mapButton(zone: zones[1], context: context, width: 145),
              ),

              // --------------------------------------------------
              // CLICKABLE NORTHEAST BUTTON
              // --------------------------------------------------
              Positioned(
                right: width * 0.01,
                top: width * 0.47,
                child: _mapButton(zone: zones[2], context: context, width: 145),
              ),

              // --------------------------------------------------
              // CLICKABLE WEST BUTTON
              // --------------------------------------------------
              Positioned(
                left: 0,
                top: width * 0.51,
                child: _mapButton(zone: zones[4], context: context, width: 135),
              ),

              // --------------------------------------------------
              // CLICKABLE SOUTH BUTTON
              // --------------------------------------------------
              Positioned(
                right: width * 0.25,
                bottom: width * 0.03,
                child: _mapButton(zone: zones[3], context: context, width: 145),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // MAP BUTTON
  // ============================================================

  Widget _mapButton({
    required Map<String, dynamic> zone,
    required BuildContext context,
    required double width,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          _openZone(context, zone['category'] as String);
        },

        borderRadius: BorderRadius.circular(16),

        child: Container(
          width: width,

          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),

          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),

            borderRadius: BorderRadius.circular(16),

            border: Border.all(color: primary, width: 1.2),

            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 4),
                color: Color(0x22000000),
              ),
            ],
          ),

          child: Column(
            children: [
              Icon(zone['icon'] as IconData, color: primary, size: 25),

              const SizedBox(height: 6),

              Text(
                zone['name'] as String,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                zone['craft'] as String,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ZONE CARD
  // ============================================================

  Widget _buildZoneCard(BuildContext context, Map<String, dynamic> zone) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          _openZone(context, zone['category'] as String);
        },

        borderRadius: BorderRadius.circular(18),

        child: Container(
          padding: const EdgeInsets.all(13),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(18),

            border: Border.all(color: border),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                width: 52,
                height: 52,

                decoration: const BoxDecoration(
                  color: cream,
                  shape: BoxShape.circle,
                ),

                child: Icon(zone['icon'] as IconData, color: primary, size: 27),
              ),

              const SizedBox(height: 10),

              Text(
                zone['name'] as String,
                textAlign: TextAlign.center,

                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                zone['craft'] as String,
                textAlign: TextAlign.center,

                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),

              const SizedBox(height: 8),

              const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_forward_ios, size: 13, color: primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // OPEN ZONE
  // ============================================================

  void _openZone(BuildContext context, String category) {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) => CategoryProductsScreen(category: category),
      ),
    );
  }
}
