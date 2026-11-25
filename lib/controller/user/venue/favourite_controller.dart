import 'package:get/get.dart';

// ══════════════════════════════════════════════════════════
// ONE place for the user's saved venues.
//
// It is created ONCE in main.dart (Get.put), and every screen that shows
// a heart uses the SAME controller with Get.find:
//   Home, Search, Saved venues and Profile.
// So a heart tapped on Home shows up in Saved venues straight away.
//
// When you connect the API:
//  - Fill savedVenues from GET /favourites
//  - In toggleFavourite: POST /favourites/{id} to save,
//    DELETE /favourites/{id} to unsave.
//  - Compare venues by 'id' instead of 'name'.
// ══════════════════════════════════════════════════════════
class FavouriteController extends GetxController {
  // The saved venues. .obs because Obx on several screens watches it.
  // ('photo' is DUMMY ONLY, a colour for the placeholder)
  RxList<Map<String, dynamic>> savedVenues = <Map<String, dynamic>>[
    {
      'name': 'Shaan Banquet Hall',
      'rating': '4.5',
      'subtitle': 'Gulshan-e-Iqbal · up to 500 guests',
      'price': 'Rs 2,200',
      'type': 'Banquet',
      'photo': 'emerald',
    },
    {
      'name': 'Royal Palm Banquet',
      'rating': '4.4',
      'subtitle': 'Gulshan-e-Iqbal · up to 400 guests',
      'price': 'Rs 2,000',
      'type': 'Banquet',
      'photo': 'marigold',
    },
    {
      'name': 'Noor Ballroom',
      'rating': '4.7',
      'subtitle': 'Clifton · up to 350 guests',
      'price': 'Rs 3,100',
      'type': 'Ballroom',
      'photo': 'slate',
    },
  ].obs;

  // Is this venue saved? (true = red heart)
  bool isSaved(String name) {
    for (var venue in savedVenues) {
      if (venue['name'] == name) {
        return true;
      }
    }
    return false;
  }

  // Called when any heart is tapped.
  // Saved -> remove it. Not saved -> add it.
  void toggleFavourite(Map<String, dynamic> venue) {
    for (int i = 0; i < savedVenues.length; i++) {
      if (savedVenues[i]['name'] == venue['name']) {
        savedVenues.removeAt(i);
        return; // found and removed, stop here
      }
    }
    savedVenues.add(venue);
  }

  // ── Saved venues screen ──

  // The chips on top. Their text must match the venues' 'type'.
  List<String> filters = ['All', 'Banquet', 'Ballroom', 'Outdoor'];

  // Which chip is selected (0 = All). .obs because Obx watches it.
  RxInt selectedFilterIndex = 0.obs;

  void selectFilter(int index) {
    selectedFilterIndex.value = index;
  }

  // Only the saved venues of the selected chip (or all of them for "All").
  List<Map<String, dynamic>> filteredVenues() {
    if (selectedFilterIndex.value == 0) {
      return savedVenues;
    }
    final String selectedType = filters[selectedFilterIndex.value];
    List<Map<String, dynamic>> result = [];
    for (var venue in savedVenues) {
      if (venue['type'] == selectedType) {
        result.add(venue);
      }
    }
    return result;
  }

  // "3 venues" under the title
  String countText() {
    return '${savedVenues.length} venues';
  }

  // Message when a chip has no saved venues
  String emptyText() {
    if (selectedFilterIndex.value == 0) {
      return 'No saved venues yet. Tap a heart to save one.';
    }
    return 'No saved ${filters[selectedFilterIndex.value]} venues';
  }
}
