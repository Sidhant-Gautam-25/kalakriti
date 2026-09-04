import 'package:flutter/material.dart';

class ArtisanDetailScreen extends StatelessWidget {
  const ArtisanDetailScreen({super.key});

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
          'Artisan',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 5, 22, 30),

        child: Column(
          children: [
            // --------------------------------------------------
            // ARTISAN HEADER
            // --------------------------------------------------

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),

              child: Column(
                children: [
                  Container(
                    width: 105,
                    height: 105,

                    decoration: BoxDecoration(
                      color: cream,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.person_outline,
                      size: 55,
                      color: primary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Artisan name',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Craft / Art Form',
                    style: TextStyle(fontSize: 14, color: muted),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: cream,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: const Text(
                      'Artisan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // STORY
            // --------------------------------------------------
            _sectionCard(
              title: 'About the artisan',
              icon: Icons.auto_stories_outlined,
              child: const Text(
                'The artisan story, background and journey '
                'will appear here once the artisan profile '
                'is connected to the backend.',
                style: TextStyle(fontSize: 14, height: 1.55, color: muted),
              ),
            ),

            const SizedBox(height: 16),

            // --------------------------------------------------
            // CRAFT INFORMATION
            // --------------------------------------------------
            _sectionCard(
              title: 'Craft & tradition',
              icon: Icons.palette_outlined,
              child: Column(
                children: [
                  _infoRow(
                    icon: Icons.category_outlined,
                    title: 'Craft',
                    value: 'Not available yet',
                  ),

                  const Divider(height: 25),

                  _infoRow(
                    icon: Icons.location_on_outlined,
                    title: 'Location',
                    value: 'Not available yet',
                  ),

                  const Divider(height: 25),

                  _infoRow(
                    icon: Icons.translate_outlined,
                    title: 'Languages',
                    value: 'Not available yet',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --------------------------------------------------
            // PRODUCTS
            // --------------------------------------------------
            _sectionCard(
              title: 'Crafts by this artisan',
              icon: Icons.shopping_bag_outlined,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),

                child: Column(
                  children: [
                    Container(
                      width: 65,
                      height: 65,

                      decoration: BoxDecoration(
                        color: cream,
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: const Icon(
                        Icons.image_outlined,
                        size: 32,
                        color: primary,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'No crafts available yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Published crafts will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: muted),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // FOLLOW / CONTACT
            // --------------------------------------------------
            SizedBox(
              width: double.infinity,
              height: 52,

              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This feature will be connected later.'),
                    ),
                  );
                },

                icon: const Icon(Icons.favorite_border),

                label: const Text(
                  'Follow Artisan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),

                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,

                  side: const BorderSide(color: primary),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SECTION CARD
  // ------------------------------------------------------------

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(icon, color: primary, size: 22),
              ),

              const SizedBox(width: 12),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // INFO ROW
  // ------------------------------------------------------------

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 22, color: primary),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: muted)),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: dark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
