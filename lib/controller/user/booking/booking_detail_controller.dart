import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingDetailController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Booking detail screen and the counter-offer sheet.
  //
  // When you connect the API:
  //  - GET /bookings/{id}  (the id comes from the booking card that was tapped)
  //  - Fill every variable below from that response.
  //  - 'offers' comes from the same response (or GET /bookings/{id}/offers),
  //    oldest first, so the newest offer is at the bottom.
  // ══════════════════════════════════════════════════════════

  // ── Top bar ──
  // API: booking code and the date the request was made
  String bookingId = 'HM-1042';
  String requestedOn = 'Requested on 16 Nov 2026';

  // ── Venue summary card ──
  // API: venue name, event date + slot, booking status
  String venueName = 'Shaan Banquet Hall';
  String dateText = 'Sat, 19 Dec 2026 · Dinner';
  // Use exactly: Requested, Negotiating, Accepted, Confirmed, Completed
  String status = 'Negotiating';
  String photo = 'emerald'; // DUMMY ONLY: placeholder colour

  // API: the venue manager of this venue
  String managerInitials = 'IS';
  String managerName = 'Imran Siddiqui';

  // ── Info tiles ──
  // API: values from the booking request
  String guests = '300';
  String package = 'Gold';
  String listedPrice = 'Rs 2,800';
  String timeText = '7 pm – 11 pm';

  // ── Step tracker ──
  // The 5 steps are always the same. Only the current step changes.
  // API: work it out from the status:
  // Requested = 0, Negotiating = 1, Accepted = 2, Confirmed = 3, Completed = 4
  List<String> steps = [
    'Requested',
    'Negotiating',
    'Accepted',
    'Confirmed',
    'Completed',
  ];
  int currentStepIndex = 1;

  // ── Offers (oldest first) ──
  // API: GET /bookings/{id}/offers
  // 'isMine' true  = the offer was sent by the person using the app
  //                  (green bubble on the right)
  // 'isMine' false = the offer came from the other side (white bubble on the left)
  // 'tag' is the small pill: 'Countered' on the old one, 'Latest' on the newest.
  // .obs because Obx shows the list (a new counter offer is added to it).
  RxList<Map<String, dynamic>> offers = <Map<String, dynamic>>[
    {
      'sender': 'You',
      'isMine': true,
      'price': 'Rs 2,400',
      'total': 'Rs 7,20,000',
      'time': 'Mon 16 Nov, 9:14 pm',
      'tag': 'Countered',
    },
    {
      'sender': 'Shaan Banquet Hall',
      'isMine': false,
      'price': 'Rs 2,600',
      'total': 'Rs 7,80,000',
      'time': 'Tue 17 Nov, 11:02 am',
      'tag': 'Latest',
    },
  ].obs;

  // ── Bottom bar ──
  // API: the note under the offers and the amount on the Accept button
  // (latest offer price x guests). .obs because they change after a counter.
  RxString latestOfferNote =
      'Shaan Banquet Hall sent a new offer. It expires in 21 h.'.obs;
  String acceptText = 'Accept · Rs 7,80,000';

  // true after you send a counter offer: now the venue has to answer,
  // so you cannot accept (the Accept button turns grey).
  RxBool isWaitingForThem = false.obs;

  // ── Counter-offer sheet ──
  // API: the other side's latest offer
  String theirLatestOfferText = 'Their latest offer: Rs 2,600 / head';

  // The guests as a number, used for the total
  int guestsNumber = 300;

  // The price field (only the number)
  TextEditingController priceController = TextEditingController(text: '2500');

  // The typed price as a number. .obs because the total in the sheet watches it.
  RxInt counterPrice = 2500.obs;

  // Called on every key typed in the price field.
  // int.tryParse: "2500" -> 2500, not a number -> null, then we use 0.
  void updateCounterPrice(String text) {
    counterPrice.value = int.tryParse(text.replaceAll(',', '')) ?? 0;
  }

  // "300 guests × Rs 2,500"
  String guestsCalcText() {
    return '$guestsNumber guests × ${formatRs(counterPrice.value)}';
  }

  // "Rs 7,50,000"
  String totalText() {
    return formatRs(guestsNumber * counterPrice.value);
  }

  // Called by "Send counter offer".
  // Gives back true if it was sent (then the sheet closes).
  // Later (API): POST /bookings/{id}/offers first.
  bool sendCounterOffer() {
    if (counterPrice.value <= 0) {
      Get.snackbar('Price missing', 'Please enter your price per head');
      return false;
    }

    // The old "Latest" offer becomes "Countered"
    for (var offer in offers) {
      if (offer['tag'] == 'Latest') {
        offer['tag'] = 'Countered';
      }
    }

    // Add my new offer at the bottom
    offers.add({
      'sender': 'You',
      'isMine': true,
      'price': formatRs(counterPrice.value),
      'total': totalText(),
      'time': 'Just now',
      'tag': 'Latest',
    });

    latestOfferNote.value =
        'You sent a counter offer. Waiting for $venueName to reply.';
    isWaitingForThem.value = true;
    return true;
  }

  // Writes a number the Pakistani way: 750000 -> "Rs 7,50,000"
  // (the same helper as in BookingRequestController)
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

  String expiryNote = 'Unanswered offers expire after 24 hours.';
}
