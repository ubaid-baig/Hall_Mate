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

  // Which chip is selected (0 = All).
  // Later: make it RxInt and change it when a chip is tapped.
  int selectedFilterIndex = 0;

  // API: count how many bookings have each status.
  List<Map<String, dynamic>> filters = [
    {'label': 'All', 'count': '4'},
    {'label': 'Requested', 'count': '1'},
    {'label': 'Negotiating', 'count': '1'},
    {'label': 'Confirmed', 'count': '1'},
    {'label': 'Completed', 'count': '1'},
  ];

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
