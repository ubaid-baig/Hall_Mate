import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/model/venue_model.dart';

// The saved venues (the hearts). Created once in main.dart,
// because Home, Search, Venue detail, Saved venues and Profile all use it.
class FavouriteController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();

  // DUMMY DATA: the saved venues of every customer (by name)
  Map<String, List<String>> savedByCustomer = {
    'Ali Raza': ['v1', 'v2', 'v4'],
  };

  // The saved venues of the customer who is logged in.
  // Only the ids are saved. The venue itself comes from the shared list,
  // so a change by the manager (new photo, new rent) shows here too.
  RxList<String> savedIds = <String>[].obs;

  String customerName = '';

  // Called after login: shows this customer's hearts
  void loadFor(String name) {
    customerName = name;
    savedIds.assignAll(savedByCustomer[name] ?? []);
  }

  // Is this venue saved? (true = red heart)
  bool isSaved(String venueId) {
    return savedIds.contains(venueId);
  }

  // Called when any heart is tapped.
  // Saved -> remove it. Not saved -> add it.
  void toggleFavourite(String venueId) {
    if (savedIds.contains(venueId)) {
      savedIds.remove(venueId);
    } else {
      savedIds.add(venueId);
    }
    // Remember it for this customer (for the next login)
    savedByCustomer[customerName] = List<String>.from(savedIds);
  }

  List<VenueModel> savedVenues() {
    List<VenueModel> result = [];
    for (var id in savedIds) {
      result.add(data.venueById(id));
    }
    return result;
  }

  // ── Saved venues screen ──
  // The chips on top. Their text must match the venues' type.
  List<String> filters = ['All', 'Banquet', 'Ballroom', 'Outdoor'];

  RxInt selectedFilterIndex = 0.obs;

  void selectFilter(int index) {
    selectedFilterIndex.value = index;
  }

  // Only the saved venues of the selected chip (or all of them for "All")
  List<VenueModel> filteredVenues() {
    if (selectedFilterIndex.value == 0) {
      return savedVenues();
    }
    final String selectedType = filters[selectedFilterIndex.value];
    List<VenueModel> result = [];
    for (var venue in savedVenues()) {
      if (venue.type == selectedType) {
        result.add(venue);
      }
    }
    return result;
  }

  // "3 venues" under the title
  String countText() {
    if (savedIds.length == 1) {
      return '1 venue';
    }
    return '${savedIds.length} venues';
  }

  String emptyText() {
    if (selectedFilterIndex.value == 0) {
      return 'No saved venues yet. Tap a heart to save one.';
    }
    return 'No saved ${filters[selectedFilterIndex.value]} venues';
  }
}
