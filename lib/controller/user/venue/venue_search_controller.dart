import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/nav_controller.dart';
import 'package:hall_mate/controller/user/venue/filters_controller.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/utils/app_format.dart';

class VenueSearchController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();
  FiltersController filters = Get.put(FiltersController());

  RxString searchText = ''.obs;

  void updateSearch(String text) {
    searchText.value = text;
  }

  // true if the venue passes ALL the checks
  bool matches(VenueModel venue) {
    // 1. Typed text: in the name or the area
    final String typed = searchText.value.trim().toLowerCase();
    if (typed.isNotEmpty) {
      final String name = venue.name.toLowerCase();
      final String area = venue.area.toLowerCase();
      if (!name.contains(typed) && !area.contains(typed)) {
        return false;
      }
    }

    // 2. Venue type
    final String type = filters.selectedType();
    if (type != '' && venue.type != type) {
      return false;
    }

    // 3. Date: the venue must be free on that day
    final DateTime? date = filters.selectedDate.value;
    if (date != null && data.isDateBooked(venue.id, date)) {
      return false;
    }

    // 4. Guests: the hall must fit this many
    if (filters.guests.value > 0 && venue.maxGuests < filters.guests.value) {
      return false;
    }

    // 5. Budget: the rent must not be higher
    if (filters.maxRent() > 0 && venue.rent > filters.maxRent()) {
      return false;
    }

    // 6. Amenities: the venue must have every chosen amenity
    for (var amenity in filters.selectedAmenities) {
      if (!venue.features.contains(amenity)) {
        return false;
      }
    }
    return true;
  }

  // The venues that pass every check
  List<VenueModel> results() {
    List<VenueModel> found = [];
    for (var venue in data.liveVenues()) {
      if (matches(venue)) {
        found.add(venue);
      }
    }
    return found;
  }

  // "3 venues match" (changes while you type or filter)
  String resultText() {
    final int count = results().length;
    if (count == 1) {
      return '1 venue matches';
    }
    return '$count venues match';
  }

  String emptyText() {
    return 'No venues match. Try other words or remove a filter.';
  }

  // Title: "Banquet venues" when a type is chosen, else "All venues"
  String title() {
    final String type = filters.selectedType();
    if (type == '') {
      return 'All venues';
    }
    return '$type venues';
  }

  // The line above the list
  String freeOnText() {
    if (filters.selectedDate.value == null) {
      return 'Any date · pick a date in Filters';
    }
    return 'Free on ${filters.dateText()}';
  }

  // One chip for every filter that is chosen
  List<Map<String, String>> activeChips() {
    List<Map<String, String>> chips = [];
    if (filters.selectedType() != '') {
      chips.add({'label': filters.selectedType(), 'kind': 'type'});
    }
    if (filters.selectedDate.value != null) {
      chips.add({'label': filters.dateText(), 'kind': 'date'});
    }
    if (filters.guests.value > 0) {
      chips.add({'label': '${filters.guests.value} guests', 'kind': 'guests'});
    }
    if (filters.maxRent() > 0) {
      chips.add({
        'label': 'Up to ${AppFormat.rupees(filters.maxRent())}',
        'kind': 'budget',
      });
    }
    for (var amenity in filters.selectedAmenities) {
      chips.add({'label': amenity, 'kind': 'amenity'});
    }
    return chips;
  }

  // Called when the x on a chip is tapped: clears that one choice
  void removeChip(Map<String, String> chip) {
    if (chip['kind'] == 'type') {
      filters.selectedTypeIndex.value = -1;
    } else if (chip['kind'] == 'date') {
      filters.selectedDate.value = null;
    } else if (chip['kind'] == 'guests') {
      filters.guests.value = 0;
    } else if (chip['kind'] == 'budget') {
      filters.selectedBudgetIndex.value = 0;
    } else if (chip['kind'] == 'amenity') {
      filters.selectedAmenities.remove(chip['label']);
    }
  }

  void goToHomeTab() {
    Get.find<NavController>().changeIndex(0);
  }
}
