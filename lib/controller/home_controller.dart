import 'package:get/get.dart';

class HomeController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Home screen.
  //
  // When you connect the API:
  //  1. Keep the same variable names, but turn the lists into
  //     RxList (.obs) or call update() after loading, so the screen refreshes.
  //  2. Load the data from the API inside onInit() (see the bottom).
  //  3. Every Map below has the same keys as the card needs:
  //     name, rating, subtitle, price, tag, isFavorite, photo.
  //     Later you can replace the Map with a VenueModel.
  // ══════════════════════════════════════════════════════════

  // API: the logged-in user's name (from login response or profile API)
  String userName = 'Ali';

  // API: the user's saved city / area
  String location = 'Gulshan-e-Iqbal, Karachi';

  // API: true when the user has unread notifications (shows the orange dot)
  bool hasNewNotification = true;

  // Which "Browse by type" tile is selected: 0 Ballroom, 1 Banquet, 2 Outdoor.
  // Later: make it RxInt and change it when a tile is tapped.
  int selectedTypeIndex = 1;

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
      'isFavorite': true,
      'photo': 'emerald',
    },
    {
      // GUESS: rating, guests and price were cut off in the Figma design.
      'name': 'Noor Ballroom',
      'rating': '4.7',
      'subtitle': 'Clifton · up to 700 guests',
      'price': 'Rs 3,500',
      'tag': 'Ballroom',
      'isFavorite': false,
      'photo': 'marigold',
    },
  ];

  // API: GET /venues?sort=nearest
  List<Map<String, dynamic>> nearbyVenues = [
    {
      'name': 'Gulshan Garden Lawn',
      'rating': '4.3',
      'subtitle': 'Outdoor · 1.4 km · up to 800 guests',
      'price': 'Rs 1,800',
      'photo': 'slate',
    },
    {
      'name': 'Royal Palm Banquet',
      'rating': '4.4',
      'subtitle': 'Banquet · 2.6 km · up to 400 guests',
      'price': 'Rs 2,000',
      'photo': 'emerald',
    },
  ];

  // @override
  // void onInit() {
  //   // API: call your functions here, for example getFeaturedVenues();
  //   super.onInit();
  // }
}
