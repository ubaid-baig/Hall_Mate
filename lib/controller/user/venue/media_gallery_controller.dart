import 'package:get/get.dart';

class MediaGalleryController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Media gallery screen.
  //
  // When you connect the API:
  //  - GET /venues/{id}/media  (photos and videos of the venue)
  //  - The big picture shows the selected photo. Tapping a small picture
  //    changes it, and the title lines change with it.
  //  - 'photo' values below are DUMMY ONLY (a colour for the placeholder).
  //    With the API, show the real photo instead.
  // ══════════════════════════════════════════════════════════

  // ── Top bar ──
  String venueName = 'Shaan Banquet Hall';
  int totalPhotos = 15; // API: how many photos the venue has

  // ── The photos (small pictures row) ──
  // 'photo' is DUMMY ONLY (a colour). 'label' is written on the big picture,
  // 'title' is the line under it.
  List<Map<String, String>> thumbs = [
    {'photo': 'emerald', 'label': 'Main hall', 'title': 'Main hall · 500 seats'},
    {'photo': 'marigold', 'label': 'Entrance', 'title': 'Entrance · flower arch'},
    {'photo': 'marigold', 'label': 'Stage décor', 'title': 'Main stage · white & gold setup'},
    {'photo': 'slate', 'label': 'Family hall', 'title': 'Family hall · separate entry'},
    {'photo': 'emerald', 'label': 'Dining', 'title': 'Dining area · buffet line'},
  ];
  String uploadedBy = 'Uploaded by the venue · Nov 2026';

  // Which photo is selected. .obs because Obx shows it.
  RxInt selectedThumbIndex = 2.obs;

  // Called when a small picture is tapped
  void selectThumb(int index) {
    selectedThumbIndex.value = index;
  }

  // "3 / 15"
  String counterText() {
    return '${selectedThumbIndex.value + 1} / $totalPhotos';
  }

  // The selected photo (its photo, label and title)
  Map<String, String> selectedPhoto() {
    return thumbs[selectedThumbIndex.value];
  }

  // ── Tabs ──
  // Which tab is selected: 0 = Photos, 1 = Videos.
  RxInt selectedTabIndex = 0.obs;

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  String photosTab = 'Photos (15)';
  String videosTab = 'Videos (1)';

  // ── Video row ──
  // API: the walkthrough video of the venue
  String videoTitle = 'Walkthrough video';
  String videoSubtitle = '2:14 · main hall to family hall';
}
