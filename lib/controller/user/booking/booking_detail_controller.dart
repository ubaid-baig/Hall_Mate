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
  List<Map<String, dynamic>> offers = [
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
  ];

  // ── Bottom bar ──
  // API: the note under the offers and the amount on the Accept button
  // (latest offer price x guests)
  String latestOfferNote = 'Shaan Banquet Hall sent a new offer. It expires in 21 h.';
  String acceptText = 'Accept · Rs 7,80,000';

  // ── Counter-offer sheet ──
  // API: the other side's latest offer
  String theirLatestOfferText = 'Their latest offer: Rs 2,600 / head';

  // The price field. Dummy text for now.
  // Later: keep only the number in here (like 2500) and show "Rs" with a prefix,
  // so we can multiply it by the guests to get the total.
  TextEditingController priceController = TextEditingController(
    text: 'Rs 2,500',
  );

  // Later: these two update by themselves when the price field changes
  // (use an RxString and an Obx in the sheet).
  String guestsCalcText = '300 guests × Rs 2,500';
  String totalText = 'Rs 7,50,000';

  String expiryNote = 'Unanswered offers expire after 24 hours.';
}
