import 'package:get/get.dart';

class ManagerDashboardController extends GetxController {
  /// Selected bottom navigation tab (0 = Dashboard).
  final RxInt currentTab = 0.obs;

  void changeTab(int index) => currentTab.value = index;
}