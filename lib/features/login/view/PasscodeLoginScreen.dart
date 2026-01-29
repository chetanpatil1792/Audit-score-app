
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../../../routes/app_routes.dart';
import '../controller/PasscodeController.dart';

class PasscodeLoginScreen extends GetView<PasscodeController> {
  const PasscodeLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller link
    if (!Get.isRegistered<PasscodeController>()) {
      Get.put(PasscodeController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          // 1. Dynamic Header Accent
          Container(
            height: 200, // Reduced height to prevent overflow
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryDark, Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder( // Responsive height check ke liye
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          // Branding
                          const Text(
                            "SCORE",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 8,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // 2. Passcode Card (Compact)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Security Check",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    "Enter 4-digit passcode",
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  const SizedBox(height: 25),

                                  // PIN Dots
                                  Obx(() => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(4, (index) {
                                      bool isFilled = index < controller.enteredPin.value.length;
                                      return AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: isFilled
                                              ? (controller.isPinError.isTrue ? Colors.redAccent : primaryDark)
                                              : Colors.grey.shade100,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isFilled ? Colors.transparent : Colors.grey.shade300,
                                            width: 1,
                                          ),
                                        ),
                                      );
                                    }),
                                  )),

                                  Obx(() => controller.isPinError.isTrue
                                      ? const Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Text('Invalid Passcode',
                                        style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                                  )
                                      : const SizedBox(height: 20)),
                                ],
                              ),
                            ),
                          ),

                          const Spacer(), // Keypad ko niche dhakelne ke liye

                          // 3. Premium Keypad (Compact)
                          _buildModernKeypad(context),

                          // 4. Footer Actions
                          TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.ForgotPasscodeView),
                            child: Text(
                              "Forgot Passcode?",
                              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernKeypad(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 10),
      child: Column(
        children: [
          _keypadRow(['1', '2', '3']),
          _keypadRow(['4', '5', '6']),
          _keypadRow(['7', '8', '9']),
          _keypadRow(['fingerprint', '0', 'delete']),
        ],
      ),
    );
  }

  Widget _keypadRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: keys.map((key) {
          if (key == 'delete') {
            return _keyButton(icon: Icons.backspace_outlined, onTap: controller.clearLastDigit);
          }
          if (key == 'fingerprint') {
            return _keyButton(icon: Icons.fingerprint_rounded, iconColor: Colors.blueAccent, onTap: controller.authenticateWithBiometrics);
          }
          return _keyButton(label: key, onTap: () => controller.handlePinInput(key));
        }).toList(),
      ),
    );
  }

  Widget _keyButton({String? label, IconData? icon, Color? iconColor, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 65, // Slightly reduced size
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: label != null
              ? Text(label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)))
              : Icon(icon, size: 24, color: iconColor ?? const Color(0xFF1E293B)),
        ),
      ),
    );
  }
}