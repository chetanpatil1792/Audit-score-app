import 'package:get/get_navigation/src/routes/get_route.dart';
import '../features/audit/binding.dart';
import '../features/audit/view/AnnexureViewPage.dart';
import '../features/audit/view/AuditProcess.dart';
import '../features/audit/view/GoToAudit.dart';
import '../features/dashboard/binding.dart';
import '../features/dashboard/view/AboutUsPage.dart';
import '../features/dashboard/view/ContactUsPage.dart';
import '../features/dashboard/view/Dashboard.dart';
import '../features/dashboard/view/HelpPage.dart';
import '../features/login/Binding.dart';
import '../features/login/view/CreatePasscodeScreen.dart';
import '../features/login/view/ForgotPasscodeScreen.dart';
import '../features/login/view/PasscodeLoginScreen.dart';
import '../features/login/view/login_page.dart';
import '../features/login/view/splash_screen.dart';
import '../features/profile/view/UserProfilePage.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [

     GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginScreen(),
      binding: AuthBinding(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.CreatePasscodeView,
      page: () => CreatePasscodeScreen(),
      binding: PasscodeBinding(),
    ),
    GetPage(
      name: AppRoutes.PasscodeLoginView,
      page: () => PasscodeLoginScreen(),
      binding: PasscodeBinding(),
    ),
    GetPage(
      name: AppRoutes.ForgotPasscodeView,
      page: () => ForgotPasscodeScreen(),
      binding: PasscodeBinding(),
    ),


    //
    // // GetPage(
    // //   name: AppRoutes.HOME,
    // //   // page: () => HomePage(),
    // //   binding: HomeBinding(),
    // // ),
    GetPage(
      name: AppRoutes.DashboardView,
      page: () => Dashboard(),
      binding: DashboardBinding(),
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => UserProfilePage(),
     ),
      // GetPage(
    //   name: AppRoutes.NotificationPage,
    //   page: () => NotificationPage(),
    //   binding: NotificationBinding(),
    // ),
    //
    GetPage(
      name: AppRoutes.GoToAudit,
      page: () => GoToAudit(),
      binding: GotoAuditBinding(),
    ),
    GetPage(
      name: AppRoutes.AuditProcess,
      page: () => AuditProcess(),
      binding: AuditProcessBinding(),
    ),
    GetPage(
      name: AppRoutes.aboutUs,
      page: () => const AboutUsPage(),
    ),
    GetPage(
      name: AppRoutes.contactUs,
      page: () => ContactUsPage(),
    ),
    GetPage(
      name: AppRoutes.help,
      page: () => const HelpPage(),
    ),

    GetPage(
      name: AppRoutes.annexureViewPage,
      page: () => const AnnexureViewPage(),
    ),

  ];
}
