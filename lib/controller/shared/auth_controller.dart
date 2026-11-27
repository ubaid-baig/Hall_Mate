import 'package:get/get.dart';
import 'package:hall_mate/view/auth/login_screen.dart';

class AuthController extends GetxController {


  @override
  void onReady() {
    splashLoader();
    // TODO: implement onReady
    super.onReady();
  }

  RxBool isCheck = false.obs;

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

  void rememberMe(){
    isCheck.value = !isCheck.value;
  }

  Future<void> splashLoader() async {
    await Future.delayed(Duration(seconds: 3));
    // Get.offAll(LoginScreen());
  }

}