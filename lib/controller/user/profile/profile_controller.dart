import 'dart:io';

import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/controller/shared/nav_controller.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final AuthController auth = Get.find<AuthController>();

  // The logged-in customer (from the login)
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

  String role() {
    return auth.userRole();
  }

  // The photo taken with the camera (null = show the initials)
  Rxn<File> pickedImage = Rxn<File>();

  Future<void> openCamera() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      pickedImage.value = File(image.path);
    }
  }

  void openBookingsTab() {
    Get.find<NavController>().changeIndex(2);
  }

  void logOut() {
    pickedImage.value = null;
    auth.logOut();
  }
}
