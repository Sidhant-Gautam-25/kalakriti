import 'package:flutter/material.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

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
  // CATEGORY INFORMATION
  // ============================================================

  Map<String, dynamic> _categoryInformation(String value) {
    switch (value.trim()) {
      case 'Textiles':
        return {
          'image': 'assets/images/textiles.png',
          'icon': Icons.checkroom_outlined,
          'description': 'Explore handwoven fabrics, sarees, shawls and traditional textiles made by skilled artisans.',
          'comparisonTitle': 'Handwoven textiles vs mass-produced fabrics',
          'comparison': 'Handwoven textiles use traditional techniques and often carry regional patterns and artisan knowledge that factory-made fabrics cannot fully reproduce.',
          'benefits': [
            'Supports skilled weaving communities.',
            'Preserves traditional textile techniques.',
            'Unique patterns and craftsmanship.',
            'Made with greater attention to detail.',
          ],
        };

      case 'Pottery':
        return {
          'image': 'assets/images/pottery.png',
          'icon': Icons.emoji_food_beverage_outlined,
          'description': 'Discover terracotta, clay pottery, ceramic vessels and traditional handmade kitchenware.',
          'comparisonTitle': 'Clay pottery vs mass-produced plasticware',
          'comparison': 'Traditional pottery uses natural clay and provides reusable, timeless alternatives for many household purposes.',
          'benefits': [
            'Uses naturally occurring clay.',
            'Supports traditional potters.',
            'Reusable for many household purposes.',
            'Preserves regional pottery traditions.',
          ],
        };

      case 'Bamboo & Cane':
        return {
          'image': 'assets/images/bamboo.png',
          'icon': Icons.shopping_basket_outlined,
          'description': 'Find beautiful baskets, organisers, furniture and everyday products made from bamboo and cane.',
          'comparisonTitle': 'Bamboo & cane vs plastic baskets',
          'comparison': 'Bamboo and cane are renewable natural materials that can provide durable alternatives to many mass-produced plastic storage products.',
          'benefits': [
            'Made from renewable natural materials.',
            'Biodegradable compared with conventional plastic.',
            'Supports rural artisan communities.',
            'Lightweight, durable and naturally beautiful.',
          ],
        };

      case 'Woodcraft':
        return {
          'image': 'assets/images/woodcraft.png',
          'icon': Icons.carpenter_outlined,
          'description': 'Explore hand-carved wooden décor, utensils, toys and traditional wooden products.',
          'comparisonTitle': 'Handcrafted wood vs mass-produced décor',
          'comparison': 'Handcrafted wooden pieces can offer long-lasting products while preserving traditional carving and woodworking skills.',
          'benefits': [
            'Natural material with a timeless appearance.',
            'Supports traditional woodworkers.',
            'Every piece has individual handcrafted character.',
            'Can often be maintained or repaired.',
          ],
        };

      case 'Metalcraft':
        return {
          'image': 'assets/images/metalcraft.png',
          'icon': Icons.hardware_outlined,
          'description': 'Discover brass, copper, bell-metal and other traditional metal crafts made by skilled artisans.',
          'comparisonTitle': 'Traditional metalcraft vs factory-made décor',
          'comparison': 'Artisan metalwork combines durable materials with traditional techniques, giving each piece its own character and cultural value.',
          'benefits': [
            'Durable and long-lasting material.',
            'Traditional metalworking skills are preserved.',
            'Unique handcrafted finish.',
            'Many pieces can be used for generations.',
          ],
        };

      case 'Jewellery':
      case 'Jewelry':
        return {
          'image': 'assets/images/jewellery.png',
          'icon': Icons.diamond_outlined,
          'description': 'Find handcrafted jewellery inspired by India’s diverse regional traditions.',
          'comparisonTitle': 'Artisan jewellery vs mass-produced accessories',
          'comparison': 'Handcrafted jewellery offers distinctive designs and the personal touch of an artisan instead of identical factory-produced accessories.',
          'benefits': [
            'Distinctive handmade designs.',
            'Supports jewellery-making communities.',
            'Traditional techniques remain alive.',
            'Each piece has its own character.',
          ],
        };

      case 'Paintings':
        return {
          'image': 'assets/images/paintings.png',
          'icon': Icons.palette_outlined,
          'description': 'Discover folk, tribal and traditional Indian paintings created by independent artists.',
          'comparisonTitle': 'Traditional paintings vs mass-produced prints',
          'comparison': 'An original handmade painting carries the artist’s individual skill, interpretation and cultural story rather than being a mass-produced reproduction.',
          'benefits': [
            'Supports independent artists.',
            'Preserves traditional art forms.',
            'Every artwork is unique.',
            'Brings cultural stories into modern homes.',
          ],
        };

      case 'Home Décor':
        return {
          'image': 'assets/images/decor.png',
          'icon': Icons.home_outlined,
          'description': 'Bring handmade Indian craftsmanship into your home with unique décor pieces.',
          'comparisonTitle': 'Handmade décor vs mass-produced décor',
          'comparison': 'Handmade décor adds individuality to a home while supporting the people and traditions behind each piece.',
          'benefits': [
            'Adds individuality to your home.',
            'Supports local craftspeople.',
            'Preserves decorative traditions.',
            'Every handmade piece has its own character.',
          ],
        };

      case 'Leather Craft':
        return {
          'image': 'assets/images/leather.png',
          'icon': Icons.work_outline,
          'description': 'Discover handcrafted leather bags, wallets, accessories and traditional leatherwork.',
          'comparisonTitle': 'Handcrafted leather vs mass-produced accessories',
          'comparison': 'Traditional leather craftsmanship combines practical materials with artisan skill and distinctive handmade finishing.',
          'benefits': [
            'Supports traditional leather artisans.',
            'Strong and practical craftsmanship.',
            'Distinctive handmade finishing.',
            'Preserves regional leatherworking skills.',
          ],
        };

      case 'Stone Craft':
        return {
          'image': 'assets/images/stone.png',
          'icon': Icons.landscape_outlined,
          'description': 'Discover carved stone sculptures, decorative pieces and traditional stone craftsmanship.',
          'comparisonTitle': 'Hand-carved stone vs factory-made décor',
          'comparison': 'Stone carving preserves highly skilled techniques and creates individual pieces shaped directly by artisans.',
          'benefits': [
            'Preserves traditional stone carving.',
            'Durable natural material.',
            'Each piece is individually crafted.',
            'Supports specialist artisan communities.',
          ],
        };

      case 'Toys & Dolls':
        return {
          'image': 'assets/images/toys.png',
          'icon': Icons.toys_outlined,
          'description': 'Explore traditional handmade toys and dolls created using regional materials and techniques.',
          'comparisonTitle': 'Handmade toys vs mass-produced toys',
          'comparison': 'Traditional handmade toys reflect regional stories, materials and techniques while giving each piece an individual character.',
          'benefits': [
            'Preserves traditional toy-making.',
            'Supports artisan families.',
            'Distinctive handmade character.',
            'Connects children with cultural traditions.',
          ],
        };

      case 'Baskets & Storage':
        return {
          'image': 'assets/images/baskets.png',
          'icon': Icons.inventory_2_outlined,
          'description': 'Find natural fibre baskets, organisers and storage pieces made using traditional weaving techniques.',
          'comparisonTitle': 'Handwoven storage vs mass-produced storage',
          'comparison': 'Handwoven storage pieces use traditional techniques and natural fibres to create useful objects with individual character.',
          'benefits': [
            'Supports traditional weaving communities.',
            'Uses natural fibre materials.',
            'Useful for everyday storage.',
            'Preserves regional basket-making skills.',
          ],
        };

      default:
        return {
          'image': 'assets/images/pottery.png',
          'icon': Icons.category_outlined,
          'description': 'Discover handmade Indian crafts created by skilled artisan communities.',
          'comparisonTitle': 'Handmade crafts vs mass-produced products',
          'comparison': 'Handmade products carry the skill, time and individual character of the people who create them.',
          'benefits': [
            'Supports artisan communities.',
            'Preserves traditional skills.',
            'Every piece has individual character.',
            'Connects products with cultural traditions.',
          ],
        };
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final info = _categoryInformation(category);

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: dark,
        elevation: 0,

        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),

        title: Text(
          category,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 950) {
              return _buildDesktop(context, info);
            }

            return _buildMobile(context, info);
          },
        ),
      ),
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _buildDesktop(BuildContext context, Map<String, dynamic> info) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 7, child: _buildMainColumn(context, info)),

          const SizedBox(width: 22),

          SizedBox(width: 350, child: _buildInformationCard(info)),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobile(BuildContext context, Map<String, dynamic> info) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainColumn(context, info),

          const SizedBox(height: 22),

          _buildInformationCard(info),
        ],
      ),
    );
  }

  // ============================================================
  // MAIN COLUMN
  // ============================================================

  Widget _buildMainColumn(BuildContext context, Map<String, dynamic> info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --------------------------------------------------------
        // IMAGE
        // --------------------------------------------------------

        _buildHeroImage(info),

        const SizedBox(height: 22),

        // --------------------------------------------------------
        // TITLE
        // --------------------------------------------------------
        Text(
          'Discover $category',
          style: const TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          info['description'] as String,
          style: const TextStyle(fontSize: 15, height: 1.55, color: muted),
        ),

        const SizedBox(height: 22),

        // --------------------------------------------------------
        // CRAFT STATUS
        // --------------------------------------------------------
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(info['icon'] as IconData, color: primary, size: 23),
              ),

              const SizedBox(width: 13),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Authentic artisan craftsmanship',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Explore handmade work created using traditional skills and regional techniques.',
                      style: TextStyle(fontSize: 12, height: 1.4, color: muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // --------------------------------------------------------
        // AVAILABILITY
        // --------------------------------------------------------
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cream,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const Icon(Icons.storefront_outlined, color: primary, size: 28),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Artisan listings',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Products will appear here when artisans publish crafts in this category.',
                      style: TextStyle(fontSize: 12, height: 1.4, color: muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CATEGORY IMAGE
  // ============================================================

  Widget _buildHeroImage(Map<String, dynamic> info) {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        info['image'] as String,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return Center(
            child: Icon(info['icon'] as IconData, color: primary, size: 70),
          );
        },
      ),
    );
  }

  // ============================================================
  // INFORMATION CARD
  // ============================================================

  Widget _buildInformationCard(Map<String, dynamic> info) {
    final benefits = List<String>.from(info['benefits'] as List);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD8D0BD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------
          // HEADER
          // ------------------------------------------------------

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(info['icon'] as IconData, color: primary, size: 23),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why choose this?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'A thoughtful alternative to mainstream products',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ------------------------------------------------------
          // COMPARISON
          // ------------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'A closer look',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  info['comparisonTitle'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),

                const SizedBox(height: 9),

                Text(
                  info['comparison'] as String,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 17),

          // ------------------------------------------------------
          // BENEFITS
          // ------------------------------------------------------
          const Text(
            'Why it can be a better choice',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),

          const SizedBox(height: 12),

          ...benefits.map((benefit) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: primary,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      benefit,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: dark,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
