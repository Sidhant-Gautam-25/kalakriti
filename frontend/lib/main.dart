import 'package:flutter/material.dart';

import 'screens/section_a/splash_screen.dart';

void main() {
  runApp(const KalaKritiApp());
}

class KalaKritiApp extends StatelessWidget {
  const KalaKritiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KalaKriti',
      home: const SplashScreen(),
    );
  }
}
