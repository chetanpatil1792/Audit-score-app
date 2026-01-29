import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safe_device/safe_device.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../routes/app_routes.dart';
import 'PasscodeController.dart';

enum LoginStatus { idle, loading, success, error }

class LoginController extends GetxController {
  // Reactive variables
  var userName = ''.obs;
  var password = ''.obs;
  var loginStatus = LoginStatus.idle.obs;
  var message = ''.obs;

  // Text controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Password visibility
  var isPasswordVisible = false.obs;

  // Secure storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final storage = GetStorage();

  // Passcode Controller instance
  final PasscodeController passcodeController = Get.put(PasscodeController());

  @override
  void onInit() {
    super.onInit();

  }



  /// ✅ Check if already logged in (based on secure token)
  Future<void> checkLoginStatus() async {
    final accessToken = await secureStorage.read(key: 'access_token');
    final refreshToken = await secureStorage.read(key: 'refresh_token');

    if (accessToken != null && accessToken.isNotEmpty) {
      // ✅ Access token available → direct biometric/passcode
      passcodeController.checkPasscodeStatusAndBiometrics();

      if (passcodeController.isPasscodeSet.value) {
        Get.offAllNamed(AppRoutes.PasscodeLoginView);
        passcodeController.authenticateWithBiometrics();
      } else {
        Get.offAllNamed(AppRoutes.CreatePasscodeView);
      }

    } else if (refreshToken != null && refreshToken.isNotEmpty) {
      // 🔁 Access token expired but refresh token available → try refresh
      print('🔄 Trying to refresh access token using refresh token...');
      final success = await refreshAccessToken(refreshToken);

      if (success) {
        print('✅ Token refreshed successfully');
        passcodeController.checkPasscodeStatusAndBiometrics();

        if (passcodeController.isPasscodeSet.value) {
          Get.offAllNamed(AppRoutes.PasscodeLoginView);
          passcodeController.authenticateWithBiometrics();
        } else {
          Get.offAllNamed(AppRoutes.CreatePasscodeView);
        }
      } else {
        print('⚠️ Refresh token invalid, redirecting to login...');
        await logout();
      }

    } else {
      // 🚪 No token found → Go to Login screen
      Get.offAllNamed(AppRoutes.LOGIN);
      print('🔒 No token found, redirecting to Login screen...');
    }
  }

  Future<bool> refreshAccessToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.refreshToken),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"refreshToken": refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('🔁 Refresh API Response: $data');

        if (data['result'] == 'success') {
          final newAccessToken = data['token'];
          await secureStorage.write(key: 'access_token', value: newAccessToken);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('❌ Error refreshing token: $e');
      return false;
    }
  }



  /// 🔐 Login API integration
  Future<void> login() async {
    if (userName.value.isEmpty || password.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter username and password',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    loginStatus.value = LoginStatus.loading;

    try {
      final response = await http.post(
        Uri.parse(ApiUrls.login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "UserName": userName.value.trim(),
          "Password": password.value.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('🟢 Login API Response: $data');

        if (data['result'] == 'success' && data['userInfo'] != null) {
          final userInfo = Map<String, dynamic>.from(data['userInfo']);
          final accessToken = data['token'];
          final refreshToken = data['refreshToken'];

          if (accessToken != null && refreshToken != null) {
            /// 🔸 Store securely
            await secureStorage.write(key: 'access_token', value: accessToken);
            await secureStorage.write(key: 'refresh_token', value: refreshToken);
            await secureStorage.write(key: 'user_info', value: jsonEncode(userInfo));

            await storage.write('userInfo', userInfo);


            loginStatus.value = LoginStatus.success;

            /// 🔹 Proceed to passcode or biometric flow
            passcodeController.checkPasscodeStatusAndBiometrics();

            if (passcodeController.isPasscodeSet.value) {
              Get.offAllNamed(AppRoutes.PasscodeLoginView);
            } else {
              Get.offAllNamed(AppRoutes.CreatePasscodeView);
            }

            print('✅ Login successful — refresh tokens stored securely $refreshToken');
            print('✅ Login successful — tokens stored securely $accessToken');
          } else {
            throw Exception('Token fields missing in response');
          }
        } else {
          loginStatus.value = LoginStatus.error;
          message.value = data['message'] ?? 'Invalid credentials';
          Get.snackbar(
            'Error',
            message.value,
            backgroundColor: Colors.red.shade400,
            colorText: Colors.white,
          );
        }
      } else {
        loginStatus.value = LoginStatus.error;
        Get.snackbar(
          'Error',
          'Server error: ${response.statusCode}',
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      loginStatus.value = LoginStatus.error;
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      if (loginStatus.value != LoginStatus.success) {
        loginStatus.value = LoginStatus.idle;
      }
    }
  }

  /// 🚪 Logout method (secure clear)
  Future<void> logout() async {
    final storage = GetStorage();
    storage.erase();
    await secureStorage.deleteAll();
    Get.offAllNamed(AppRoutes.LOGIN);
    print('🔒 Logged out and cleared secure storage');
  }
}
