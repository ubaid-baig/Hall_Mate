import 'package:flutter/material.dart';
import 'package:hall_mate/app/app_theme.dart';
import 'package:hall_mate/view/ballroom_details.dart';
import 'package:hall_mate/view/booking_detail_screen.dart';
import 'package:hall_mate/view/nav_bar_widget.dart';
import 'package:hall_mate/view/forgot_password_screen.dart';
import 'package:hall_mate/view/login_screen.dart';
import 'package:hall_mate/view/outdoor_details.dart';
import 'package:hall_mate/view/sign_up_screen.dart';
import 'package:hall_mate/view/splash_screen.dart';
import 'package:hall_mate/view/home_screen.dart';
import 'package:hall_mate/view/manager_dashboard.dart';
import 'package:hall_mate/view/manager_dashboard_under_review.dart';
import 'package:hall_mate/view/venue_details_screen.dart';
import 'package:get/get.dart';


import 'controller/auth_controller.dart';
import 'controller/nav_controller.dart';
import 'controller/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Controllers are created once here, every screen then uses Get.find.
  Get.put(AuthController());
  Get.put(NavController());
  final ThemeController themeController = Get.put(ThemeController());

  // Read the saved theme BEFORE the app opens, so there is no light/dark flash.
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
