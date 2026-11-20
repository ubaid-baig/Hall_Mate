import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool isObscure = true.obs;

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }
}