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
  // API: position of the selected photo and the total
  String counterText = '3 / 15';
  String venueName = 'Shaan Banquet Hall';

  // ── Big picture and its title ──
  String bigPhoto = 'marigold'; // DUMMY ONLY
  String bigLabel = 'Stage décor'; // DUMMY ONLY
  String photoTitle = 'Main stage · white & gold setup';
  String uploadedBy = 'Uploaded by the venue · Nov 2026';

  // ── Small pictures row ──
  // Which one is selected (index in the list). Later: make it RxInt.
  int selectedThumbIndex = 2;
  List<String> thumbs = ['emerald', 'marigold', 'marigold', 'slate', 'emerald'];

  // ── Tabs ──
  // Which tab is selected: 0 = Photos, 1 = Videos. Later: make it RxInt.
  int selectedTabIndex = 0;
  String photosTab = 'Photos (15)';
  String videosTab = 'Videos (1)';

  // ── Video row ──
  // API: the walkthrough video of the venue
  String videoTitle = 'Walkthrough video';
  String videoSubtitle = '2:14 · main hall to family hall';
}
