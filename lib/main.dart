import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/app/app_theme.dart';
import 'package:hall_mate/controller/manager/manager_nav_controller.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/controller/shared/nav_controller.dart';
import 'package:hall_mate/controller/shared/theme_controller.dart';
import 'package:hall_mate/controller/user/venue/favourite_controller.dart';
import 'package:hall_mate/view/auth/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Controllers are created once here, every screen then uses Get.find.
  // AppDataController comes first: it holds the data both sides share.
  Get.put(AppDataController());
  Get.put(NavController());
  Get.put(ManagerNavController());
  Get.put(FavouriteController());
  Get.put(AuthController());

  final ThemeController themeController = Get.put(ThemeController());
  await themeController.loadSavedTheme();

  runApp(const Main());
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
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
