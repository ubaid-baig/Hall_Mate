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
  // ══════════════════════════════════════════════════════════

  // ── Venue card ──
  // API: the venue the user is booking
  String venueName = 'Shaan Banquet Hall';
  String venueSubtitle = 'Banquet · Gulshan-e-Iqbal';
  String photo = 'emerald'; // DUMMY ONLY: placeholder colour

  // ══════════════════════════════════════════════════════════
  // EVENT DATE
  // ══════════════════════════════════════════════════════════

  // The picked date. .obs because Obx shows it.
  // API: the date picked on the Venue detail screen.
  Rx<DateTime> eventDate = DateTime(2026, 12, 19).obs;

  // Names used to write the date as "Saturday, 19 December 2026".
  // (DateTime.weekday is 1 for Monday ... 7 for Sunday,
  //  DateTime.month is 1 for January ... 12 for December.)
  List<String> weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // "Saturday, 19 December 2026"
  String eventDateText() {
    final DateTime d = eventDate.value;
    return '${weekdayNames[d.weekday - 1]}, ${d.day} ${monthNames[d.month - 1]} ${d.year}';
  }

  // Called after the user picks a date in the date picker.
  // Later (API): load the free slots of the new date.
  void changeDate(DateTime newDate) {
    eventDate.value = newDate;
  }

  // ══════════════════════════════════════════════════════════
  // TIME SLOT
  // ══════════════════════════════════════════════════════════

  // API: the slots of that day. 'isAvailable' false = already booked.
  List<Map<String, dynamic>> slots = [
    {'label': 'Lunch', 'note': 'Already booked', 'isAvailable': false},
    {'label': 'Dinner', 'note': '7 pm – 11 pm', 'isAvailable': true},
  ];

  // Which slot is selected: 0 = Lunch, 1 = Dinner.
  RxInt selectedSlotIndex = 1.obs;

  // A booked slot cannot be selected.
  void selectSlot(int index) {
    if (slots[index]['isAvailable'] == true) {
      selectedSlotIndex.value = index;
    }
  }

  // ══════════════════════════════════════════════════════════
  // GUESTS
  // ══════════════════════════════════════════════════════════

  // API: the hall's minimum and maximum guests
  int minGuests = 150;
  int maxGuests = 500;
  String guestsHint = 'Hall fits 150 – 500';

  RxInt guests = 300.obs;

  // The - button: 10 fewer, but never below the minimum
  void removeGuests() {
    if (guests.value - 10 >= minGuests) {
      guests.value = guests.value - 10;
    }
  }

  // The + button: 10 more, but never above the maximum
  void addGuests() {
    if (guests.value + 10 <= maxGuests) {
      guests.value = guests.value + 10;
    }
  }

  // ══════════════════════════════════════════════════════════
  // PACKAGE
  // ══════════════════════════════════════════════════════════

  // API: the packages of the venue (same list as the Venue detail screen).
  // 'priceNumber' is the same price as a number, so we can calculate with it.
  List<Map<String, dynamic>> packages = [
    {'name': 'Silver', 'price': 'Rs 2,200', 'priceNumber': 2200},
    {'name': 'Gold', 'price': 'Rs 2,800', 'priceNumber': 2800},
  ];

  // Which package is selected: 0 = Silver, 1 = Gold.
  RxInt selectedPackageIndex = 1.obs;

  void selectPackage(int index) {
    selectedPackageIndex.value = index;
  }

  // The listed price of the selected package, as a number
  int listedPrice() {
    return packages[selectedPackageIndex.value]['priceNumber'];
  }

  // ══════════════════════════════════════════════════════════
  // YOUR OFFER (the price field)
  // ══════════════════════════════════════════════════════════

  TextEditingController priceController = TextEditingController(text: '2400');

  // The offer as a number. .obs because the totals watch it.
  RxInt offer = 2400.obs;

  // Called on every key typed in the price field.
  // int.tryParse turns "2400" into 2400. If the text is not a number
  // (for example empty), it gives null, and we use 0 instead.
  void updateOffer(String text) {
    offer.value = int.tryParse(text.replaceAll(',', '')) ?? 0;
  }

  // "14% below the listed Rs 2,800 / head"
  String compareText() {
    final int listed = listedPrice();
    if (offer.value == 0) {
      return 'Enter your price per head';
    }
    if (offer.value == listed) {
      return 'Same as the listed ${formatRs(listed)} / head';
    }
    if (offer.value < listed) {
      final int percent = ((listed - offer.value) * 100 / listed).round();
      return '$percent% below the listed ${formatRs(listed)} / head';
    }
    final int percent = ((offer.value - listed) * 100 / listed).round();
    return '$percent% above the listed ${formatRs(listed)} / head';
  }

  // ══════════════════════════════════════════════════════════
  // SUMMARY (calculated from guests and offer)
  // ══════════════════════════════════════════════════════════

  String advanceLabel = '25% advance once accepted';
  String noteText =
      'The manager can accept, reject or counter your offer. Unanswered offers expire after 24 hours.';

  // guests x offer
  int total() {
    return guests.value * offer.value;
  }

  // 25% of the total ( ~/ divides and drops the decimals )
  int advance() {
    return total() ~/ 4;
  }

  // "300 guests × Rs 2,400"
  String guestsCalcText() {
    return '${guests.value} guests × ${formatRs(offer.value)}';
  }

  // Writes a number the Pakistani way: 720000 -> "Rs 7,20,000"
  // (the last 3 digits, then groups of 2)
  String formatRs(int amount) {
    String digits = amount.toString();
    if (digits.length <= 3) {
      return 'Rs $digits';
    }

    final String last3 = digits.substring(digits.length - 3);
    String rest = digits.substring(0, digits.length - 3);
    String groups = '';

    while (rest.length > 2) {
      groups = ',${rest.substring(rest.length - 2)}$groups';
      rest = rest.substring(0, rest.length - 2);
    }
    return 'Rs $rest$groups,$last3';
  }

  // ══════════════════════════════════════════════════════════
  // SEND
  // ══════════════════════════════════════════════════════════

  // Later (API): POST /bookings with venue, date, slot, guests,
  // package and offer. For now: check the offer, go back, show a message.
  void sendRequest() {
    if (offer.value <= 0) {
      Get.snackbar('Price missing', 'Please enter your offer per head');
      return;
    }
    Get.back();
    Get.snackbar(
      'Request sent',
      'The manager will reply within 24 hours',
    );
  }
}
