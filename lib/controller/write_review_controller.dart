import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WriteReviewController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Write review screen.
  //
  // When you connect the API:
  //  - The venue and event come from the booking that was tapped.
  //  - Posting the review is POST /reviews with: booking id, the overall
  //    rating, the 4 category ratings, the text and the photos.
  //  - Later: the 5 big stars and the category stars become buttons that
  //    change these numbers (RxInt, with an Obx around the stars).
  // ══════════════════════════════════════════════════════════

  // ── Venue card ──
  String venueName = 'Shaan Banquet Hall';
  String eventLine = 'Walima · Sat 19 Dec 2026 · 320 guests';
  String photo = 'emerald'; // DUMMY ONLY: placeholder colour

  // ── Overall rating ──
  // 1 to 5. The label under the stars follows it:
  // 1 Poor, 2 Fair, 3 Good, 4 Very good, 5 Excellent
  int overallRating = 5;
  String ratingLabel = 'Excellent';

  // ── Category ratings (1 to 5) ──
  List<Map<String, dynamic>> categories = [
    {'label': 'Food', 'rating': 5},
    {'label': 'Service', 'rating': 5},
    {'label': 'Décor', 'rating': 4},
    {'label': 'Value for money', 'rating': 4},
  ];

  // ── Review text ──
  // Dummy text for now.
  TextEditingController reviewController = TextEditingController(
    text: 'Food was great, staff very helpful. The white & gold stage looked beautiful.',
  );
  // Later: count the characters of the text (the limit is 500).
  String counterText = '84 / 500';
}
