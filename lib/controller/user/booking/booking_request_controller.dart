import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/user/booking/booking_detail_screen.dart';

class BookingRequestController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();
  final AuthController auth = Get.find<AuthController>();

  final String venueId;

  // The screen sends the venue and the day picked on Venue detail.
  // The fields start with that day, the smallest guest number
  // and the venue's listed rent.
  BookingRequestController({required this.venueId, required DateTime startDate}) {
    final VenueModel v = venue();
    eventDate.value = startDate;
    guests.value = v.minGuests;
    offer.value = v.rent;
    priceController.text = '${v.rent}';
  }

  VenueModel venue() {
    return data.venueById(venueId);
  }

  // ── Event date ──
  Rx<DateTime> eventDate = DateTime.now().obs;

  // "Saturday, 19 December 2026"
  String eventDateText() {
    return AppFormat.fullDate(eventDate.value);
  }

  bool isDateFree() {
    return !data.isDateBooked(venueId, eventDate.value);
  }

  void changeDate(DateTime newDate) {
    if (data.isDateBooked(venueId, newDate)) {
      Get.snackbar(
        'Date not available',
        '${venue().name} is already booked on ${AppFormat.shortDate(newDate)}',
      );
      return;
    }
    eventDate.value = newDate;
  }

  // ── Event type ──
  List<String> eventTypes = ['Walima', 'Barat', 'Mehndi', 'Birthday', 'Corporate'];

  RxInt selectedEventIndex = 0.obs;

  void selectEvent(int index) {
    selectedEventIndex.value = index;
  }

  // ── Guests ──
  RxInt guests = 0.obs;

  // "Hall fits 150 – 500"
  String guestsHint() {
    return 'Hall fits ${venue().minGuests} – ${venue().maxGuests}';
  }

  // The - button: 10 fewer, but never below the minimum
  void removeGuests() {
    if (guests.value - 10 >= venue().minGuests) {
      guests.value = guests.value - 10;
    }
  }

  // The + button: 10 more, but never above the maximum
  void addGuests() {
    if (guests.value + 10 <= venue().maxGuests) {
      guests.value = guests.value + 10;
    }
  }

  // ── Your offer (the total rent you want to pay) ──
  TextEditingController priceController = TextEditingController();

  RxInt offer = 0.obs;

  void updateOffer(String text) {
    offer.value = int.tryParse(text.replaceAll(',', '')) ?? 0;
  }

  // "17% below the listed rent"
  String compareText() {
    return BookingModel.compareWithListed(offer.value, venue().rent);
  }

  // 25% of the offer
  int advance() {
    return BookingModel.advanceOf(offer.value);
  }

  String noteText =
      'The manager can accept, decline or counter your offer. '
      'Unanswered offers expire after 24 hours.';

  void sendRequest() {
    if (offer.value <= 0) {
      Get.snackbar('Price missing', 'Please enter your offer');
      return;
    }
    if (!isDateFree()) {
      Get.snackbar('Date not available', 'Please pick another date');
      return;
    }

    // Adds the request to the shared list, so the manager sees it
    final String newId = data.sendRequest(
      venue: venue(),
      customerName: auth.userName(),
      customerPhone: auth.userPhone(),
      eventType: eventTypes[selectedEventIndex.value],
      date: eventDate.value,
      guests: guests.value,
      amount: offer.value,
    );

    // Get.off: the request screen closes and the new booking opens
    Get.off(() => BookingDetailScreen(bookingId: newId));
    Get.snackbar('Request sent', 'The manager will reply within 24 hours');
  }

  @override
  void onClose() {
    priceController.dispose();
    super.onClose();
  }
}
