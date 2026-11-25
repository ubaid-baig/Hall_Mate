import 'package:get/get.dart';

class BookingsController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the My bookings screen.
  //
  // When you connect the API:
  //  - GET /bookings (send the selected status as a query parameter,
  //    or filter the list here).
  //  - The counts on the chips can be counted from the list.
  //  - 'status' decides the colour of the status chip. Use exactly:
  //    Requested, Negotiating, Accepted, Confirmed, Completed.
  // ══════════════════════════════════════════════════════════

  // The chips. Each one (except All) is a status.
  List<String> filters = [
    'All',
    'Requested',
    'Negotiating',
    'Confirmed',
    'Completed',
  ];

  // Which chip is selected (0 = All). .obs because Obx watches it.
  RxInt selectedFilterIndex = 0.obs;

  void selectFilter(int index) {
    selectedFilterIndex.value = index;
  }

  // The number on a chip: how many bookings have that status
  String countFor(int index) {
    if (index == 0) {
      return '${bookings.length}';
    }
    int count = 0;
    for (var booking in bookings) {
      if (booking['status'] == filters[index]) {
        count = count + 1;
      }
    }
    return '$count';
  }

  // Only the bookings of the selected chip (or all of them)
  List<Map<String, dynamic>> filteredBookings() {
    if (selectedFilterIndex.value == 0) {
      return bookings;
    }
    List<Map<String, dynamic>> result = [];
    for (var booking in bookings) {
      if (booking['status'] == filters[selectedFilterIndex.value]) {
        result.add(booking);
      }
    }
    return result;
  }

  // API: GET /bookings
  // 'infoText' is the small line on the left of the button.
  // 'buttonText' and 'isButtonFilled' depend on the status.
  // 'photo' is DUMMY ONLY (a colour for the placeholder).
  List<Map<String, dynamic>> bookings = [
    {
      'venueName': 'Shaan Banquet Hall',
      'details': 'Sat 19 Dec 2026 · Dinner · 300 guests',
      'status': 'Negotiating',
      'infoText': 'New counter: Rs 2,600 / head',
      'buttonText': 'Reply',
      'isButtonFilled': true,
      'photo': 'emerald',
    },
    {
      'venueName': 'Royal Palm Banquet',
      'details': 'Sun 3 Jan 2027 · Lunch · 150 guests',
      'status': 'Requested',
      'infoText': 'Waiting for reply · 18 h left',
      'buttonText': 'View',
      'isButtonFilled': false,
      'photo': 'marigold',
    },
    {
      'venueName': 'Gulshan Garden Lawn',
      'details': 'Fri 15 Jan 2027 · Dinner · 220 guests',
      'status': 'Confirmed',
      'infoText': 'Advance paid · Rs 99,000',
      'buttonText': 'Receipt',
      'isButtonFilled': false,
      'photo': 'slate',
    },
    {
      'venueName': 'Noor Ballroom',
      'details': 'Sat 7 Nov 2026 · Dinner · 120 guests',
      'status': 'Completed',
      'infoText': 'How was your event?',
      'buttonText': 'Write a review',
      'isButtonFilled': true,
      'photo': 'marigold',
    },
  ];
}
