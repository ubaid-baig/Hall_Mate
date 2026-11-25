import 'package:get/get.dart';

import '../../shared/nav_controller.dart';


class HomeController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Home screen.
  //
  // When you connect the API:
  //  1. Keep the same variable names, but turn the lists into
  //     RxList (.obs) or call update() after loading, so the screen refreshes.
  //  2. Load the data from the API inside onInit() (see the bottom).
  //  3. Every Map below has the same keys as the card needs:
  //     name, rating, subtitle, price, tag, type, photo.
  //     Later you can replace the Map with a VenueModel.
  // ══════════════════════════════════════════════════════════

  // API: the logged-in user's name (from login response or profile API)
  String userName = 'Ali';

  // ══════════════════════════════════════════════════════════
  // LOCATION (the row at the top)
  // ══════════════════════════════════════════════════════════

  // The areas shown in the location bottom sheet.
  // Later (API): GET /areas
  List<String> areas = [
    'Gulshan-e-Iqbal',
    'Clifton',
    'DHA',
    'North Nazimabad',
    'PECHS',
    'Bahadurabad',
  ];

  // The area the user picked. Obx shows it in the top row, so it is .obs.
  // API: the user's saved area
  RxString selectedArea = 'Gulshan-e-Iqbal'.obs;

  // Called when an area is tapped in the bottom sheet.
  // Later (API): save it, and load the "Near you" venues for this area.
  void selectArea(String area) {
    selectedArea.value = area;
  }

  // ══════════════════════════════════════════════════════════
  // NOTIFICATIONS DOT
  // ══════════════════════════════════════════════════════════

  // true = show the orange dot on the bell. Obx watches it, so it is .obs.
  // API: true when the user has unread notifications
  RxBool hasNewNotification = true.obs;

  // Called when the bell is tapped: the user has now seen them.
  // Later (API): mark them as read on the server.
  void markNotificationsSeen() {
    hasNewNotification.value = false;
  }

  // ══════════════════════════════════════════════════════════
  // SEARCH TAB
  // ══════════════════════════════════════════════════════════

  // The search field and "See all" open the Search tab (tab number 1).
  // NavController was created in main.dart, so we find it with Get.find.
  void openSearchTab() {
    Get.find<NavController>().changeIndex(1);
  }

  // The hearts (saved venues) are in FavouriteController, so that Home,
  // Search, Saved venues and Profile all share ONE list.

  // ══════════════════════════════════════════════════════════
  // BROWSE BY TYPE
  // ══════════════════════════════════════════════════════════

  // The three tiles, in order. Each text must match the 'type' of the venues.
  List<String> venueTypes = ['Ballroom', 'Banquet', 'Outdoor'];

  // Which tile is selected: 0 Ballroom, 1 Banquet, 2 Outdoor.
  // -1 means no tile is selected, so every venue shows.
  // It is .obs because Obx on the Home screen watches it.
  // (-1) needs brackets, because -1.obs would mean "minus (1.obs)".
  RxInt selectedTypeIndex = (-1).obs;

  // Called when a tile is tapped.
  // Tapping the selected tile again removes the filter.
  void selectType(int index) {
    if (selectedTypeIndex.value == index) {
      selectedTypeIndex.value = -1;
    } else {
      selectedTypeIndex.value = index;
    }
  }

  // Gives back only the venues of the selected type.
  // If no tile is selected, it gives back the whole list.
  // Later (API): the server can do this for you, for example
  // GET /venues?type=Banquet, and you show what it returns.
  List<Map<String, dynamic>> filterByType(List<Map<String, dynamic>> venues) {
    if (selectedTypeIndex.value == -1) {
      return venues;
    }

    final String selectedType = venueTypes[selectedTypeIndex.value];
    List<Map<String, dynamic>> result = [];

    for (var venue in venues) {
      if (venue['type'] == selectedType) {
        result.add(venue);
      }
    }
    return result;
  }

  // The text shown when a type has no venues in a list.
  String emptyText() {
    if (selectedTypeIndex.value == -1) {
      return 'No venues yet';
    }
    return 'No ${venueTypes[selectedTypeIndex.value]} venues here yet';
  }

  // ══════════════════════════════════════════════════════════
  // VENUE LISTS
  // ══════════════════════════════════════════════════════════

  // API: GET /venues?featured=true
  // 'photo' is DUMMY ONLY (a colour for the placeholder). With the API,
  // show the venue's real photo instead.
  List<Map<String, dynamic>> featuredVenues = [
    {
      'name': 'Shaan Banquet Hall',
      'rating': '4.5',
      'subtitle': 'Gulshan-e-Iqbal · up to 500 guests',
      'price': 'Rs 2,200',
      'tag': 'Banquet',
      'type': 'Banquet',
      'photo': 'emerald',
    },
    {
      'name': 'Noor Ballroom',
      'rating': '4.7',
      'subtitle': 'Clifton · up to 350 guests',
      'price': 'Rs 3,100',
      'tag': 'Ballroom',
      'type': 'Ballroom',
      'photo': 'marigold',
    },
    {
      // DUMMY: added so every type has a featured venue to test with
      'name': 'Seaside Garden Lawn',
      'rating': '4.2',
      'subtitle': 'DHA Phase 8 · up to 1,000 guests',
      'price': 'Rs 1,600',
      'tag': 'Outdoor',
      'type': 'Outdoor',
      'photo': 'slate',
    },
  ];

  // API: GET /venues?sort=nearest
  List<Map<String, dynamic>> nearbyVenues = [
    {
      'name': 'Gulshan Garden Lawn',
      'rating': '4.3',
      'subtitle': 'Outdoor · 1.4 km · up to 800 guests',
      'price': 'Rs 1,800',
      'type': 'Outdoor',
      'photo': 'slate',
    },
    {
      'name': 'Royal Palm Banquet',
      'rating': '4.4',
      'subtitle': 'Banquet · 2.6 km · up to 400 guests',
      'price': 'Rs 2,000',
      'type': 'Banquet',
      'photo': 'emerald',
    },
    {
      // DUMMY: added so every type has a nearby venue to test with
      'name': 'Crystal Ballroom',
      'rating': '4.6',
      'subtitle': 'Ballroom · 3.2 km · up to 300 guests',
      'price': 'Rs 2,800',
      'type': 'Ballroom',
      'photo': 'marigold',
    },
  ];

// @override
// void onInit() {
//   // API: call your functions here, for example getFeaturedVenues();
//   super.onInit();
// }
}