import 'package:get/get.dart';

class NavController extends GetxController {
  // Which bottom tab is selected (0 = Home ... 4 = Profile).
  // Obx in the nav bar watches this, so it is .obs.
  RxInt currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
