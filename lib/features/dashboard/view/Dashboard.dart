import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/utils/jwt_helper.dart';
import '../../../routes/app_routes.dart';
import '../controller/DashboardController.dart';
import '../controller/NotificationController.dart';
import '../widgets/custom_drawer.dart';


class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final DashboardController controller = Get.put(DashboardController());
  final NotificationController notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _showExitDialog(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC), // Ultra Light Gray
        drawer: const CustomDrawer(),
        body: Builder(builder: (context) {
          return Stack(
            children: [
              // Background Header Accent
              Container(
                height: 160,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryDark,
                      primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _buildPremiumHeader(context),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            _buildStatsContainer(context), // New Premium Design
                            const SizedBox(height: 25),
                            _buildModernGridSection(),
                            const SizedBox(height: 20),
                            _buildCompactFooterAction(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
             ],
          );
        }),
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.notes_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 5),
          const Text(
            "Overview",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showLogoutDialog(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. FULLY REDESIGNED STATS CONTAINER (Modern & Compact) ---
  Widget _buildStatsContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          children: [
            // Top Section: Profile Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryDark.withOpacity(0.03),
                border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: primaryDark,
                    child: Icon(Icons.person_rounded, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome Back!",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        // Yahan controller se name map karein
                        Obx(() => Text(
                          controller.userName?.value ?? "User Name",
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                        )),
                      ],
                    ),
                  ),
                  const Icon(Icons.verified_user_rounded, color: Colors.green, size: 20),
                ],
              ),
            ),
            // Bottom Section: Stats Metrics
            Obx(() => Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statItem("Completed", "${controller.completeAudit.value}", Icons.assignment_rounded),
                    VerticalDivider(color: Colors.grey.shade200, thickness: 1),
                    _statItem("Under-Process", "${controller.underProcessAudit.value}", Icons.pending_actions_rounded),
                    VerticalDivider(color: Colors.grey.shade200, thickness: 1),
                    _statItem("Yet-to-start", "${controller.yetToStartAudit.value}", Icons.shutter_speed_rounded),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 18, color: primaryDark.withOpacity(0.7)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }

  // --- 3. BENTO GRID ---
// --- Update: Quick Actions Section (Attractive & Premium) ---

  Widget _buildModernGridSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 15),
          child: Text(
            "Core Operations",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF1E293B)),
          ),
        ),
        // --- Row 1: Staggered (One Large, One Small) ---
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _premiumActionCard(
                "Audit Process",
                "Manage and review active audit tasks",
                Icons.analytics_rounded,
                const Color(0xFF6366F1),
                    () => Get.toNamed(AppRoutes.AuditProcess),
                isLarge: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: _premiumActionCard(
                "Help & Support",
                "Get instant technical assistance",
                Icons.support_agent_rounded,
                  primaryPink,
                    () {
                   Get.toNamed(AppRoutes.help);
                    }, 
                isLarge: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // --- Row 2: Staggered (One Small, One Large) ---
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _premiumActionCard(
                "Profile",
                "",
                Icons.person_pin_rounded,
                const Color(0xFF10B981),
                    () => Get.toNamed(AppRoutes.profile),
                isLarge: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _premiumActionCard(
                "Go Audit",
                "• Start live assessment now\n• Track real-time progress",
                Icons.bolt_rounded,
                const Color(0xFFF59E0B),
                    () => Get.toNamed(AppRoutes.annexureViewPage),
                    // () => Get.toNamed(AppRoutes.GoToAudit),
                isLarge: true,
              ),
            ),

          ],
        ),
      ],
    );
  }

  Widget _premiumActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap, {required bool isLarge}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 140, // Uniform height for a clean bento row
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon with Neon Background
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const Spacer(),
            // Title
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: isLarge ? 15 : 13,
                color: const Color(0xFF1E293B),
              ),
            ),
            // Subtitle (Only for Large Cards)
            if (isLarge && subtitle.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (!isLarge) const SizedBox(height: 15), // Balancing for small cards
          ],
        ),
      ),
    );
  }

  // --- 4. COMPACT FOOTER ---
  Widget _buildCompactFooterAction() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_moon_outlined, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 12),
          const Text("Status: Protected", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
            child: Text("Online", style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  // --- DIALOGS ---
  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Exit App?"),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () => Get.back(result: true),
            child: const Text("Exit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout"),
        content: const Text("Do you want to log out?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("No")),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => JwtHelper.Logout(),
            child: const Text("Yes, Logout"),
          ),
        ],
      ),
    );
  }
}