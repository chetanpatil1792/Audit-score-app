
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/PasscodeController.dart';

class CreatePasscodeScreen extends GetView<PasscodeController> {
  const CreatePasscodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Dashboard Slate Background
      body: Stack(
        children: [
          // 1. Premium Header Accent (Dashboard Style)
          Container(
            height: 200,
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          // Branding / Logo Area
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

                          // 2. Creation Message Card (Bento Style)
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
                              child: Obx(() => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: primaryDark.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.shield_outlined, color: primaryDark, size: 24),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    controller.creationMessage.value,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Please set a secure 4-digit code",
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  const SizedBox(height: 25),

                                  // PIN Dots
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(4, (index) {
                                      final currentPin = controller.isConfirming.isFalse
                                          ? controller.newPasscode1.value
                                          : controller.newPasscode2.value;

                                      bool isFilled = index < currentPin.length;

                                      return AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: isFilled ? primaryDark : Colors.grey.shade100,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isFilled ? Colors.transparent : Colors.grey.shade300,
                                            width: 1,
                                          ),
                                          boxShadow: isFilled ? [
                                            BoxShadow(
                                              color: primaryDark.withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            )
                                          ] : [],
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              )),
                            ),
                          ),

                          const Spacer(),

                          // 3. Compact Modern Keypad
                          _buildModernKeypad(context),

                          // 4. Footer Actions
                          if (controller.isPasscodeSet.isTrue)
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13
                                ),
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
          _keypadRow(['', '0', 'delete']),
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
          if (key == '') return const SizedBox(width: 65);

          if (key == 'delete') {
            return _keyButton(icon: Icons.backspace_outlined, onTap: controller.clearCreationLastDigit);
          }

          return _keyButton(label: key, onTap: () => controller.handleCreationPinInput(key));
        }).toList(),
      ),
    );
  }

  Widget _keyButton({String? label, IconData? icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: label != null
              ? Text(label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)))
              : Icon(icon, size: 24, color: const Color(0xFF1E293B)),
        ),
      ),
    );
  }
}