import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingRequestController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Booking request screen.
  //
  // When you connect the API:
  //  - The venue (name, packages, slots) comes from the venue the user opened
  //    (GET /venues/{id}), together with the date picked on the Venue detail screen.
  //  - Sending the request is POST /bookings with: venue id, date, slot,
  //    guests, package and the offer per head.
  //  - Later, the numbers in the summary card (total and advance) will be
  //    calculated here from guests x offer. For now they are plain text.
  // ══════════════════════════════════════════════════════════

  // ── Venue card ──
  // API: the venue the user is booking
  String venueName = 'Shaan Banquet Hall';
  String venueSubtitle = 'Banquet · Gulshan-e-Iqbal';
  String photo = 'emerald'; // DUMMY ONLY: placeholder colour

  // ── Event date ──
  // API: the date picked on the Venue detail screen.
  // Later: the "Change" button opens showDatePicker (you used it in the to-do app).
  String eventDateText = 'Saturday, 19 December 2026';

  // ── Time slot ──
  // API: the slots of that day. 'isAvailable' false = already booked.
  // Which slot is selected: 0 = Lunch, 1 = Dinner. Later: make it RxInt.
  int selectedSlotIndex = 1;
  List<Map<String, dynamic>> slots = [
    {'label': 'Lunch', 'note': 'Already booked', 'isAvailable': false},
    {'label': 'Dinner', 'note': '7 pm – 11 pm', 'isAvailable': true},
  ];

  // ── Guests ──
  // Later: make guests an RxInt, and the - and + buttons change it.
  String guestsText = '300';
  // API: the hall's minimum and maximum guests
  String guestsHint = 'Hall fits 150 – 500';

  // ── Package ──
  // API: the packages of the venue (same list as the Venue detail screen).
  // Which package is selected: 0 = Silver, 1 = Gold. Later: make it RxInt.
  int selectedPackageIndex = 1;
  List<Map<String, String>> packages = [
    {'name': 'Silver', 'price': 'Rs 2,200'},
    {'name': 'Gold', 'price': 'Rs 2,800'},
  ];

  // ── Your offer ──
  // The price field. Dummy text for now.
  // Later: keep only the number (2400) and show "Rs" and "/ head" around it,
  // then calculate the total from it.
  TextEditingController priceController = TextEditingController(text: '2,400');

  // Later: work these out from the offer and the listed price of the package.
  String belowListedText = '14% below the listed Rs 2,800 / head';

  // ── Summary card ──
  // Later: calculated (guests x offer, and 25% of the total).
  String guestsCalcText = '300 guests × Rs 2,400';
  String totalText = 'Rs 7,20,000';
  String advanceLabel = '25% advance once accepted';
  String advanceText = 'Rs 1,80,000';
  String noteText =
      'The manager can accept, reject or counter your offer. Unanswered offers expire after 24 hours.';

  // ── Bottom bar ──
  String totalOfferText = 'Rs 7,20,000';
}
