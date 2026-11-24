import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BallroomDetailsController extends GetxController {
  // Which chip is selected (index in the options list of the screen).
  final RxInt stageType = 0.obs; // 0 = Fixed stage
  final RxInt seatingLayout = 0.obs; // 0 = Round tables

  final stageSizeController = TextEditingController(text: '24 x 12 ft');

  final RxBool danceFloor = true.obs;
  final RxBool soundSystem = true.obs;
  final RxBool stageLighting = true.obs;

  void saveAndContinue() {
    // TODO: save the data, then open step 2 (Photos).
    // Get.to(VenuePhotosScreen());
  }

  @override
  void onClose() {
    stageSizeController.dispose();
    super.onClose();
  }
}