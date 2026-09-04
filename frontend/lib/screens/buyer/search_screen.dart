import 'package:flutter/material.dart';

import 'search_results.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const Color background = Color(0xFFF8F5EC);
  static const Color primary = Color(0xFF3F704F);
  static const Color dark = Color(0xFF333333);
  static const Color muted = Color(0xFF777777);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final query = _searchController.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(query: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: dark,
        title: const Text(
          'Search',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find your next craft',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Search handmade crafts and artisan creations.',
              style: TextStyle(fontSize: 14, color: muted),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                hintText: 'Search crafts...',
                prefixIcon: const Icon(Icons.search, color: primary),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  color: primary,
                  onPressed: _search,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Popular categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _categoryChip('Textiles'),
                _categoryChip('Pottery'),
                _categoryChip('Woodcraft'),
                _categoryChip('Jewellery'),
                _categoryChip('Decor'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryChip(String title) {
    return ActionChip(
      label: Text(title),
      backgroundColor: Colors.white,
      side: BorderSide.none,
      labelStyle: const TextStyle(color: dark, fontWeight: FontWeight.w500),
      onPressed: () {
        _searchController.text = title;
        _search();
      },
    );
  }
}
