
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/DrawerController.dart' as drawer_controller;


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerController = Get.find<drawer_controller.CustomDrawerController>();

    return Drawer(
      backgroundColor: const Color(0xFFF8FAFC), // Dashboard se matching background
      width: MediaQuery.of(context).size.width * 0.80,
      child: Column(
        children: [
          // Header Section with Glass Effect or Solid Primary
          _buildModernHeader(drawerController),

          const SizedBox(height: 10),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                _drawerTile(Icons.dashboard_rounded, "Dashboard", () => Get.back()),
                _drawerTile(Icons.info_outline_rounded, "About Us", drawerController.navigateToAboutUs),
                _drawerTile(Icons.contact_support_outlined, "Contact Us", drawerController.navigateToContactUs),
                _drawerTile(Icons.help_center_outlined, "Help & Support", drawerController.navigateToHelp),
                // _drawerTile(Icons.settings_suggest_outlined, "Settings", drawerController.navigateToSettings),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Divider(thickness: 1, color: Color(0xFFE2E8F0)),
                ),

                _drawerTile(Icons.logout_rounded, "Logout", drawerController.handleLogout, isExit: true),
              ],
            ),
          ),

          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  // Naya Modern Header
  Widget _buildModernHeader(drawer_controller.CustomDrawerController controller) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
      decoration: const BoxDecoration(
        color: primaryDark, // Dashboard ka primary color
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
      ),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: controller.userImageUrl.value.isNotEmpty
                      ? NetworkImage(controller.userImageUrl.value)
                      : null,
                  child: controller.userImageUrl.value.isEmpty
                      ? Text(controller.userInitials.value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                      : null,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.userName.value,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      controller.userEmail.value,
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }

  // Modern Drawer Tile
  Widget _drawerTile(IconData icon, String title, VoidCallback onTap, {bool isExit = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: isExit ? primaryPink : primaryDark),
        title: Text(
          title,
          style: TextStyle(
            color: isExit ? primaryPink : const Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      ),
    );
  }
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
      child: Column(
        children: [
          // Subtle Divider to separate content from footer
          Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              color: primaryDark.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),

          // Brand Name with Premium Spacing
          Text(
            "SCORE APP".toUpperCase(),
            style: TextStyle(
              color: primaryDark.withOpacity(0.9),
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 3.0, // Executive spacing
            ),
          ),

          const SizedBox(height: 6),

          // Version and Rights with Slate theme
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "v1.0.0",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                height: 10,
                width: 1,
                color: Colors.grey.shade300,
              ),
              Text(
                "SECURE ACCESS",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Final Bottom Accent
          Text(
            "© 2026 Audit Management System",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}