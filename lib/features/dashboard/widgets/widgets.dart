

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/DashboardController.dart';

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 20);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 50);
    var secondEndPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


// --- NEW WIDGET: Combined Profile and Stats Banner ---
Widget buildProfileAndStatsBanner(double screenWidth, DashboardController controller) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: cardBackground,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        // 1. User Info (Row with Avatar, Name, Location)
        Row(
          children: [
            // Avatar
            Obx(() => CircleAvatar(
              maxRadius: 28,
              backgroundColor: primaryLight.withOpacity(0.2),
              backgroundImage: controller.userImageUrl.value.isNotEmpty
                  ? NetworkImage(controller.userImageUrl.value)
                  : null,
              child: controller.userImageUrl.value.isEmpty
                  ? Text(
                controller.getInitials(controller.userName.value),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryDark,
                ),
              )
                  : null,
            )),
            const SizedBox(width: 15),
            // Name and Location
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    controller.userName.value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: primaryDark,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
                  const SizedBox(height: 2),
                  Obx(() => Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: primaryLight, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        controller.userLocation.value,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),

        const Divider(height: 25, thickness: 1, indent: 5, endIndent: 5),

        // 2. Audit Stats (Row of Metrics)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildStatMetric("0", "Total Audit", primaryDark,controller),
            buildStatMetric("0", "Completed", Colors.green.shade600,controller),
            buildStatMetric("0", "Pending", yellowColor,controller),
          ],
        ),
      ],
    ),
  );
}

// Helper widget for profile metrics
Widget buildStatMetric(String count, String label, Color color, DashboardController controller) {
  return Column(
    children: [
      Text(
        count,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 24,
          color: color, // Use distinct color for count
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    ],
  );
}

// Enhanced Menu Box Widget (Unchanged from previous version for consistency)
Widget menuBox(String title, IconData icon, Color color, VoidCallback onTap, DashboardController controller) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color.withOpacity(0.8), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(icon, size: 30, color: Colors.white),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: primaryDark,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: primaryDark,
      ),
    ),
  );
}

// Widget for Issue Count Pan India (Enhanced with Gradient)
Widget buildDataSnapshotCard({required String title, required String value, required String subtitle, required IconData icon, required Color color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Card(
      elevation: 10, // Increased elevation for premium look
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient( // Added Gradient
            colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(icon, size: 45, color: Colors.white),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 36, // Larger value text
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Widget for Monthly Audit Snapshot (Graph Card)
Widget buildAuditGraph({required String title, required String description}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            // Placeholder for the actual graph (e.g., Fl_chart widget)
            Container(
              height: 200, // Slightly increased height
              decoration: BoxDecoration(
                color: primaryDark.withOpacity(0.05), // Light background for graph area
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: primaryDark.withOpacity(0.1)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart, size: 40, color: primaryLight),
                    const SizedBox(height: 8),
                    Text(
                      'Actual Chart Widget Implementation Area\n(e.g., Line Chart for Trends)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: primaryLight, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Widget for Top and Bottom Branch Rankings (Now Vertical)
Widget buildBranchRanking() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('🏆 Branch Performance Leaderboard'),
        // Top Branches Pan India (Vertical)
        buildRankingList(
          title: 'Top 5 Branches',
          branches: ['Pune', 'Bangalore', 'Chennai', 'Hyderabad', 'Ahmedabad'],
          scores: ['98%', '95%', '92%', '91%', '90%'],
          isTop: true,
        ),

        const SizedBox(height: 25), // Increased separation

        // Bottom Branches Pan India (Vertical)
        buildRankingList(
          title: 'Bottom 5 Branches',
          branches: ['Mumbai', 'Delhi', 'Kolkata', 'Jaipur', 'Lucknow'],
          scores: ['55%', '48%', '40%', '35%', '30%'],
          isTop: false,
        ),
      ],
    ),
  );
}

// Reusable Ranking List Widget
Widget buildRankingList({required String title, required List<String> branches, required List<String> scores, required bool isTop}) {
  final listColor = isTop ? Colors.green.shade700 : Colors.red.shade700;
  final icon = isTop ? Icons.leaderboard_sharp : Icons.warning_amber; // Different icon for attention list

  return Card(
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: listColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: primaryDark,
                ),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 1),
          ...branches.asMap().entries.map((entry) {
            int index = entry.key;
            String branch = entry.value;
            String score = scores[index];

            // Conditional highlight for the worst performer in the bottom list
            final isWorst = !isTop && index == 0;
            final rowColor = isWorst ? Colors.red.shade50 : Colors.transparent;

            return Container(
              color: rowColor,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: listColor,
                      shape: BoxShape.circle, // Circular rank badge
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      branch,
                      style: TextStyle(
                        fontSize: 15,
                        color: primaryDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    score, // Displaying the score/metric
                    style: TextStyle(
                      fontSize: 15,
                      color: listColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    isTop ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 20,
                    color: listColor,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    ),
  );
}
