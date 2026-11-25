import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/nav_controller.dart';

// Named VenueSearchController because Flutter already has a class called
// SearchController, and two classes with the same name would clash.
class VenueSearchController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Search results screen.
  //
  // When you connect the API:
  //  - Send the filters as query parameters, for example
  //    GET /venues?type=banquet&area=gulshan&guests=300&date=2026-12-19
  //  - Fill `venues` from the response and update the title text,
  //    the "6 venues match" text and the filter count from it.
  // ══════════════════════════════════════════════════════════

  // API: the venue type that was searched
  String title = 'Banquet halls';

  // ══════════════════════════════════════════════════════════
  // SEARCH TEXT
  // ══════════════════════════════════════════════════════════

  // What the user typed in the search field. .obs because Obx watches it.
  RxString searchText = ''.obs;

  // Called on every letter typed (onChanged of the TextField).
  void updateSearch(String text) {
    searchText.value = text;
  }

  // The venues whose name OR area contains the typed text.
  // toLowerCase() makes "shaan" find "Shaan" too.
  // Later (API): GET /venues?search=shaan and show what comes back.
  List<Map<String, dynamic>> results() {
    final String typed = searchText.value.trim().toLowerCase();

    if (typed.isEmpty) {
      return venues; // nothing typed: show all
    }

    List<Map<String, dynamic>> found = [];
    for (var venue in venues) {
      final String name = venue['name'].toLowerCase();
      final String subtitle = venue['subtitle'].toLowerCase();
      if (name.contains(typed) || subtitle.contains(typed)) {
        found.add(venue);
      }
    }
    return found;
  }

  // "3 venues match your filters" (changes while you type)
  String resultText() {
    final int count = results().length;
    if (count == 1) {
      return '1 venue matches your filters';
    }
    return '$count venues match your filters';
  }

  // Message when nothing matches the typed text
  String emptyText() {
    return 'No venues match "${searchText.value.trim()}"';
  }

  // ══════════════════════════════════════════════════════════
  // FILTER CHIPS
  // ══════════════════════════════════════════════════════════

  // API: the filters the user chose. Each one is shown as a chip with an x.
  // .obs because Obx watches it (the chips and the orange badge).
  RxList<String> filterChips = <String>[
    'Gulshan-e-Iqbal',
    '300 guests',
    'Sat 19 Dec',
  ].obs;

  // Called when the x on a chip is tapped.
  // Later (API): load the venues again without this filter.
  void removeChip(int index) {
    filterChips.removeAt(index);
  }

  // ══════════════════════════════════════════════════════════
  // BACK ARROW
  // ══════════════════════════════════════════════════════════

  // Search is a tab, so "back" means: go to the Home tab (tab 0).
  void goToHomeTab() {
    Get.find<NavController>().changeIndex(0);
  }

  // API: the date and slot the user searched for
  String freeOnText = 'Free on Sat 19 Dec · Dinner';

  // Later: a sort menu (Recommended, Price, Rating ...)
  String sortText = 'Recommended';

  // API: GET /venues?... ('photo' is DUMMY ONLY, a colour for the placeholder)
  // Only 3 of the 6 venues are here (the Figma design shows 3).
  List<Map<String, dynamic>> venues = [
    {
      'name': 'Shaan Banquet Hall',
      'rating': '4.5',
      'subtitle': 'Gulshan-e-Iqbal · up to 500 guests · parking',
      'price': 'Rs 2,200',
      'tag': 'Dinner free · 19 Dec',
      'type': 'Banquet',
      'photo': 'emerald',
    },
    {
      'name': 'Royal Palm Banquet',
      'rating': '4.4',
      'subtitle': 'Gulshan-e-Iqbal · up to 400 guests · family hall',
      'price': 'Rs 2,000',
      'tag': 'Dinner free · 19 Dec',
      'type': 'Banquet',
      'photo': 'marigold',
    },
    {
      // GUESS: the end of the subtitle was cut off in Figma.
      'name': 'Al-Noor Banquet & Marquee',
      'rating': '4.2',
      'subtitle': 'Gulshan-e-Iqbal · up to 600 guests · parking',
      'price': 'Rs 1,900',
      'tag': 'Dinner free · 19 Dec',
      'type': 'Banquet',
      'photo': 'slate',
    },
  ];
}
