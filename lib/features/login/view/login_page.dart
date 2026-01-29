
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';

/// 🎨 Light Theme Colors
const kBgColor = Color(0xffF5F7FB);
const kPrimary = Color(0xff4F8CFF);
const kTextDark = Color(0xff2E3A59);
const kInputFill = Color(0xffEEF1F7);

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Stack(
          children: [
            /// 🔹 Background decorations (same as before)
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: 0.06,
                        child: Image.asset(
                          "assets/images/bargraph2.png",
                          width: 130,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Opacity(
                        opacity: 0.08,
                        child: SvgPicture.asset(
                          "assets/images/onbard6.svg",
                          width: 130,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 390),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: 0.07,
                        child: SvgPicture.asset(
                          "assets/images/graph3.svg",
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Align(
              alignment: const Alignment(-0.6, -0.5),
              child: Opacity(
                opacity: 0.06,
                child: SvgPicture.asset(
                  "assets/images/svg1.svg",
                  width: 120,
                ),
              ),
            ),

            /// 🔹 Login Card
            Center(
              child: Container(
                height: 375,
                width: 500,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 25),

                        /// 🔹 Title
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 32,
                            color: kTextDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 25),

                        /// 🔹 Username
                        TextFormField(
                          controller: controller.usernameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: kInputFill,
                            hintText: "User Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: kPrimary,
                            ),
                          ),
                          onChanged: (value) =>
                          controller.userName.value = value,
                          validator: (value) =>
                          value!.isEmpty ? 'Enter User Name' : null,
                        ),

                        const SizedBox(height: 20),

                        /// 🔹 Password
                        Obx(
                              () => TextFormField(
                            controller: controller.passwordController,
                            obscureText:
                            !controller.isPasswordVisible.value,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: kInputFill,
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: kPrimary,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: kPrimary,
                                ),
                                onPressed: () {
                                  controller.isPasswordVisible.value =
                                  !controller.isPasswordVisible.value;
                                },
                              ),
                            ),
                            onChanged: (value) =>
                            controller.password.value = value,
                            validator: (value) =>
                            value!.isEmpty ? 'Enter password' : null,
                          ),
                        ),

                        const SizedBox(height: 25),

                        /// 🔹 Login Button
                        Obx(
                              () => SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimary,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: controller.loginStatus.value ==
                                  LoginStatus.loading
                                  ? null
                                  : () async {
                                if (_formKey.currentState!
                                    .validate()) {
                                  await controller.login();
                                }
                              },
                              child: controller.loginStatus.value ==
                                  LoginStatus.loading
                                  ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text(
                                "LOGIN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),



                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// 🔹 Bottom decorations
            Align(
              alignment: const Alignment(0.9, 0.8),
              child: Opacity(
                opacity: 0.05,
                child: SvgPicture.asset(
                  "assets/images/graph6.svg",
                  width: 150,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.05,
                child: Image.asset(
                  "assets/images/barchart.png",
                  width: 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
