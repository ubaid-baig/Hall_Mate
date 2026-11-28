import 'package:get/get.dart';

// Remembers which bottom tab of the manager app is selected.
// 0 = Dashboard, 1 = Requests, 2 = My venue, 3 = Chat, 4 = Profile
// (the same idea as NavController on the customer side)
class ManagerNavController extends GetxController {
  RxInt currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
