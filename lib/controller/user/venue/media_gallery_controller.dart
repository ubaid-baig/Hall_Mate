import 'package:get/get.dart';
import 'package:hall_mate/model/venue_model.dart';

class MediaGalleryController extends GetxController {
  // startTab: 0 = open on Photos, 1 = open on Videos
  MediaGalleryController({int startTab = 0}) {
    selectedTabIndex.value = startTab;
  }

  // Which tab is selected: 0 = Photos, 1 = Videos
  RxInt selectedTabIndex = 0.obs;

  // Which photo / video is shown big
  RxInt selectedIndex = 0.obs;

  void selectTab(int index) {
    selectedTabIndex.value = index;
    selectedIndex.value = 0;
  }

  void selectItem(int index) {
    selectedIndex.value = index;
  }

  // The photos or the videos, depending on the tab
  List<MediaModel> items(VenueModel venue) {
    if (selectedTabIndex.value == 0) {
      return venue.photos();
    }
    return venue.videos();
  }

  // The item shown big, or null when the tab is empty
  MediaModel? selectedItem(VenueModel venue) {
    final List<MediaModel> list = items(venue);
    if (list.isEmpty) {
      return null;
    }
    // If the manager deleted a file, the index may be too big now
    if (selectedIndex.value >= list.length) {
      return list.first;
    }
    return list[selectedIndex.value];
  }

  // "3 / 15"
  String counterText(VenueModel venue) {
    final int total = items(venue).length;
    if (total == 0) {
      return '0 / 0';
    }
    return '${selectedIndex.value + 1} / $total';
  }

  String photosTab(VenueModel venue) {
    return 'Photos (${venue.photos().length})';
  }

  String videosTab(VenueModel venue) {
    return 'Videos (${venue.videos().length})';
  }

  void playVideo() {
    Get.snackbar('Video', 'Playing videos inside the app comes later');
  }
}
