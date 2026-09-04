import 'package:flutter/material.dart';

class CustomizationRequestsScreen extends StatefulWidget {
  const CustomizationRequestsScreen({super.key});

  @override
  State<CustomizationRequestsScreen> createState() =>
      _CustomizationRequestsScreenState();
}

class _CustomizationRequestsScreenState
    extends State<CustomizationRequestsScreen> {
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
  // CUSTOMIZATION REQUESTS
  //
  // This list is intentionally empty.
  //
  // Real buyer customization requests can be added here later
  // when the buyer and artisan sides are connected to a database.
  // ============================================================

  final List<Map<String, dynamic>> _requests = [];

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
          'Customization Requests',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // HEADER
              // ==================================================

              _buildHeader(),

              const SizedBox(height: 22),

              // ==================================================
              // REQUESTS / EMPTY STATE
              // ==================================================
              if (_requests.isEmpty)
                _buildEmptyRequests()
              else
                ...List.generate(_requests.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildRequestCard(index, _requests[index]),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(
        children: [
          // ------------------------------------------------------
          // ICON
          // ------------------------------------------------------

          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(
              Icons.auto_fix_high_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          // ------------------------------------------------------
          // TEXT
          // ------------------------------------------------------
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Requests matching your crafts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Create something special based on what buyers are looking for.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: Colors.white70,
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
  // EMPTY REQUESTS
  // ============================================================

  Widget _buildEmptyRequests() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),

      child: Column(
        children: [
          // ------------------------------------------------------
          // ICON
          // ------------------------------------------------------

          Container(
            width: 80,
            height: 80,

            decoration: const BoxDecoration(
              color: cream,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.auto_fix_high_outlined,
              size: 38,
              color: primary,
            ),
          ),

          const SizedBox(height: 18),

          // ------------------------------------------------------
          // TITLE
          // ------------------------------------------------------
          const Text(
            'No customization requests yet',
            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),

          const SizedBox(height: 8),

          // ------------------------------------------------------
          // DESCRIPTION
          // ------------------------------------------------------
          const Text(
            'When buyers send customization requests '
            'that match your crafts, they will appear here.',

            textAlign: TextAlign.center,

            style: TextStyle(fontSize: 13, height: 1.45, color: muted),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REQUEST CARD
  // ============================================================

  Widget _buildRequestCard(int index, Map<String, dynamic> request) {
    final String status = request['status'] as String;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ======================================================
          // CUSTOMER + STATUS
          // ======================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // --------------------------------------------------
              // CUSTOMER ICON
              // --------------------------------------------------

              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons.person_outline,
                  color: primary,
                  size: 26,
                ),
              ),

              const SizedBox(width: 12),

              // --------------------------------------------------
              // CUSTOMER INFORMATION
              // --------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      request['customer'] as String,

                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      request['craft'] as String,

                      style: const TextStyle(fontSize: 12.5, color: muted),
                    ),
                  ],
                ),
              ),

              // --------------------------------------------------
              // STATUS
              // --------------------------------------------------
              _statusBadge(status),
            ],
          ),

          const SizedBox(height: 18),

          // ======================================================
          // COLOUR
          // ======================================================
          _detailRow(
            Icons.palette_outlined,
            'Colour',
            request['colour'] as String,
          ),

          const SizedBox(height: 10),

          // ======================================================
          // PATTERN
          // ======================================================
          _detailRow(
            Icons.pattern_outlined,
            'Pattern / Style',
            request['pattern'] as String,
          ),

          const SizedBox(height: 10),

          // ======================================================
          // PRICE
          // ======================================================
          _detailRow(
            Icons.currency_rupee,
            'Price range',
            request['price'] as String,
          ),

          const SizedBox(height: 16),

          // ======================================================
          // ADDITIONAL REQUEST
          // ======================================================
          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(14),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'Additional request',

                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  request['request'] as String,

                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    color: dark,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ======================================================
          // REFERENCE IMAGE
          // ======================================================
          if (request['hasImage'] == true)
            GestureDetector(
              onTap: () {
                _showReferenceImageMessage();
              },

              child: Container(
                width: double.infinity,
                height: 95,

                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(14),
                ),

                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(Icons.image_outlined, color: primary, size: 28),

                    SizedBox(height: 5),

                    Text(
                      'Buyer attached a reference image',

                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: dark,
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      'Tap to view reference',

                      style: TextStyle(fontSize: 10.5, color: muted),
                    ),
                  ],
                ),
              ),
            ),

          if (request['hasImage'] == true) const SizedBox(height: 16),

          // ======================================================
          // ACCEPT / REJECT
          // ======================================================
          if (status == 'Pending')
            Row(
              children: [
                // ------------------------------------------------
                // REJECT
                // ------------------------------------------------

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _rejectRequest(index);
                    },

                    icon: const Icon(Icons.close, size: 18),

                    label: const Text('Reject'),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,

                      side: BorderSide(color: Colors.red.shade200),

                      minimumSize: const Size(double.infinity, 46),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // ------------------------------------------------
                // ACCEPT
                // ------------------------------------------------
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _acceptRequest(index);
                    },

                    icon: const Icon(Icons.check, size: 18),

                    label: const Text('Accept'),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,

                      minimumSize: const Size(double.infinity, 46),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          // ======================================================
          // COMPLETED STATUS
          // ======================================================
          if (status != 'Pending')
            Container(
              width: double.infinity,

              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),

              decoration: BoxDecoration(
                color: status == 'Accepted'
                    ? primary.withValues(alpha: 0.08)
                    : Colors.red.withValues(alpha: 0.06),

                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                children: [
                  Icon(
                    status == 'Accepted'
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,

                    size: 19,

                    color: status == 'Accepted' ? primary : Colors.red.shade700,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      status == 'Accepted'
                          ? 'You accepted this customization request.'
                          : 'You rejected this customization request.',

                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,

                        color: status == 'Accepted'
                            ? primary
                            : Colors.red.shade700,
                      ),
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
  // DETAIL ROW
  // ============================================================

  Widget _detailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // ------------------------------------------------------
        // ICON
        // ------------------------------------------------------

        Container(
          width: 34,
          height: 34,

          decoration: BoxDecoration(
            color: cream,
            borderRadius: BorderRadius.circular(10),
          ),

          child: Icon(icon, color: primary, size: 18),
        ),

        const SizedBox(width: 10),

        // ------------------------------------------------------
        // TEXT
        // ------------------------------------------------------
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(title, style: const TextStyle(fontSize: 10.5, color: muted)),

              const SizedBox(height: 2),

              Text(
                value,

                style: const TextStyle(
                  fontSize: 13,
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
  // STATUS BADGE
  // ============================================================

  Widget _statusBadge(String status) {
    final bool accepted = status == 'Accepted';
    final bool rejected = status == 'Rejected';

    Color textColor = primary;

    if (rejected) {
      textColor = Colors.red.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),

      decoration: BoxDecoration(
        color: rejected
            ? Colors.red.withValues(alpha: 0.08)
            : accepted
            ? primary.withValues(alpha: 0.10)
            : cream,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        status,

        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  // ============================================================
  // ACCEPT REQUEST
  // ============================================================

  void _acceptRequest(int index) {
    setState(() {
      _requests[index]['status'] = 'Accepted';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Customization request accepted.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // REJECT REQUEST
  // ============================================================

  void _rejectRequest(int index) {
    setState(() {
      _requests[index]['status'] = 'Rejected';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Customization request rejected.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // REFERENCE IMAGE MESSAGE
  // ============================================================

  void _showReferenceImageMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Reference image viewer will be connected when buyer requests are stored.',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
