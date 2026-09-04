import 'package:flutter/material.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
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
  // BUYER INFORMATION
  // ============================================================

  String buyerName = 'Buyer';
  String language = 'English';
  String location = 'India';

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: dark,

        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool desktop = constraints.maxWidth >= 850;

            if (desktop) {
              return _buildDesktopLayout();
            }

            return _buildMobileLayout();
          },
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE LAYOUT
  // ============================================================

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),

          const SizedBox(height: 25),

          _buildPersonalInformation(),

          const SizedBox(height: 18),

          _buildPurchaseHistory(),

          const SizedBox(height: 25),

          _buildEditButton(),
        ],
      ),
    );
  }

  // ============================================================
  // DESKTOP LAYOUT
  // ============================================================

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(60, 20, 60, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),

              const SizedBox(height: 30),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildPersonalInformation()),

                  const SizedBox(width: 20),

                  Expanded(child: _buildPurchaseHistory()),
                ],
              ),

              const SizedBox(height: 25),

              _buildEditButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // ------------------------------------------------------
          // PROFILE AVATAR
          // ------------------------------------------------------

          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, size: 42, color: primary),
          ),

          const SizedBox(width: 18),

          // ------------------------------------------------------
          // NAME
          // ------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),

                const SizedBox(height: 4),

                Text(
                  buyerName,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Discover and support Indian craftsmanship.',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PERSONAL INFORMATION
  // ============================================================

  Widget _buildPersonalInformation() {
    return _profileSectionCard(
      title: 'Personal Information',
      icon: Icons.person_outline,
      child: Column(
        children: [
          _profileInfoRow(
            icon: Icons.person_outline,
            title: 'Name',
            value: buyerName,
          ),

          const Divider(height: 25, color: border),

          _profileInfoRow(
            icon: Icons.language_outlined,
            title: 'Preferred Language',
            value: language,
          ),

          const Divider(height: 25, color: border),

          _profileInfoRow(
            icon: Icons.location_on_outlined,
            title: 'Location',
            value: location,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PURCHASE HISTORY
  // ============================================================

  Widget _buildPurchaseHistory() {
    return _profileSectionCard(
      title: 'Purchase History',
      icon: Icons.shopping_bag_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------
          // SUMMARY
          // ------------------------------------------------------

          Row(
            children: [
              Expanded(
                child: _purchaseStat(
                  icon: Icons.shopping_bag_outlined,
                  value: '0',
                  label: 'Purchases',
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _purchaseStat(
                  icon: Icons.favorite_border,
                  value: '0',
                  label: 'Favorites',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ------------------------------------------------------
          // EMPTY STATE
          // ------------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border),
            ),
            child: Column(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                    color: cream,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: primary,
                    size: 27,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'No purchases yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Your purchases from Indian artisans will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, height: 1.4, color: muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE SECTION CARD
  // ============================================================

  Widget _profileSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------
          // SECTION TITLE
          // ------------------------------------------------------

          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: primary, size: 23),
              ),

              const SizedBox(width: 12),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE INFORMATION ROW
  // ============================================================

  Widget _profileInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primary, size: 21),
        ),

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
                  fontSize: 15,
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

  // ============================================================
  // PURCHASE STAT
  // ============================================================

  Widget _purchaseStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Icon(icon, color: primary, size: 23),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),

          const SizedBox(height: 2),

          Text(label, style: const TextStyle(fontSize: 12, color: muted)),
        ],
      ),
    );
  }

  // ============================================================
  // EDIT BUTTON
  // ============================================================

  Widget _buildEditButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _showEditProfileDialog,
        icon: const Icon(Icons.edit_outlined, size: 20),
        label: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EDIT PROFILE DIALOG
  // ============================================================

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: buyerName);

    final locationController = TextEditingController(text: location);

    String selectedLanguage = language;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: background,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              title: const Text(
                'Edit Profile',
                style: TextStyle(color: primary, fontWeight: FontWeight.bold),
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ------------------------------------------------
                    // NAME
                    // ------------------------------------------------

                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: primary,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(color: border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(color: border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(
                            color: primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ------------------------------------------------
                    // LANGUAGE
                    // ------------------------------------------------
                    DropdownButtonFormField<String>(
                      initialValue: selectedLanguage,
                      decoration: InputDecoration(
                        labelText: 'Preferred Language',
                        prefixIcon: const Icon(
                          Icons.language_outlined,
                          color: primary,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(color: border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(color: border),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'English',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(value: 'Hindi', child: Text('Hindi')),
                        DropdownMenuItem(value: 'Tamil', child: Text('Tamil')),
                        DropdownMenuItem(
                          value: 'Telugu',
                          child: Text('Telugu'),
                        ),
                        DropdownMenuItem(
                          value: 'Bengali',
                          child: Text('Bengali'),
                        ),
                        DropdownMenuItem(
                          value: 'Marathi',
                          child: Text('Marathi'),
                        ),
                        DropdownMenuItem(
                          value: 'Kannada',
                          child: Text('Kannada'),
                        ),
                        DropdownMenuItem(
                          value: 'Malayalam',
                          child: Text('Malayalam'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedLanguage = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 15),

                    // ------------------------------------------------
                    // LOCATION
                    // ------------------------------------------------
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        prefixIcon: const Icon(
                          Icons.location_on_outlined,
                          color: primary,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(color: border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(color: border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(
                            color: primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel', style: TextStyle(color: muted)),
                ),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      buyerName = nameController.text.trim().isEmpty
                          ? 'Buyer'
                          : nameController.text.trim();

                      language = selectedLanguage;

                      location = locationController.text.trim().isEmpty
                          ? 'India'
                          : locationController.text.trim();
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully.'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
