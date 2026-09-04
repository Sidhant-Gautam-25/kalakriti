import 'package:flutter/material.dart';

import 'product_photo.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5EC),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF333333),

        title: const Text(
          'Add Product',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 5, 22, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // HEADING
              // ------------------------------------------------

              const Text(
                'Showcase your craft',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F704F),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Choose how you would like to add your craft.',
                style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),

              const SizedBox(height: 28),

              // ------------------------------------------------
              // TAKE PHOTO
              // ------------------------------------------------
              _optionCard(
                context: context,
                icon: Icons.camera_alt_outlined,
                title: 'Take a Photo',
                subtitle: 'Capture your craft using your camera.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductPhotoScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              // ------------------------------------------------
              // UPLOAD PHOTO
              // ------------------------------------------------
              _optionCard(
                context: context,
                icon: Icons.photo_library_outlined,
                title: 'Upload a Photo',
                subtitle: 'Choose a craft image from your device.',
                onTap: () {
                  _showPhotoUploadMessage(context);
                },
              ),

              const SizedBox(height: 14),

              // ------------------------------------------------
              // VOICE
              // ------------------------------------------------
              _optionCard(
                context: context,
                icon: Icons.mic_none_outlined,
                title: 'Describe by Voice',
                subtitle: 'Tell KalaKriti about your craft.',
                onTap: () {
                  _showVoiceMessage(context);
                },
              ),

              const SizedBox(height: 14),

              // ------------------------------------------------
              // MANUAL ENTRY
              // ------------------------------------------------
              _optionCard(
                context: context,
                icon: Icons.edit_outlined,
                title: 'Enter Details Manually',
                subtitle: 'Add your product information yourself.',
                onTap: () {
                  _showManualMessage(context);
                },
              ),

              const SizedBox(height: 30),

              // ------------------------------------------------
              // AI INFORMATION CARD
              // ------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: const Color(0xFFE8E0CF),
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFF3F704F),
                        size: 25,
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Let KalaKriti help you',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            'Our smart catalogue tools can help '
                            'turn your craft into a professional '
                            'product listing.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // BACKEND NOTE
              // ------------------------------------------------
              Center(
                child: Text(
                  'You can review everything before publishing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // OPTION CARD
  // ------------------------------------------------------------

  Widget _optionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(18),

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE0DACD)),
        ),

        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,

              decoration: BoxDecoration(
                color: const Color(0xFFE8E0CF),
                borderRadius: BorderRadius.circular(15),
              ),

              child: Icon(icon, color: const Color(0xFF3F704F), size: 28),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.3,
                      color: Color(0xFF777777),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF888888),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PHOTO UPLOAD MESSAGE
  // ------------------------------------------------------------

  void _showPhotoUploadMessage(BuildContext context) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F5EC),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            'Upload a Photo',
            style: TextStyle(
              color: Color(0xFF3F704F),
              fontWeight: FontWeight.bold,
            ),
          ),

          content: const Text(
            'Photo gallery integration will be '
            'connected with the backend and device '
            'services later.',
            style: TextStyle(height: 1.4, color: Color(0xFF555555)),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'Okay',
                style: TextStyle(color: Color(0xFF3F704F)),
              ),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // VOICE MESSAGE
  // ------------------------------------------------------------

  void _showVoiceMessage(BuildContext context) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F5EC),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            'Describe by Voice',
            style: TextStyle(
              color: Color(0xFF3F704F),
              fontWeight: FontWeight.bold,
            ),
          ),

          content: const Text(
            'Voice input will allow artisans to '
            'describe their craft naturally. '
            'The voice and AI services will be '
            'connected later.',
            style: TextStyle(height: 1.4, color: Color(0xFF555555)),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'Okay',
                style: TextStyle(color: Color(0xFF3F704F)),
              ),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // MANUAL ENTRY MESSAGE
  // ------------------------------------------------------------

  void _showManualMessage(BuildContext context) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F5EC),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            'Manual Entry',
            style: TextStyle(
              color: Color(0xFF3F704F),
              fontWeight: FontWeight.bold,
            ),
          ),

          content: const Text(
            'Manual product details will be '
            'available here. The information can '
            'later be sent to the backend for '
            'catalogue generation.',
            style: TextStyle(height: 1.4, color: Color(0xFF555555)),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'Okay',
                style: TextStyle(color: Color(0xFF3F704F)),
              ),
            ),
          ],
        );
      },
    );
  }
}
