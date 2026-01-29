import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart'; // Aapka primaryDarkBlue yahan se aayega
import '../../../routes/app_routes.dart';
import '../controller/PasscodeController.dart';
import '../controller/login_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final PasscodeController passcodeController = Get.put(PasscodeController());
  final LoginController loginController = Get.put(LoginController());

  late AnimationController _mainController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _letterSpacingAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // 1. Fade In Animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    // 2. Letter Spacing Animation (Premium feel ke liye naam thoda expand hoga)
    _letterSpacingAnimation = Tween<double>(begin: 2.0, end: 12.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.2, 0.8, curve: Curves.easeOutQuart)),
    );

    // 3. Shimmer Effect Animation
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.4, 1.0, curve: Curves.linear)),
    );

    _mainController.forward();
    _navigateAfterDelay();
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    await checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final accessToken = await secureStorage.read(key: 'access_token');
    final refreshToken = await secureStorage.read(key: 'refresh_token');

    if (accessToken != null && accessToken.isNotEmpty) {
      passcodeController.checkPasscodeStatusAndBiometrics();
      if (passcodeController.isPasscodeSet.value) {
        Get.offAllNamed(AppRoutes.PasscodeLoginView);
        passcodeController.authenticateWithBiometrics();
      } else {
        Get.offAllNamed(AppRoutes.CreatePasscodeView);
      }
    } else if (refreshToken != null && refreshToken.isNotEmpty) {
      final success = await loginController.refreshAccessToken(refreshToken);
      if (success) {
        passcodeController.checkPasscodeStatusAndBiometrics();
        if (passcodeController.isPasscodeSet.value) {
          Get.offAllNamed(AppRoutes.PasscodeLoginView);
        } else {
          Get.offAllNamed(AppRoutes.CreatePasscodeView);
        }
      } else {
        await loginController.logout();
      }
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDarkBlue, // Dashboard wali theme
      body: Stack(
        children: [
          // Background subtle design (Optional: Dashboard style circular accent)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),

          Center(
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Text "Score"
                      ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.9),
                              Colors.white.withOpacity(0.4),
                              Colors.white.withOpacity(0.9),
                            ],
                            stops: [
                              _shimmerAnimation.value - 0.3,
                              _shimmerAnimation.value,
                              _shimmerAnimation.value + 0.3,
                            ],
                          ).createShader(rect);
                        },
                        child: Text(
                          "SCORE",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: _letterSpacingAnimation.value,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Subtitle with tracking animation
                      Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          "SMART AUDITING SYSTEM",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.white.withOpacity(0.7),
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom loading indicator (Dashboard color matched)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: const SizedBox(
                  width: 40,
                  height: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}