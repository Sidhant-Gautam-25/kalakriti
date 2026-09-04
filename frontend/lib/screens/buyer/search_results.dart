import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({super.key, this.query = ''});

  static const Color background = Color(0xFFF8F5EC);
  static const Color primary = Color(0xFF3F704F);
  static const Color cream = Color(0xFFE8E0CF);
  static const Color dark = Color(0xFF333333);
  static const Color muted = Color(0xFF777777);

  @override
  Widget build(BuildContext context) {
    final String title = query.trim().isEmpty
        ? 'Search Results'
        : 'Results for "$query"';

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: dark,
        title: const Text(
          'Search Results',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 5, 22, 25),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Products from artisans will appear here.',
                style: TextStyle(fontSize: 14, color: muted),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _filterButton(
                      icon: Icons.tune_outlined,
                      label: 'Filter',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _filterButton(
                      icon: Icons.sort_outlined,
                      label: 'Sort',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,

                          decoration: BoxDecoration(
                            color: cream,
                            borderRadius: BorderRadius.circular(30),
                          ),

                          child: const Icon(
                            Icons.search_off_outlined,
                            size: 48,
                            color: primary,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'No crafts available yet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: dark,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),

                          child: Text(
                            'Once artisans publish their crafts, '
                            'matching products will appear here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: muted,
                            ),
                          ),
                        ),
                      ],
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

  Widget _filterButton({required IconData icon, required String label}) {
    return Container(
      height: 46,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE0DACD)),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 19, color: primary),

          const SizedBox(width: 8),

          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: dark,
            ),
          ),
        ],
      ),
    );
  }
}
