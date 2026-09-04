import 'package:flutter/material.dart';

class ArtisanProfileScreen extends StatefulWidget {
  const ArtisanProfileScreen({super.key});

  @override
  State<ArtisanProfileScreen> createState() => _ArtisanProfileScreenState();
}

class _ArtisanProfileScreenState extends State<ArtisanProfileScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color background = Color(0xFFF8F5EC);
  static const Color primary = Color(0xFF3F704F);
  static const Color cream = Color(0xFFE8E0CF);
  static const Color dark = Color(0xFF333333);
  static const Color muted = Color(0xFF777777);
  static const Color border = Color(0xFFE2DDD2);

  // ============================================================
  // PROFILE DATA
  // ============================================================

  String? artisanName;
  String? selectedCraft;
  String? selectedState;
  String? selectedCity;

  final List<String> selectedLanguages = [];

  // ============================================================
  // STATES + CITIES
  // ============================================================

  final Map<String, List<String>> stateCities = {
    'Andhra Pradesh': [
      'Visakhapatnam',
      'Vijayawada',
      'Guntur',
      'Tirupati',
      'Nellore',
      'Kurnool',
    ],

    'Arunachal Pradesh': ['Itanagar', 'Naharlagun', 'Pasighat', 'Tawang'],

    'Assam': ['Guwahati', 'Dibrugarh', 'Silchar', 'Jorhat', 'Tezpur'],

    'Bihar': ['Patna', 'Gaya', 'Muzaffarpur', 'Bhagalpur', 'Darbhanga'],

    'Chhattisgarh': ['Raipur', 'Bhilai', 'Bilaspur', 'Korba', 'Durg'],

    'Goa': ['Panaji', 'Margao', 'Vasco da Gama', 'Mapusa'],

    'Gujarat': [
      'Ahmedabad',
      'Surat',
      'Vadodara',
      'Rajkot',
      'Bhavnagar',
      'Jamnagar',
    ],

    'Haryana': [
      'Gurugram',
      'Faridabad',
      'Panipat',
      'Ambala',
      'Hisar',
      'Karnal',
    ],

    'Himachal Pradesh': ['Shimla', 'Manali', 'Dharamshala', 'Solan', 'Mandi'],

    'Jharkhand': ['Ranchi', 'Jamshedpur', 'Dhanbad', 'Bokaro', 'Deoghar'],

    'Karnataka': [
      'Bengaluru',
      'Mysuru',
      'Mangaluru',
      'Hubballi',
      'Belagavi',
      'Shivamogga',
    ],

    'Kerala': [
      'Thiruvananthapuram',
      'Kochi',
      'Kozhikode',
      'Thrissur',
      'Kollam',
      'Kannur',
    ],

    'Madhya Pradesh': [
      'Bhopal',
      'Indore',
      'Gwalior',
      'Jabalpur',
      'Ujjain',
      'Sagar',
    ],

    'Maharashtra': [
      'Mumbai',
      'Pune',
      'Nagpur',
      'Nashik',
      'Chhatrapati Sambhajinagar',
      'Kolhapur',
    ],

    'Manipur': ['Imphal', 'Thoubal', 'Bishnupur', 'Churachandpur'],

    'Meghalaya': ['Shillong', 'Tura', 'Jowai', 'Nongpoh'],

    'Mizoram': ['Aizawl', 'Lunglei', 'Champhai', 'Kolasib'],

    'Nagaland': ['Kohima', 'Dimapur', 'Mokokchung', 'Tuensang'],

    'Odisha': [
      'Bhubaneswar',
      'Cuttack',
      'Rourkela',
      'Puri',
      'Sambalpur',
      'Berhampur',
    ],

    'Punjab': [
      'Amritsar',
      'Ludhiana',
      'Jalandhar',
      'Patiala',
      'Bathinda',
      'Mohali',
    ],

    'Rajasthan': ['Jaipur', 'Jodhpur', 'Udaipur', 'Kota', 'Ajmer', 'Bikaner'],

    'Sikkim': ['Gangtok', 'Namchi', 'Gyalshing', 'Mangan'],

    'Tamil Nadu': [
      'Chennai',
      'Coimbatore',
      'Madurai',
      'Tiruchirappalli',
      'Salem',
      'Tiruppur',
    ],

    'Telangana': [
      'Hyderabad',
      'Warangal',
      'Nizamabad',
      'Karimnagar',
      'Khammam',
    ],

    'Tripura': ['Agartala', 'Udaipur', 'Dharmanagar', 'Kailashahar'],

    'Uttar Pradesh': [
      'Lucknow',
      'Kanpur',
      'Agra',
      'Varanasi',
      'Prayagraj',
      'Noida',
      'Meerut',
    ],

    'Uttarakhand': [
      'Dehradun',
      'Haridwar',
      'Rishikesh',
      'Nainital',
      'Haldwani',
    ],

    'West Bengal': [
      'Kolkata',
      'Howrah',
      'Siliguri',
      'Durgapur',
      'Asansol',
      'Darjeeling',
    ],
  };

  // ============================================================
  // LANGUAGES
  // ============================================================

  final List<String> availableLanguages = [
    'English',
    'Hindi',
    'Bengali',
    'Marathi',
    'Tamil',
    'Telugu',
    'Gujarati',
    'Punjabi',
    'Kannada',
    'Malayalam',
    'Odia',
    'Assamese',
    'Urdu',
    'Sanskrit',
    'Konkani',
    'Nepali',
    'Sindhi',
    'Kashmiri',
    'Maithili',
    'Dogri',
    'Manipuri',
    'Bodo',
    'Santali',
  ];

  // ============================================================
  // CRAFTS
  // ============================================================

  final List<String> crafts = [
    'Pottery',
    'Textiles',
    'Woodwork',
    'Jewellery',
    'Painting',
    'Embroidery',
    'Basketry',
    'Metalwork',
    'Leatherwork',
    'Stonework',
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
        foregroundColor: dark,

        title: const Text(
          'Profile',

          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================================
            // PROFILE HEADER
            // ==================================================

            Center(
              child: Column(
                children: [
                  Container(
                    width: 124,
                    height: 124,

                    decoration: BoxDecoration(
                      color: cream,
                      shape: BoxShape.circle,

                      border: Border.all(color: primary, width: 2),
                    ),

                    child: const Icon(
                      Icons.person_outline,
                      size: 65,
                      color: primary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Your Artisan Profile',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Tell buyers about your craft and story.',

                    textAlign: TextAlign.center,

                    style: TextStyle(fontSize: 16, color: muted),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ==================================================
            // CRAFT INFORMATION
            // ==================================================
            const Text(
              'Craft Information',

              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),

            const SizedBox(height: 16),

            _profileOption(
              icon: Icons.person_outline,
              title: 'Name',
              value: artisanName ?? 'Not added yet',
              onTap: _showNameDialog,
            ),

            const SizedBox(height: 14),

            _profileOption(
              icon: Icons.palette_outlined,
              title: 'Craft / Art Form',
              value: selectedCraft ?? 'Not added yet',
              onTap: _showCraftDialog,
            ),

            const SizedBox(height: 14),

            _profileOption(
              icon: Icons.location_on_outlined,
              title: 'Location',

              value: selectedState != null && selectedCity != null
                  ? '$selectedCity, $selectedState'
                  : 'Not added yet',

              onTap: _showLocationDialog,
            ),

            const SizedBox(height: 14),

            _profileOption(
              icon: Icons.translate,
              title: 'Languages',

              value: selectedLanguages.isEmpty
                  ? 'Not added yet'
                  : selectedLanguages.join(', '),

              onTap: _showLanguagesDialog,
            ),

            const SizedBox(height: 34),

            // ==================================================
            // ACCOUNT
            // ==================================================
            const Text(
              'Account',

              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),

            const SizedBox(height: 16),

            _accountOption(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () {
                _showComingSoon('Change Password');
              },
            ),

            const SizedBox(height: 12),

            _accountOption(
              icon: Icons.notifications_none,
              title: 'Notifications',
              onTap: () {
                _showComingSoon('Notifications');
              },
            ),

            const SizedBox(height: 12),

            _accountOption(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                _showComingSoon('Help & Support');
              },
            ),

            const SizedBox(height: 12),

            _accountOption(
              icon: Icons.logout,
              title: 'Log Out',
              color: Colors.redAccent,
              onTap: _showLogoutDialog,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE OPTION
  // ============================================================

  Widget _profileOption({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),

      onTap: onTap,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),
        ),

        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,

              decoration: BoxDecoration(
                color: cream,

                borderRadius: BorderRadius.circular(15),
              ),

              child: Icon(icon, color: primary, size: 29),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(fontSize: 14, color: muted),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    value,

                    maxLines: 3,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: dark,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            const Icon(Icons.arrow_forward_ios, size: 16, color: muted),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACCOUNT OPTION
  // ============================================================

  Widget _accountOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = primary,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),

      onTap: onTap,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(color: border),
        ),

        child: Row(
          children: [
            Icon(icon, color: color, size: 25),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,

                  color: color == Colors.redAccent ? Colors.redAccent : dark,
                ),
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 15, color: muted),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // NAME DIALOG
  // ============================================================

  void _showNameDialog() {
    final controller = TextEditingController(text: artisanName ?? '');

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: background,

          title: const Text(
            'Your Name',

            style: TextStyle(fontWeight: FontWeight.bold, color: dark),
          ),

          content: TextField(
            controller: controller,
            autofocus: true,

            decoration: InputDecoration(
              hintText: 'Enter your name',

              filled: true,
              fillColor: Colors.white,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),

                borderSide: BorderSide.none,
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text('Cancel', style: TextStyle(color: primary)),
            ),

            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();

                if (name.isNotEmpty) {
                  setState(() {
                    artisanName = name;
                  });
                }

                Navigator.pop(dialogContext);
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
  }

  // ============================================================
  // CRAFT DIALOG
  // ============================================================

  void _showCraftDialog() {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: background,

          title: const Text(
            'Choose your craft',

            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),

          content: SizedBox(
            width: double.maxFinite,

            height: MediaQuery.of(dialogContext).size.height * 0.55,

            child: ListView.separated(
              itemCount: crafts.length,

              separatorBuilder: (_, _) => const SizedBox(height: 5),

              itemBuilder: (_, index) {
                final craft = crafts[index];

                final selected = selectedCraft == craft;

                return InkWell(
                  borderRadius: BorderRadius.circular(14),

                  onTap: () {
                    setState(() {
                      selectedCraft = craft;
                    });

                    Navigator.pop(dialogContext);
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFF0F6F1)
                          : Colors.transparent,

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,

                          decoration: BoxDecoration(
                            color: cream,

                            borderRadius: BorderRadius.circular(14),
                          ),

                          child: const Icon(
                            Icons.palette_outlined,
                            color: primary,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Text(
                            craft,

                            style: TextStyle(
                              fontSize: 16,

                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,

                              color: dark,
                            ),
                          ),
                        ),

                        if (selected)
                          const Icon(Icons.check_circle, color: primary),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text('Cancel', style: TextStyle(color: primary)),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // LOCATION DIALOG
  // ============================================================

  void _showLocationDialog() {
    String? tempState = selectedState;

    String? tempCity = selectedCity;

    showDialog(
      context: context,

      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            final cities = tempState == null
                ? <String>[]
                : stateCities[tempState!] ?? <String>[];

            return AlertDialog(
              backgroundColor: background,

              title: const Text(
                'Your Location',

                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    // STATE
                    DropdownButtonFormField<String>(
                      initialValue: tempState,

                      isExpanded: true,

                      decoration: InputDecoration(
                        labelText: 'State',

                        filled: true,
                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide.none,
                        ),
                      ),

                      items: stateCities.keys.map((state) {
                        return DropdownMenuItem<String>(
                          value: state,

                          child: Text(state, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),

                      onChanged: (value) {
                        dialogSetState(() {
                          tempState = value;

                          tempCity = null;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // CITY
                    DropdownButtonFormField<String>(
                      initialValue: cities.contains(tempCity) ? tempCity : null,

                      isExpanded: true,

                      decoration: InputDecoration(
                        labelText: tempState == null
                            ? 'Select state first'
                            : 'City',

                        filled: true,
                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide.none,
                        ),
                      ),

                      items: cities.map((city) {
                        return DropdownMenuItem<String>(
                          value: city,

                          child: Text(city, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),

                      onChanged: tempState == null
                          ? null
                          : (value) {
                              dialogSetState(() {
                                tempCity = value;
                              });
                            },
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },

                  child: const Text('Cancel', style: TextStyle(color: primary)),
                ),

                ElevatedButton(
                  onPressed: tempState != null && tempCity != null
                      ? () {
                          setState(() {
                            selectedState = tempState;

                            selectedCity = tempCity;
                          });

                          Navigator.pop(dialogContext);
                        }
                      : null,

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

  // ============================================================
  // LANGUAGES DIALOG
  // ============================================================

  void _showLanguagesDialog() {
    final tempLanguages = List<String>.from(selectedLanguages);

    showDialog(
      context: context,

      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              backgroundColor: background,

              title: const Text(
                'Choose your languages',

                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              content: SizedBox(
                width: double.maxFinite,

                height: MediaQuery.of(dialogContext).size.height * 0.60,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Select all languages you can use with buyers.',

                      style: TextStyle(fontSize: 13, color: muted),
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      child: ListView.builder(
                        itemCount: availableLanguages.length,

                        itemBuilder: (_, index) {
                          final language = availableLanguages[index];

                          final selected = tempLanguages.contains(language);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),

                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFFF0F6F1)
                                  : Colors.white,

                              borderRadius: BorderRadius.circular(12),

                              border: Border.all(
                                color: selected ? primary : border,
                              ),
                            ),

                            child: CheckboxListTile(
                              value: selected,

                              activeColor: primary,

                              title: Text(
                                language,

                                style: TextStyle(
                                  fontSize: 15,

                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.normal,

                                  color: dark,
                                ),
                              ),

                              controlAffinity: ListTileControlAffinity.leading,

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),

                              dense: true,

                              onChanged: (checked) {
                                dialogSetState(() {
                                  if (checked == true) {
                                    if (!tempLanguages.contains(language)) {
                                      tempLanguages.add(language);
                                    }
                                  } else {
                                    tempLanguages.remove(language);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },

                  child: const Text('Cancel', style: TextStyle(color: primary)),
                ),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedLanguages
                        ..clear()
                        ..addAll(tempLanguages);
                    });

                    Navigator.pop(dialogContext);
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

  // ============================================================
  // LOGOUT
  // ============================================================

  void _showLogoutDialog() {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: background,

          title: const Text(
            'Log Out?',

            style: TextStyle(fontWeight: FontWeight.bold, color: dark),
          ),

          content: const Text('Are you sure you want to log out?'),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text('Cancel', style: TextStyle(color: primary)),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                // TODO:
                // Add your login screen
                // navigation here.
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: primary,

                foregroundColor: Colors.white,
              ),

              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // COMING SOON
  // ============================================================

  void _showComingSoon(String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title will be available soon.')));
  }
}
