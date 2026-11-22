import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool isObscure = true.obs;

  // Sign up screen: true = "Venue manager" card is selected,
  // false = "Customer" card is selected. Obx on the screen watches it.
  // RxBool isVenueManager = true.obs;
  RxBool isVenueManager = false.obs;

  // Sign up screen: which venue type chip is selected.
  // Only matters when the user is a venue manager.
  RxString selectedVenueType = 'Banquet'.obs;

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

  void selectCustomer() {
    isVenueManager.value = false;
  }

  void selectVenueManager() {
    isVenueManager.value = true;
  }

  void selectVenueType(String type) {
    selectedVenueType.value = type;
  }
}