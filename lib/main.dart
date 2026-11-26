import 'package:flutter/material.dart';
import 'package:hall_mate/app/app_theme.dart';
import 'package:hall_mate/view/manager/venue_setup/ballroom_details.dart';
import 'package:hall_mate/view/user/booking/booking_detail_screen.dart';
import 'package:hall_mate/view/user/nav_bar_widget.dart';
import 'package:hall_mate/view/auth/forgot_password_screen.dart';
import 'package:hall_mate/view/auth/login_screen.dart';
import 'package:hall_mate/view/manager/venue_setup/outdoor_details.dart';
import 'package:hall_mate/view/auth/sign_up_screen.dart';
import 'package:hall_mate/view/auth/splash_screen.dart';
import 'package:hall_mate/view/user/home/home_screen.dart';
import 'package:hall_mate/view/manager/dashboard/manager_dashboard.dart';
import 'package:hall_mate/view/manager/dashboard/manager_dashboard_under_review.dart';
import 'package:get/get.dart';


import 'controller/shared/auth_controller.dart';
import 'controller/shared/nav_controller.dart';
import 'controller/shared/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Controllers are created once here, every screen then uses Get.find.
  Get.put(AuthController());
  Get.put(NavController());
  final ThemeController themeController = Get.put(ThemeController());

  await themeController.loadSavedTheme();

  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      // home: SplashScreen(),
      // home: LoginScreen(),
      // home: ForgotPasswordScreen(),
      // home: SignUpScreen(),
      // home: NavBarWidget(),
      // home:const ManagerDashboardScreen() ,
      // home: const ManagerDashboardReviewScreen(),
      home: const BallroomDetailsScreen(),
      // home: const VenueDetailsScreen(),
      // home: const OutdoorDetailsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
