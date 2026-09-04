import 'package:flutter/material.dart';

import 'my_products.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5EC),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF333333),

        title: const Text(
          'Orders',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // HEADING
              // ------------------------------------------------

              const Text(
                'Your Orders',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F704F),
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Track orders and manage your craft sales.',
                style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),

              const SizedBox(height: 28),

              // ------------------------------------------------
              // ORDER SUMMARY
              // ------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      icon: Icons.pending_actions_outlined,
                      title: 'Pending',
                      value: '—',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _summaryCard(
                      icon: Icons.local_shipping_outlined,
                      title: 'Shipping',
                      value: '—',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _summaryCard(
                      icon: Icons.check_circle_outline,
                      title: 'Completed',
                      value: '—',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ------------------------------------------------
              // RECENT ORDERS
              // ------------------------------------------------
              const Text(
                'Recent Orders',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 15),

              Expanded(child: _emptyOrders(context)),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SUMMARY CARD
  // ------------------------------------------------------------

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 17),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),

      child: Column(
        children: [
          Icon(icon, size: 26, color: const Color(0xFF3F704F)),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const SizedBox(height: 3),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Color(0xFF777777)),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // EMPTY ORDERS
  // ------------------------------------------------------------

  Widget _emptyOrders(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration container
            Container(
              width: 105,
              height: 105,

              decoration: BoxDecoration(
                color: const Color(0xFFE8E0CF),
                borderRadius: BorderRadius.circular(30),
              ),

              child: const Icon(
                Icons.receipt_long_outlined,
                size: 50,
                color: Color(0xFF3F704F),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 9),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),

              child: Text(
                'When buyers purchase your crafts, '
                'your orders will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF777777),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Catalogue button
            SizedBox(
              height: 48,

              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyProductsScreen(),
                    ),
                  );
                },

                icon: const Icon(Icons.inventory_2_outlined, size: 19),

                label: const Text(
                  'View My Products',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F704F),

                  foregroundColor: Colors.white,

                  elevation: 0,

                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
