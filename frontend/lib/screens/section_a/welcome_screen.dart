import 'package:flutter/material.dart';

import 'language_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color background = Color(0xFFF8F5EC);
  static const Color primary = Color(0xFF3F704F);
  static const Color dark = Color(0xFF222222);
  static const Color muted = Color(0xFF555555);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // --------------------------------------------------
              // ILLUSTRATION
              // --------------------------------------------------
              Expanded(
                flex: 5,
                child: Image.asset(
                  'assets/images/welcome_artisan.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 8),

              // --------------------------------------------------
              // TITLE
              // --------------------------------------------------
              const Text(
                'Welcome to KalaKriti App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: dark,
                  height: 1.15,
                ),
              ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // SUBTITLE
              // --------------------------------------------------
              const Text(
                'Turn your craft into a digital business.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 21, color: dark, height: 1.3),
              ),

              const SizedBox(height: 20),

              // --------------------------------------------------
              // DESCRIPTION
              // --------------------------------------------------
              const Text(
                'Reach customers across the globe without '
                'complex tools or technical knowledge. KalaKriti '
                'App empowers you to showcase your handmade '
                'creations to a worldwide audience.',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 17, height: 1.35, color: muted),
              ),

              const Spacer(),

              // --------------------------------------------------
              // GET STARTED
              // --------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LanguageScreen(),
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
                    'Get Started',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // --------------------------------------------------
              // LOGIN
              // --------------------------------------------------
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'I already have an account',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // PAGE INDICATORS
              // --------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(true),
                  const SizedBox(width: 14),
                  _dot(false),
                  const SizedBox(width: 14),
                  _dot(false),
                ],
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? primary : Colors.transparent,
        border: Border.all(
          color: active ? primary : const Color(0xFF8B918B),
          width: 2,
        ),
      ),
      child: active ? const SizedBox() : null,
    );
  }
}
