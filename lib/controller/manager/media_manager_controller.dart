import 'package:get/get.dart';
import 'package:hall_mate/controller/manager/manager_nav_controller.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/view/manager/manager_nav_bar.dart';
import 'package:image_picker/image_picker.dart';

// Photos & videos of the manager's venue.
// Everything is saved into the shared venue, so customers see the new
// photos in Search, Venue detail and the Media gallery.
class MediaManagerController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();
  final AuthController auth = Get.find<AuthController>();

  VenueModel venue() {
    return data.venueById(auth.venueId());
  }

  // The grid has 3 tiles in a row. This cuts the list into rows of 3.
  List<List<MediaModel>> rows() {
    final List<MediaModel> all = venue().media;
    List<List<MediaModel>> result = [];
    for (int i = 0; i < all.length; i = i + 3) {
      final int end = i + 3 < all.length ? i + 3 : all.length;
      result.add(all.sublist(i, end));
    }
    return result;
  }

  bool isCover(MediaModel item) {
    return venue().cover() == item;
  }

  // Opens the phone's gallery. More than one photo can be picked.
  Future<void> addPhotos() async {
    ImagePicker picker = ImagePicker();
    List<XFile> files = await picker.pickMultiImage();
    if (files.isEmpty) {
      return; // nothing picked
    }

    final int start = venue().photos().length;
    List<MediaModel> items = [];
    for (int i = 0; i < files.length; i++) {
      items.add(
        MediaModel(title: 'Photo ${start + i + 1}', filePath: files[i].path),
      );
    }
    data.addMedia(venue(), items);
    Get.snackbar('Uploaded', '${files.length} photo(s) added');
  }

  // Opens the phone's gallery to pick one video.
  Future<void> addVideo() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickVideo(source: ImageSource.gallery);
    if (file == null) {
      return; // nothing picked
    }
    data.addMedia(venue(), [
      MediaModel(title: file.name, isVideo: true, filePath: file.path),
    ]);
    Get.snackbar('Uploaded', 'Your video was added');
  }

  void setCover(MediaModel item) {
    data.setCover(venue(), item);
    Get.snackbar('Cover changed', 'This photo now shows first in search');
  }

  void delete(MediaModel item) {
    data.deleteMedia(venue(), item);
    Get.snackbar('Deleted', '${item.title} was removed');
  }

  // Last step of the setup after sign up
  void finishSetup() {
    if (venue().photos().isEmpty) {
      Get.snackbar('Add a photo', 'Customers need at least one photo of your venue');
      return;
    }
    data.checkLive(venue());
    Get.find<ManagerNavController>().changeIndex(0);
    Get.offAll(() => const ManagerNavBar());
    Get.snackbar('Your venue is live', 'Customers can now find and book it');
  }
}
