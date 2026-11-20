import 'package:flutter/material.dart';
import 'package:hall_mate/view/bottom_navigation_bar.dart';
import 'package:hall_mate/view/forgot_password_screen.dart';
import 'package:hall_mate/view/login_screen.dart';
import 'package:hall_mate/view/sign_up_screen.dart';
import 'package:hall_mate/view/splash_screen.dart';
import 'package:get/get.dart';

import 'controller/auth_controller.dart';

void main(){
  // Get.put(AuthController());
  runApp(Main());
}
class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        splashColor: Colors.transparent,
      ),
      // home: SplashScreen(),
      // home: LoginScreen(),
      // home: ForgotPasswordScreen(),
      // home: SignUpScreen(),
      home: NavBarWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}
