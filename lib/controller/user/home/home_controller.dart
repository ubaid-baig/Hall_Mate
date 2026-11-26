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

  List<String> areas = [
    'Gulshan-e-Iqbal',
    'Clifton',
    'DHA',
    'North Nazimabad',
    'PECHS',
    'Bahadurabad',
  ];


  RxString selectedArea = 'Gulshan-e-Iqbal'.obs;

  void selectArea(String area) {
    selectedArea.value = area;
  }

  RxBool hasNewNotification = true.obs;

  void markNotificationsSeen() {
    hasNewNotification.value = false;
  }

  void openSearchTab() {
    Get.find<NavController>().changeIndex(1);
  }

  List<String> venueTypes = ['Ballroom', 'Banquet', 'Outdoor'];

  RxInt selectedTypeIndex = (-1).obs;

  void selectType(int index) {
    if (selectedTypeIndex.value == index) {
      selectedTypeIndex.value = -1;
    } else {
      selectedTypeIndex.value = index;
    }
  }

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

  String emptyText() {
    if (selectedTypeIndex.value == -1) {
      return 'No venues yet';
    }
    return 'No ${venueTypes[selectedTypeIndex.value]} venues here yet';
  }

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