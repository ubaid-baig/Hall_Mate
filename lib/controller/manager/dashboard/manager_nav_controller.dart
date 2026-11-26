import 'package:get/get.dart';

/// Remembers which bottom tab of the manager app is selected.
/// 0 = Dashboard, 1 = Requests, 2 = Calendar, 3 = Chat, 4 = Profile
class ManagerNavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeIndex(int index) => currentIndex.value = index;

  /// Switch tab from ANY screen:  ManagerNavController.goToTab(2);
  /// (does nothing if the manager nav bar is not on screen)
  static void goToTab(int index) {
    if (Get.isRegistered<ManagerNavController>()) {
      Get.find<ManagerNavController>().changeIndex(index);
    }
  }
}