import 'package:get/get.dart';

class FavouriteController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Saved venues screen.
  //
  // When you connect the API:
  //  - GET /favourites
  //  - Tapping a filter chip filters the list by venue type.
  //  - Tapping a heart removes the venue (DELETE /favourites/{id}).
  // ══════════════════════════════════════════════════════════

  // API: how many venues are saved
  String countText = '3 venues';

  // Which chip is selected (0 = All). Later: make it RxInt.
  int selectedFilterIndex = 0;
  List<String> filters = ['All', 'Banquet', 'Ballroom', 'Outdoor'];

  // API: GET /favourites ('photo' is DUMMY ONLY, a colour for the placeholder)
  List<Map<String, dynamic>> venues = [
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
      'name': 'Royal Palm Banquet',
      'rating': '4.4',
      'subtitle': 'Gulshan-e-Iqbal · up to 400 guests',
      'price': 'Rs 2,000',
      'tag': 'Banquet',
      'isFavorite': true,
      'photo': 'marigold',
    },
    {
      'name': 'Noor Ballroom',
      'rating': '4.7',
      'subtitle': 'Clifton · up to 350 guests',
      'price': 'Rs 3,100',
      'tag': 'Ballroom',
      'isFavorite': true,
      'photo': 'slate',
    },
  ];
}
