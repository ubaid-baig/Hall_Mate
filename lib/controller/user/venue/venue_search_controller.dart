import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/nav_controller.dart';
import 'package:hall_mate/controller/user/venue/filters_controller.dart';

// Named VenueSearchController because Flutter already has a class called
// SearchController, and two classes with the same name would clash.
class VenueSearchController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // The Search tab.
  //
  // The list is filtered by:
  //  1. the text typed in the search field
  //  2. the choices in the Filters sheet (FiltersController)
  //
  // When you connect the API:
  //  GET /venues?search=...&type=...&guests=...&amenities=...
  //  and show what comes back instead of filtering here.
  // ══════════════════════════════════════════════════════════

  // The Filters sheet uses the same controller (Get.put gives back the
  // one that already exists), so both read the same choices.
  FiltersController filters = Get.put(FiltersController());

  // API: GET /venues ('photo' is DUMMY ONLY, a colour for the placeholder)
  // 'maxGuests' and 'amenities' are used by the filters.
  List<Map<String, dynamic>> venues = [
    {
      'name': 'Shaan Banquet Hall',
      'rating': '4.5',
      'subtitle': 'Gulshan-e-Iqbal · up to 500 guests · parking',
      'price': 'Rs 2,200',
      'tag': 'Banquet',
      'type': 'Banquet',
      'maxGuests': 500,
      'amenities': ['Parking', 'Family hall', 'In-house catering'],
      'photo': 'emerald',
    },
    {
      'name': 'Royal Palm Banquet',
      'rating': '4.4',
      'subtitle': 'Gulshan-e-Iqbal · up to 400 guests · family hall',
      'price': 'Rs 2,000',
      'tag': 'Banquet',
      'type': 'Banquet',
      'maxGuests': 400,
      'amenities': ['Family hall', 'Generator'],
      'photo': 'marigold',
    },
    {
      'name': 'Al-Noor Banquet & Marquee',
      'rating': '4.2',
      'subtitle': 'Gulshan-e-Iqbal · up to 600 guests · parking',
      'price': 'Rs 1,900',
      'tag': 'Banquet',
      'type': 'Banquet',
      'maxGuests': 600,
      'amenities': ['Parking', 'Generator'],
      'photo': 'slate',
    },
    {
      'name': 'Noor Ballroom',
      'rating': '4.7',
      'subtitle': 'Clifton · up to 350 guests · valet',
      'price': 'Rs 3,100',
      'tag': 'Ballroom',
      'type': 'Ballroom',
      'maxGuests': 350,
      'amenities': ['Valet', 'Parking', 'In-house catering'],
      'photo': 'marigold',
    },
    {
      'name': 'Gulshan Garden Lawn',
      'rating': '4.3',
      'subtitle': 'Gulshan-e-Iqbal · up to 800 guests · generator',
      'price': 'Rs 1,800',
      'tag': 'Outdoor',
      'type': 'Outdoor',
      'maxGuests': 800,
      'amenities': ['Parking', 'Generator'],
      'photo': 'slate',
    },
  ];

  RxString searchText = ''.obs;

  void updateSearch(String text) {
    searchText.value = text;
  }

  // true if the venue passes ALL the checks
  bool matches(Map<String, dynamic> venue) {
    // 1. Typed text: in the name or the area
    final String typed = searchText.value.trim().toLowerCase();
    if (typed.isNotEmpty) {
      final String name = venue['name'].toLowerCase();
      final String subtitle = venue['subtitle'].toLowerCase();
      if (!name.contains(typed) && !subtitle.contains(typed)) {
        return false;
      }
    }

    // 2. Venue type
    final String type = filters.selectedType();
    if (type != '' && venue['type'] != type) {
      return false;
    }

    // 3. Guests: the hall must fit this many
    if (filters.guests.value > 0 && venue['maxGuests'] < filters.guests.value) {
      return false;
    }

    // 4. Amenities: the venue must have every chosen amenity
    for (var amenity in filters.selectedAmenities) {
      final List venueAmenities = venue['amenities'];
      if (!venueAmenities.contains(amenity)) {
        return false;
      }
    }

    // (The date is only shown as a chip for now.
    //  Later the API will tell which venues are free on that date.)
    return true;
  }

  // The venues that pass every check
  List<Map<String, dynamic>> results() {
    List<Map<String, dynamic>> found = [];
    for (var venue in venues) {
      if (matches(venue)) {
        found.add(venue);
      }
    }
    return found;
  }

  // "3 venues match your filters" (changes while you type or filter)
  String resultText() {
    final int count = results().length;
    if (count == 1) {
      return '1 venue matches';
    }
    return '$count venues match';
  }

  // Message when nothing matches
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
    if (filters.dateText.value == '') {
      return 'Any date';
    }
    return 'Free on ${filters.dateText.value} · '
        '${filters.slots[filters.selectedSlotIndex.value]}';
  }

  // Later: a sort menu (Recommended, Price, Rating ...)
  String sortText = 'Recommended';

  // ══════════════════════════════════════════════════════════
  // FILTER CHIPS (made from the choices in the Filters sheet)
  // ══════════════════════════════════════════════════════════

  // One chip for every choice. 'kind' tells removeChip what to clear.
  // Nothing chosen = no chips.
  List<Map<String, String>> activeChips() {
    List<Map<String, String>> chips = [];

    if (filters.selectedType() != '') {
      chips.add({'label': filters.selectedType(), 'kind': 'type'});
    }
    if (filters.dateText.value != '') {
      chips.add({
        'label':
            '${filters.dateText.value} · ${filters.slots[filters.selectedSlotIndex.value]}',
        'kind': 'date',
      });
    }
    if (filters.guests.value > 0) {
      chips.add({'label': '${filters.guests.value} guests', 'kind': 'guests'});
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
      filters.dateText.value = '';
    } else if (chip['kind'] == 'guests') {
      filters.guests.value = 0;
    } else if (chip['kind'] == 'amenity') {
      filters.selectedAmenities.remove(chip['label']);
    }
  }

  // ══════════════════════════════════════════════════════════
  // BACK ARROW
  // ══════════════════════════════════════════════════════════

  // Search is a tab, so "back" means: go to the Home tab (tab 0).
  void goToHomeTab() {
    Get.find<NavController>().changeIndex(0);
  }
}
