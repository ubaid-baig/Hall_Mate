import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VenueDetailsController extends GetxController {
  // ---------- Text fields ----------
  final nameController = TextEditingController(text: 'Shaan Banquet Hall');
  final areaController = TextEditingController(text: 'Gulshan-e-Iqbal, Karachi');
  final addressController = TextEditingController();
  final maxGuestsController = TextEditingController(text: '500');
  final minGuestsController = TextEditingController(text: '150');
  final aboutController = TextEditingController(
    text: 'A family-friendly banquet with in-house catering, a separate '
        'family hall and room for up to 500 guests. Ideal for walimas, '
        'mehndis and office dinners.',
  );

  static const int aboutMaxLength = 600;

  // ---------- Switches ----------
  final RxBool inHouseCatering = true.obs;
  final RxBool separateFamilyHall = true.obs;
  final RxBool onSiteParking = true.obs;

  // ---------- Live character counter ----------
  final RxInt aboutLength = 0.obs;

  @override
  void onInit() {
    super.onInit();
    aboutLength.value = aboutController.text.length;
    aboutController.addListener(() {
      aboutLength.value = aboutController.text.length;
    });
  }

  void saveDraft() {
    // TODO: save the data without moving to the next step.
    Get.snackbar('Saved', 'Your draft has been saved.');
  }

  void saveAndContinue() {
    // TODO: save the data, then open step 2 (Photos).
    // Get.to(VenuePhotosScreen());
  }

  @override
  void onClose() {
    nameController.dispose();
    areaController.dispose();
    addressController.dispose();
    maxGuestsController.dispose();
    minGuestsController.dispose();
    aboutController.dispose();
    super.onClose();
  }
}