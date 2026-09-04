import 'package:flutter/material.dart';

class CustomizationScreen extends StatefulWidget {
  const CustomizationScreen({super.key});

  @override
  State<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
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
  // CONTROLLERS
  // ============================================================

  final TextEditingController _craftController = TextEditingController();

  final TextEditingController _patternController = TextEditingController();

  final TextEditingController _imageController = TextEditingController();

  final TextEditingController _requestController = TextEditingController();

  final TextEditingController _minPriceController = TextEditingController();

  final TextEditingController _maxPriceController = TextEditingController();

  // ============================================================
  // STATE
  // ============================================================

  String _selectedCraft = 'Textiles';
  String _selectedColor = 'Natural';

  final List<String> _craftTypes = [
    'Textiles',
    'Pottery',
    'Bamboo & Cane',
    'Woodcraft',
    'Metalcraft',
    'Jewellery',
    'Paintings',
    'Home Décor',
    'Leather Craft',
    'Stone Craft',
    'Toys & Dolls',
    'Baskets & Storage',
  ];

  final List<String> _colors = [
    'Natural',
    'Green',
    'Red',
    'Blue',
    'Yellow',
    'White',
    'Black',
    'Brown',
    'Multicolour',
  ];

  @override
  void dispose() {
    _craftController.dispose();
    _patternController.dispose();
    _imageController.dispose();
    _requestController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();

    super.dispose();
  }

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
        foregroundColor: dark,

        title: const Text(
          'Customize a Craft',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntro(),

              const SizedBox(height: 22),

              _buildCraftSection(),

              const SizedBox(height: 18),

              _buildColorSection(),

              const SizedBox(height: 18),

              _buildPatternSection(),

              const SizedBox(height: 18),

              _buildImageSection(),

              const SizedBox(height: 18),

              _buildRequestSection(),

              const SizedBox(height: 18),

              _buildPriceSection(),

              const SizedBox(height: 26),

              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INTRO
  // ============================================================

  Widget _buildIntro() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome_outlined, color: Colors.white, size: 30),

          SizedBox(height: 12),

          Text(
            'Create something made for you',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 7),

          Text(
            'Tell artisans what you are looking for. '
            'You can choose colours, patterns, materials and your budget.',
            style: TextStyle(fontSize: 13, height: 1.45, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CRAFT
  // ============================================================

  Widget _buildCraftSection() {
    return _sectionCard(
      title: 'What would you like?',
      icon: Icons.handyman_outlined,
      child: DropdownButtonFormField<String>(
        initialValue: _selectedCraft,

        decoration: _inputDecoration(
          'Select craft type',
          Icons.category_outlined,
        ),

        items: _craftTypes.map((craft) {
          return DropdownMenuItem<String>(value: craft, child: Text(craft));
        }).toList(),

        onChanged: (value) {
          if (value == null) return;

          setState(() {
            _selectedCraft = value;
          });
        },
      ),
    );
  }

  // ============================================================
  // COLOR
  // ============================================================

  Widget _buildColorSection() {
    return _sectionCard(
      title: 'Preferred colour',
      icon: Icons.palette_outlined,
      child: DropdownButtonFormField<String>(
        initialValue: _selectedColor,

        decoration: _inputDecoration(
          'Choose a colour',
          Icons.color_lens_outlined,
        ),

        items: _colors.map((color) {
          return DropdownMenuItem<String>(value: color, child: Text(color));
        }).toList(),

        onChanged: (value) {
          if (value == null) return;

          setState(() {
            _selectedColor = value;
          });
        },
      ),
    );
  }

  // ============================================================
  // PATTERN
  // ============================================================

  Widget _buildPatternSection() {
    return _sectionCard(
      title: 'Pattern or design',
      icon: Icons.draw_outlined,
      child: TextField(
        controller: _patternController,

        maxLines: 3,

        decoration: _inputDecoration(
          'Describe the pattern, motif or design you want',
          Icons.design_services_outlined,
        ),
      ),
    );
  }

  // ============================================================
  // IMAGE
  // ============================================================

  Widget _buildImageSection() {
    return _sectionCard(
      title: 'Reference picture',
      icon: Icons.image_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Have a picture showing what you want?',
            style: TextStyle(fontSize: 13, color: muted),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: _imageController,

            decoration: _inputDecoration(
              'Paste an image URL or reference',
              Icons.link_outlined,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 18, color: primary),

                SizedBox(width: 8),

                Expanded(
                  child: Text(
                    'You can paste a link to a reference image. '
                    'The artisan can use it as inspiration for your request.',
                    style: TextStyle(fontSize: 12, height: 1.35, color: dark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADDITIONAL REQUEST
  // ============================================================

  Widget _buildRequestSection() {
    return _sectionCard(
      title: 'Additional requests',
      icon: Icons.edit_note_outlined,
      child: TextField(
        controller: _requestController,

        maxLines: 5,

        decoration: _inputDecoration(
          'Tell the artisan anything else they should know',
          Icons.notes_outlined,
        ),
      ),
    );
  }

  // ============================================================
  // PRICE
  // ============================================================

  Widget _buildPriceSection() {
    return _sectionCard(
      title: 'Your price range',
      icon: Icons.currency_rupee_outlined,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _minPriceController,

              keyboardType: TextInputType.number,

              decoration: _inputDecoration('Minimum', Icons.currency_rupee),
            ),
          ),

          const SizedBox(width: 12),

          const Text('to', style: TextStyle(fontSize: 14, color: muted)),

          const SizedBox(width: 12),

          Expanded(
            child: TextField(
              controller: _maxPriceController,

              keyboardType: TextInputType.number,

              decoration: _inputDecoration('Maximum', Icons.currency_rupee),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION CARD
  // ============================================================

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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,

                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(11),
                ),

                child: Icon(icon, color: primary, size: 20),
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: muted),

      prefixIcon: Icon(icon, color: primary, size: 20),

      filled: true,
      fillColor: background,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
    );
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,

      child: ElevatedButton(
        onPressed: _submitRequest,

        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),

        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_outlined, size: 19),

            SizedBox(width: 9),

            Text(
              'Send Customization Request',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SUBMIT LOGIC
  // ============================================================

  void _submitRequest() {
    if (_requestController.text.trim().isEmpty &&
        _patternController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe your pattern or additional request.'),
        ),
      );

      return;
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Customization request sent to matching artisans.'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
