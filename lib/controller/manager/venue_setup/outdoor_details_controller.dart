import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OutdoorDetailsController extends GetxController {
  final RxInt spaceType = 0.obs; // 0 = Lawn

  final lawnSizeController = TextEditingController(text: '40,000 sq ft');
  final rainPlanController = TextEditingController(
    text: 'A covered marquee for up to 300 guests can be set up within '
        '2 hours if rain is forecast.',
  );

  final RxBool tentsMarquee = true.obs;
  final RxBool backupGenerator = true.obs;
  final RxBool outdoorLighting = true.obs;

  void saveAndContinue() {
    // TODO: save the data, then open step 2 (Photos).
    // Get.to(VenuePhotosScreen());
  }

  @override
  void onClose() {
    lawnSizeController.dispose();
    rainPlanController.dispose();
    super.onClose();
  }
}