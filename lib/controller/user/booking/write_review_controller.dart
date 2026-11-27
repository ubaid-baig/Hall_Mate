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
  // ══════════════════════════════════════════════════════════

  // ── Venue card ──
  String venueName = 'Shaan Banquet Hall';
  String eventLine = 'Walima · Sat 19 Dec 2026 · 320 guests';
  String photo = 'emerald'; // DUMMY ONLY: placeholder colour

  // ── Overall rating ──
  // 1 to 5. The label under the stars follows it:
  // 1 Poor, 2 Fair, 3 Good, 4 Very good, 5 Excellent
  RxInt overallRating = 5.obs;
  List<String> ratingLabels = ['Poor', 'Fair', 'Good', 'Very good', 'Excellent'];

  // Called when one of the 5 big stars is tapped
  void setOverallRating(int stars) {
    overallRating.value = stars;
  }

  // The word under the stars ("Excellent" for 5)
  String ratingLabel() {
    return ratingLabels[overallRating.value - 1];
  }

  // ── Category ratings (1 to 5) ──
  // .obs because Obx shows the stars of each row.
  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[
    {'label': 'Food', 'rating': 5},
    {'label': 'Service', 'rating': 5},
    {'label': 'Décor', 'rating': 4},
    {'label': 'Value for money', 'rating': 4},
  ].obs;

  // Called when a small star in a category row is tapped
  void setCategoryRating(Map<String, dynamic> category, int stars) {
    category['rating'] = stars;
    categories.refresh(); // tells Obx that something inside changed
  }

  // ── Review text ──
  // Dummy text for now.
  TextEditingController reviewController = TextEditingController(
    text: 'Food was great, staff very helpful. The white & gold stage looked beautiful.',
  );
  // How many letters are typed. .obs because the "84 / 500" text watches it.
  RxInt letterCount = 76.obs;

  // Called on every key typed in the review field
  void updateLetterCount(String text) {
    letterCount.value = text.length;
  }

  String counterText() {
    return '${letterCount.value} / 500';
  }

  // "Post review": checks the text, goes back and shows a message.
  // Later (API): POST /reviews first.
  void postReview() {
    if (reviewController.text.trim().isEmpty) {
      Get.snackbar('Review missing', 'Please write a few words');
      return;
    }
    if (reviewController.text.length > 500) {
      Get.snackbar('Too long', 'Please keep it under 500 letters');
      return;
    }
    Get.back();
    Get.snackbar('Thank you!', 'Your review has been posted');
  }
}
