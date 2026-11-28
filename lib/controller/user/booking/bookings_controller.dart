import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/user/booking/booking_confirmed_screen.dart';
import 'package:hall_mate/view/user/booking/booking_detail_screen.dart';
import 'package:hall_mate/view/user/booking/payment_screen.dart';
import 'package:hall_mate/view/user/booking/write_review_screen.dart';

class BookingsController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();
  final AuthController auth = Get.find<AuthController>();

  // The chips. Each one (except All) is a status.
  // The manager's Requests screen uses the same list.
  List<String> filters = [
    'All',
    'Requested',
    'Negotiating',
    'Accepted',
    'Confirmed',
    'Completed',
  ];

  RxInt selectedFilterIndex = 0.obs;

  void selectFilter(int index) {
    selectedFilterIndex.value = index;
  }

  // Only the bookings of the logged-in customer
  List<BookingModel> myBookings() {
    return data.bookingsOfCustomer(auth.userName());
  }

  // The number on a chip: how many bookings have that status
  String countFor(int index) {
    if (index == 0) {
      return '${myBookings().length}';
    }
    int count = 0;
    for (var booking in myBookings()) {
      if (booking.status == filters[index]) {
        count = count + 1;
      }
    }
    return '$count';
  }

  // The numbers of all the chips at once.
  // The screen reads them inside its Obx, so they update when a booking changes.
  List<String> allCounts() {
    List<String> counts = [];
    for (int i = 0; i < filters.length; i++) {
      counts.add(countFor(i));
    }
    return counts;
  }

  // Only the bookings of the selected chip (or all of them)
  List<BookingModel> filteredBookings() {
    if (selectedFilterIndex.value == 0) {
      return myBookings();
    }
    List<BookingModel> result = [];
    for (var booking in myBookings()) {
      if (booking.status == filters[selectedFilterIndex.value]) {
        result.add(booking);
      }
    }
    return result;
  }

  // ── What one booking card says ──

  MediaModel photoOf(BookingModel booking) {
    final VenueModel venue = data.venueById(booking.venueId);
    return venue.coverOrPlaceholder();
  }

  // "Sat 19 Dec 2026 · Walima · 300 guests"
  String detailsText(BookingModel booking) {
    return '${AppFormat.dateWithYear(booking.eventDate)} · '
        '${booking.eventType} · ${booking.guests} guests';
  }

  String infoText(BookingModel booking) {
    final String latest = AppFormat.rupees(booking.latestOffer().amount);
    if (booking.status == 'Requested') {
      return 'Waiting for the venue · you offered $latest';
    } else if (booking.isCustomerTurn()) {
      return 'New counter: $latest';
    } else if (booking.status == 'Negotiating') {
      return 'You offered $latest · waiting for reply';
    } else if (booking.status == 'Accepted') {
      return 'Pay the ${AppFormat.rupees(booking.advance())} advance to confirm';
    } else if (booking.status == 'Confirmed') {
      return 'Advance paid · ${AppFormat.rupees(booking.advance())}';
    } else if (booking.status == 'Completed') {
      return booking.isReviewed ? 'You reviewed this venue' : 'How was your event?';
    }
    return 'The venue declined this request';
  }

  String buttonText(BookingModel booking) {
    if (booking.isCustomerTurn()) {
      return 'Reply';
    } else if (booking.status == 'Accepted') {
      return 'Pay advance';
    } else if (booking.status == 'Confirmed') {
      return 'Receipt';
    } else if (booking.status == 'Completed' && !booking.isReviewed) {
      return 'Write a review';
    }
    return 'View';
  }

  // The button is green when the customer has something to do
  bool isButtonFilled(BookingModel booking) {
    return booking.isCustomerTurn() ||
        booking.status == 'Accepted' ||
        (booking.status == 'Completed' && !booking.isReviewed);
  }

  // Opens the right screen for this booking
  void openBooking(BookingModel booking) {
    if (booking.status == 'Accepted') {
      Get.to(() => PaymentScreen(bookingId: booking.id));
    } else if (booking.status == 'Confirmed') {
      Get.to(() => BookingConfirmedScreen(bookingId: booking.id));
    } else if (booking.status == 'Completed' && !booking.isReviewed) {
      Get.to(() => WriteReviewScreen(bookingId: booking.id));
    } else {
      Get.to(() => BookingDetailScreen(bookingId: booking.id));
    }
  }
}
