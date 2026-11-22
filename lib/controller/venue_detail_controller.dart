import 'package:get/get.dart';

class VenueDetailController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Venue detail screen.
  //
  // When you connect the API:
  //  - GET /venues/{id}  (the id comes from the venue card that was tapped)
  //  - Fill every variable below from that response.
  //  - Packages, dates and reviews are lists, so the screen draws one card
  //    for each item. Only the list changes.
  // ══════════════════════════════════════════════════════════

  // ── Cover photo ──
  // API: the cover photo of the venue (here only a coloured box)
  String photo = 'emerald'; // DUMMY ONLY: placeholder colour
  String coverLabel = 'Cover photo · main hall';
  // API: number of photos in the gallery
  String photoCountText = '1 / 15 photos';
  // API: show the video button only if the venue has a walkthrough video
  String videoText = 'Walkthrough video';
  // API: is this venue in the user's favourites?
  bool isFavorite = true;

  // ── Title area ──
  String type = 'Banquet'; // API: Ballroom, Banquet or Outdoor
  bool isVerified = true; // API: true when the admin has verified the venue
  String verifiedText = 'Verified by Hall Mate';
  String name = 'Shaan Banquet Hall';
  String location = 'Gulshan-e-Iqbal, Karachi';
  String rating = '4.5';
  String reviewsText = '(86 reviews)';

  // ── Feature tiles ──
  // API: the main facilities of the venue.
  // 'icon' decides the picture: guests, parking or family_hall
  List<Map<String, String>> features = [
    {'icon': 'guests', 'label': 'Up to 500 guests'},
    {'icon': 'parking', 'label': 'On-site parking'},
    {'icon': 'family_hall', 'label': 'Separate family hall'},
  ];

  // ── About ──
  String about =
      'A family-friendly banquet with in-house catering, a separate family hall and room for up to 500 guests. Ideal for walimas, mehndis and office dinners.';

  // ── Packages ──
  // API: the packages of the venue. 'isPopular' gives the green look and the pill.
  String minGuestsText = 'Min. 150 guests';
  List<Map<String, dynamic>> packages = [
    {
      'name': 'Silver',
      'price': 'Rs 2,200',
      'features': ['2 main dishes', 'Soft drinks', 'Standard stage'],
      'isPopular': false,
    },
    {
      'name': 'Gold',
      'price': 'Rs 2,800',
      'features': ['3 main dishes', 'Dessert bar', 'Premium décor'],
      'isPopular': true,
    },
  ];

  // ── Free dates ──
  // API: GET /venues/{id}/availability?month=2026-12
  // 'isLunchFree' / 'isDinnerFree': green bar when free, grey bar when booked.
  String freeDatesTitle = 'Free dates · Dec 2026';
  // Which day is selected (index in the list below). Later: make it RxInt.
  int selectedDateIndex = 5;
  List<Map<String, dynamic>> dates = [
    {'day': 'Mon', 'date': '14', 'isLunchFree': true, 'isDinnerFree': true},
    {'day': 'Tue', 'date': '15', 'isLunchFree': true, 'isDinnerFree': false},
    {'day': 'Wed', 'date': '16', 'isLunchFree': true, 'isDinnerFree': true},
    {'day': 'Thu', 'date': '17', 'isLunchFree': false, 'isDinnerFree': true},
    {'day': 'Fri', 'date': '18', 'isLunchFree': false, 'isDinnerFree': false},
    {'day': 'Sat', 'date': '19', 'isLunchFree': false, 'isDinnerFree': true},
    {'day': 'Sun', 'date': '20', 'isLunchFree': false, 'isDinnerFree': false},
  ];

  // The grey box under the days: it describes the selected day.
  // API: build these from the selected day's lunch / dinner status.
  String selectedDateText = 'Sat 19 Dec';
  String selectedDateNote = ' · Lunch booked';
  String selectedDateStatus = 'Dinner free';

  // ── Reviews ──
  // API: GET /venues/{id}/reviews  ('rating' is 1 to 5)
  // 'managerReply' can be null when the manager has not replied.
  String seeAllReviewsText = 'See all 86';
  List<Map<String, dynamic>> reviews = [
    {
      'initials': 'SK',
      'name': 'Sana Khan',
      'subtitle': 'Walima · Nov 2026',
      'rating': 5,
      'text':
          'The food was excellent and the staff handled 400 guests without any delay. The family hall was a big plus.',
      'managerReply': 'Thank you, Sana! It was a pleasure hosting your family.',
    },
  ];

  // ── Bottom bar ──
  // API: the lowest package price
  String fromPrice = 'Rs 2,200';
}
