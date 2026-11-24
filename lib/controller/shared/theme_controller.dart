import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // The Switch on the Profile screen watches this with Obx, so it is .obs.
  RxBool isDarkMode = false.obs;

  // GetMaterialApp reads this when the app starts. No Obx watches it,
  // so it is a normal variable (not .obs).
  ThemeMode themeMode = ThemeMode.system;

  // Runs once in main() before the app opens.
  // - Nothing saved yet (first launch): follow the phone's setting.
  // - Something saved: use what the user picked last time.
  Future<void> loadSavedTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? saved = prefs.getBool('isDarkMode');

    if (saved == null) {
      themeMode = ThemeMode.system;
      isDarkMode.value =
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark;
    } else {
      themeMode = saved ? ThemeMode.dark : ThemeMode.light;
      isDarkMode.value = saved;
    }
  }

  // Called by the Switch. `value` is true when the user turns dark mode on.
  Future<void> toggleTheme(bool value) async {
    isDarkMode.value = value;
    themeMode = value ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }
}
