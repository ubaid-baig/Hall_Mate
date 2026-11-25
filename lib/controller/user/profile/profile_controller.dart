import 'package:get/get.dart';
import 'package:hall_mate/view/auth/login_screen.dart';
import 'package:hall_mate/controller/shared/nav_controller.dart';

class ProfileController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Profile screen.
  //
  // When you connect the API:
  //  - Fill these from GET /me (or from what you saved at login).
  // ══════════════════════════════════════════════════════════
  String initials = 'UB';
  String name = 'Ubaid Baig';
  String email = 'ubaid.baig@email.com';
  String phone = '+92 300 1234567';
  String role = 'Customer'; // API: Customer or Venue manager
  String cardEnding = '4242';
  String language = 'English';

  // The Notifications Switch. It is .obs because an Obx watches it.
  // Later: save it with shared preferences or send it to the API.
  RxBool isNotificationsOn = true.obs;

  void toggleNotifications(bool value) {
    isNotificationsOn.value = value;
  }

  // "Log out": back to the Login screen, and every screen behind is removed.
  // The bottom bar goes back to Home for next time.
  // Later (API): also delete the saved token (shared preferences).
  void logOut() {
    Get.find<NavController>().changeIndex(0);
    Get.offAll(() => const LoginScreen());
  }
}
