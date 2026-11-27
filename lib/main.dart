import 'package:flutter/material.dart';
import 'package:hall_mate/app/app_theme.dart';
import 'package:hall_mate/controller/user/venue/favourite_controller.dart';
import 'package:get/get.dart';
import 'package:hall_mate/view/manager/venue_setup/ballroom_details.dart';
import 'controller/shared/auth_controller.dart';
import 'controller/shared/nav_controller.dart';
import 'controller/shared/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Controllers are created once here, every screen then uses Get.find.
  Get.put(AuthController());
  Get.put(NavController());

  

  Get.put(FavouriteController());

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
      home: const BallroomDetailsScreen(),


      debugShowCheckedModeBanner: false,
    );
  }
}
