import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/utils/app_format.dart';

class WriteReviewController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();

  // "Walima · Sat 19 Dec 2026 · 300 guests"
  String eventLine(BookingModel booking) {
    return '${booking.eventType} · ${AppFormat.dateWithYear(booking.eventDate)}'
        ' · ${booking.guests} guests';
  }

  // ── Stars ──
  RxInt overallRating = 5.obs;

  List<String> ratingLabels = ['Poor', 'Fair', 'Good', 'Very good', 'Excellent'];

  void setOverallRating(int stars) {
    overallRating.value = stars;
  }

  String ratingLabel() {
    return ratingLabels[overallRating.value - 1];
  }

  // ── Review text ──
  TextEditingController reviewController = TextEditingController();

  // How many letters are typed. .obs because the "84 / 500" text watches it.
  RxInt letterCount = 0.obs;

  void updateLetterCount(String text) {
    letterCount.value = text.length;
  }

  String counterText() {
    return '${letterCount.value} / 500';
  }

  // The review is added to the venue, so every customer sees it
  // on Venue detail, and the manager gets a "New review" notification.
  void postReview(BookingModel booking) {
    final String text = reviewController.text.trim();
    if (text.isEmpty) {
      Get.snackbar('Review missing', 'Please write a few words');
      return;
    }
    if (text.length > 500) {
      Get.snackbar('Too long', 'Please keep it under 500 letters');
      return;
    }
    data.addReview(booking, overallRating.value, text);
    Get.back();
    Get.snackbar('Thank you!', 'Your review has been posted');
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }
}
