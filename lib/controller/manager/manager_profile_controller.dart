import 'dart:io';

import 'package:get/get.dart';
import 'package:hall_mate/controller/manager/manager_nav_controller.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:image_picker/image_picker.dart';

// The manager's own profile (the customer has a different one).
class ManagerProfileController extends GetxController {
  final AuthController auth = Get.find<AuthController>();
  final AppDataController data = Get.find<AppDataController>();

  String name() {
    return auth.userName();
  }

  String initials() {
    return auth.userInitials();
  }

  String email() {
    return auth.userEmail();
  }

  String phone() {
    return auth.userPhone();
  }

  VenueModel venue() {
    return data.venueById(auth.venueId());
  }

  Rxn<File> pickedImage = Rxn<File>();

  Future<void> openCamera() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      pickedImage.value = File(image.path);
    }
  }

  void openVenueTab() {
    Get.find<ManagerNavController>().changeIndex(2);
  }

  void logOut() {
    pickedImage.value = null;
    auth.logOut();
  }
}
