import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../artisan/artisan_dashboard.dart';
import '../buyer/buyer_home.dart';

class RoleSelectionScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String password;

  const RoleSelectionScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.password,
  });

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  static const Color background = Color(0xFFF8F5EC);
  static const Color terracotta = Color(0xFFBE7048);
  static const Color terracottaLight = Color(0xFFF5E8E0);
  static const Color green = Color(0xFF4D7655);
  static const Color greenLight = Color(0xFFEAF0E8);
  static const Color dark = Color(0xFF262626);
  static const Color muted = Color(0xFF777777);
  static const Color border = Color(0xFFE1D9CC);

  String? selectedRole;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallScreen = constraints.maxWidth < 750;

            return Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      isSmallScreen ? 20 : 28,
                      10,
                      isSmallScreen ? 20 : 28,
                      25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'How will you use KalaKriti App?',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: dark,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Choose the option that best describes you.',
                          style: TextStyle(fontSize: 16, color: muted),
                        ),
                        const SizedBox(height: 30),
                        if (isSmallScreen)
                          Column(
                            children: [
                              _buildRoleCard(
                                role: 'artisan',
                                title: "I'm an Artisan",
                                subtitle: 'Sell your handmade products',
                                imagePath: 'assets/images/artisan_role.png',
                                accentColor: terracotta,
                                lightColor: terracottaLight,
                              ),
                              const SizedBox(height: 20),
                              _buildRoleCard(
                                role: 'buyer',
                                title: "I'm a Buyer",
                                subtitle: 'Discover authentic handmade products',
                                imagePath: 'assets/images/buyer_role.png',
                                accentColor: green,
                                lightColor: greenLight,
                              ),
                            ],
                          )
                        else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildRoleCard(
                                  role: 'artisan',
                                  title: "I'm an Artisan",
                                  subtitle: 'Sell your handmade products',
                                  imagePath: 'assets/images/artisan_role.png',
                                  accentColor: terracotta,
                                  lightColor: terracottaLight,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: _buildRoleCard(
                                  role: 'buyer',
                                  title: "I'm a Buyer",
                                  subtitle: 'Discover authentic handmade products',
                                  imagePath: 'assets/images/buyer_role.png',
                                  accentColor: green,
                                  lightColor: greenLight,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                _buildContinueButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SizedBox(
      height: 65,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 28, color: dark),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Choose Your Role',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                border: Border.all(color: dark, width: 2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '?',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),
              ),
            ),
            onPressed: _showHelp,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildRoleCard({
    required String role,
    required String title,
    required String subtitle,
    required String imagePath,
    required Color accentColor,
    required Color lightColor,
  }) {
    final bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isSelected ? accentColor : border,
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? accentColor.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: isSelected ? 18 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: AspectRatio(
                  aspectRatio: 1.65,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: lightColor,
                        child: Icon(
                          role == 'artisan'
                              ? Icons.palette_outlined
                              : Icons.shopping_bag_outlined,
                          size: 80,
                          color: accentColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 17, 18, 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Icon(
                      role == 'artisan'
                          ? Icons.palette_outlined
                          : Icons.shopping_bag_outlined,
                      color: accentColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? accentColor : dark,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 15,
                            color: dark,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? accentColor : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? accentColor : border,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 21, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    final bool enabled = selectedRole != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 8, 25, 20),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: enabled && !_isLoading ? _continue : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: terracotta,
            disabledBackgroundColor: const Color(0xFFC8CEC8),
            foregroundColor: Colors.white,
            disabledForegroundColor: const Color(0xFF777777),
            elevation: enabled ? 3 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Continue',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  Future<void> _continue() async {
    if (selectedRole == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.register(
        name: widget.name,
        phone: widget.phone,
        password: widget.password,
        role: selectedRole!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully! Welcome!')),
        );

        if (selectedRole == 'artisan') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ArtisanHomeScreen()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BuyerHomeScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${e.toString().replaceAll('Exception:', '')}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // HELP
  // ============================================================

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Choose your role',
            style: TextStyle(fontWeight: FontWeight.bold, color: dark),
          ),
          content: const Text(
            'Choose Artisan if you create and sell handmade '
            'crafts. Choose Buyer if you want to discover and '
            'purchase handmade products.',
            style: TextStyle(fontSize: 15, height: 1.5, color: muted),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Got it',
                style: TextStyle(
                  color: terracotta,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
