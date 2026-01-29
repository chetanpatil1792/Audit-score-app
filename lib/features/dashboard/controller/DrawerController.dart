import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/utils/jwt_helper.dart';
import '../../../routes/app_routes.dart';

class CustomDrawerController extends GetxController {
  final storage = GetStorage();
  
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userLocation = ''.obs;
  var userImageUrl = ''.obs;
  var userInitials = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    var userInfo = storage.read('userInfo') ?? {};
    
    userName.value = userInfo['userName'] ?? 'Guest User';
    userEmail.value = userInfo['email'] ?? 'guest@example.com';
    userLocation.value = userInfo['location'] ?? 'Not Set';
    userImageUrl.value = userInfo['userImageUrl'] ?? '';
    userInitials.value = getInitials(userName.value);
  }

  String getInitials(String fullName) {
    fullName = fullName.trim();
    if (fullName.isEmpty) return 'GU';

    List<String> names = fullName.split(' ').where((s) => s.isNotEmpty).toList();
    if (names.isEmpty) return 'GU';

    if (names.length > 1) {
      return (names[0][0] + names.last[0]).toUpperCase();
    } else {
      return names[0][0].toUpperCase();
    }
  }

  void navigateToProfile() {
    Get.back(); // Close drawer
    Get.toNamed(AppRoutes.profile);
  }

  void navigateToAboutUs() {
    Get.back(); // Close drawer
    Get.toNamed(AppRoutes.aboutUs);
  }

  void navigateToContactUs() {
    Get.back(); // Close drawer
    Get.toNamed(AppRoutes.contactUs);
  }

  void navigateToHelp() {
    Get.back(); // Close drawer
    Get.toNamed(AppRoutes.help);
  }

  void navigateToSettings() {
    Get.back(); // Close drawer
    // Add settings route if needed
    Get.snackbar('Settings', 'Settings page coming soon!');
  }

  void handleLogout() {
    Get.back(); // Close drawer
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              JwtHelper.Logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

