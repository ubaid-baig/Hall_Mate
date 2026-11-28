import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;


  ThemeMode themeMode = ThemeMode.system;

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

  Future<void> toggleTheme(bool value) async {
    isDarkMode.value = value;
    themeMode = value ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }
}
