import 'package:get/get.dart';

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

  // API: build this from the number of results, e.g. '${venues.length} venues match your filters'
  String resultText = '6 venues match your filters';

  // API: how many filters are active (shown in the orange badge)
  int filterCount = 5;

  // API: the filters the user chose. Each one is shown as a chip with an x.
  // GUESS: the third chip was cut off in Figma.
  List<String> filterChips = [
    'Gulshan-e-Iqbal',
    '300 guests',
    'Sat 19 Dec',
  ];

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
      'isFavorite': true,
      'photo': 'emerald',
    },
    {
      'name': 'Royal Palm Banquet',
      'rating': '4.4',
      'subtitle': 'Gulshan-e-Iqbal · up to 400 guests · family hall',
      'price': 'Rs 2,000',
      'tag': 'Dinner free · 19 Dec',
      'isFavorite': true,
      'photo': 'marigold',
    },
    {
      // GUESS: the end of the subtitle was cut off in Figma.
      'name': 'Al-Noor Banquet & Marquee',
      'rating': '4.2',
      'subtitle': 'Gulshan-e-Iqbal · up to 600 guests · parking',
      'price': 'Rs 1,900',
      'tag': 'Dinner free · 19 Dec',
      'isFavorite': false,
      'photo': 'slate',
    },
  ];
}
