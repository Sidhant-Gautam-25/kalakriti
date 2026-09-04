import 'package:flutter/material.dart';

import 'login_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  static const Color background = Color(0xFFF8F5EC);
  static const Color primary = Color(0xFF3F704F);
  static const Color dark = Color(0xFF333333);
  static const Color muted = Color(0xFF666666);
  static const Color border = Color(0xFFD8D2C5);

  String selectedLanguage = 'English';
  bool voiceAssistance = true;

  final List<Map<String, String>> languages = [
    {'name': 'English', 'native': 'English'},
    {'name': 'Hindi', 'native': 'हिंदी'},
    {'name': 'Bengali', 'native': 'বাংলা'},
    {'name': 'Marathi', 'native': 'मराठी'},
    {'name': 'Tamil', 'native': 'தமிழ்'},
    {'name': 'Telugu', 'native': 'తెలుగు'},
    {'name': 'Gujarati', 'native': 'ગુજરાતી'},
    {'name': 'Punjabi', 'native': 'ਪੰਜਾਬੀ'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: dark),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'KalaKriti',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
      ),

      body: Column(
        children: [
          // --------------------------------------------------
          // PROGRESS DOTS
          // --------------------------------------------------

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _progressDot(false),
              const SizedBox(width: 5),
              _progressDot(true),
              const SizedBox(width: 5),
              _progressDot(false),
            ],
          ),

          // --------------------------------------------------
          // CONTENT
          // --------------------------------------------------
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose your preferred\nlanguage',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: dark,
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "We'll use this language throughout your "
                        'KalaKriti experience.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: muted,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // --------------------------------------------------
                      // LANGUAGE GRID
                      // --------------------------------------------------
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: languages.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 2.35,
                            ),
                        itemBuilder: (context, index) {
                          final language = languages[index];

                          return _languageCard(
                            name: language['name']!,
                            native: language['native']!,
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // --------------------------------------------------
                      // VOICE ASSISTANCE
                      // --------------------------------------------------
                      _buildVoiceAssistance(),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --------------------------------------------------
          // BOTTOM CONTINUE
          // --------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
            decoration: const BoxDecoration(
              color: background,
              border: Border(top: BorderSide(color: Color(0xFFE0DACD))),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 390),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // LANGUAGE CARD
  // ------------------------------------------------------------

  Widget _languageCard({required String name, required String native}) {
    final bool selected = selectedLanguage == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = name;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF7FAF7) : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: selected ? primary : border,
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    native,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                      color: dark,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 8, color: dark),
                  ),
                ],
              ),
            ),

            if (selected)
              const Positioned(
                right: 0,
                top: 0,
                child: Icon(Icons.check_circle, color: primary, size: 14),
              ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // VOICE ASSISTANCE
  // ------------------------------------------------------------

  Widget _buildVoiceAssistance() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFE0DACD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Voice Assistance',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),
              ),

              const Icon(
                Icons.record_voice_over_outlined,
                color: primary,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 5),

          const Text(
            'Would you like us to read important information aloud?',
            style: TextStyle(fontSize: 11, height: 1.4, color: muted),
          ),

          const SizedBox(height: 12),

          _voiceOption(
            selected: voiceAssistance,
            title: 'Yes, help me with voice',
            icon: Icons.volume_up_outlined,
            onTap: () {
              setState(() {
                voiceAssistance = true;
              });
            },
          ),

          const SizedBox(height: 7),

          _voiceOption(
            selected: !voiceAssistance,
            title: "No, I'll read myself",
            icon: Icons.menu_book_outlined,
            onTap: () {
              setState(() {
                voiceAssistance = false;
              });
            },
          ),

          const SizedBox(height: 10),

          Center(
            child: TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Voice example will be connected later.'),
                  ),
                );
              },
              icon: const Icon(Icons.play_circle_outline, size: 15),
              label: const Text(
                'Hear an example',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                foregroundColor: primary,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // VOICE OPTION
  // ------------------------------------------------------------

  Widget _voiceOption({
    required bool selected,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF7FAF7) : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: selected ? primary : const Color(0xFFE0DACD),
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 17,
              color: selected ? primary : const Color(0xFF777777),
            ),

            const SizedBox(width: 7),

            Icon(icon, size: 15, color: dark),

            const SizedBox(width: 7),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: dark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PROGRESS DOT
  // ------------------------------------------------------------

  Widget _progressDot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 17 : 5,
      height: 5,
      decoration: BoxDecoration(
        color: active ? primary : const Color(0xFFE1DED6),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
