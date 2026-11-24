import 'package:get/get.dart';

class FiltersController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Filters bottom sheet.
  //
  // When you connect the API:
  //  - The chosen filters become the query of the venue search:
  //    GET /venues?type=banquet&date=2026-12-19&slot=dinner&guests=300
  //        &budget_min=500000&budget_max=800000&amenities=parking,family_hall
  //  - "Show 6 venues" = the number of venues that match (ask the server).
  //  - "Reset" and "Clear" put every filter back to its start value.
  //  - Later: every chip, the stepper and the date field change these
  //    values (RxInt / RxList with Obx).
  // ══════════════════════════════════════════════════════════

  // ── Venue type ── 0 = Ballroom, 1 = Banquet, 2 = Outdoor
  int selectedTypeIndex = 1;

  // ── Date and slot ──
  // Later: the date field opens showDatePicker.
  String dateText = 'Sat, 19 Dec';
  // 0 = Dinner, 1 = Lunch
  int selectedSlotIndex = 0;

  // ── Guests ──
  String guestsText = '300';

  // ── Budget ──
  // Later: the slider changes the two numbers.
  String budgetText = 'Rs 5 – 8 lakh';
  String budgetMinText = 'Rs 2 lakh';
  String budgetMaxText = 'Rs 15 lakh+';

  // ── Amenities ──
  // API: the list of amenities the app offers
  List<Map<String, dynamic>> amenities = [
    {'label': 'Parking', 'isSelected': true},
    {'label': 'Family hall', 'isSelected': true},
    {'label': 'Generator', 'isSelected': false},
    {'label': 'In-house catering', 'isSelected': false},
    {'label': 'Valet', 'isSelected': false},
  ];

  // ── Bottom button ──
  // API: how many venues match the chosen filters
  String showButtonText = 'Show 6 venues';
}
