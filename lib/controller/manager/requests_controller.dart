import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/manager/requests/request_detail_screen.dart';

// The manager's Requests tab. It works like the customer's
// BookingsController: the same chips, the same counting,
// only the bookings are the venue's instead of the customer's.
class RequestsController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();
  final AuthController auth = Get.find<AuthController>();

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

  // Only the bookings of the logged-in manager's venue
  List<BookingModel> venueBookings() {
    return data.bookingsOfVenue(auth.venueId());
  }

  String countFor(int index) {
    if (index == 0) {
      return '${venueBookings().length}';
    }
    int count = 0;
    for (var booking in venueBookings()) {
      if (booking.status == filters[index]) {
        count = count + 1;
      }
    }
    return '$count';
  }

  // The numbers of all the chips at once (read inside the Obx)
  List<String> allCounts() {
    List<String> counts = [];
    for (int i = 0; i < filters.length; i++) {
      counts.add(countFor(i));
    }
    return counts;
  }

  List<BookingModel> filteredBookings() {
    if (selectedFilterIndex.value == 0) {
      return venueBookings();
    }
    List<BookingModel> result = [];
    for (var booking in venueBookings()) {
      if (booking.status == filters[selectedFilterIndex.value]) {
        result.add(booking);
      }
    }
    return result;
  }

  // ── What one request card says ──

  // "Sat 19 Dec 2026 · Walima · 300 guests"
  String detailsText(BookingModel booking) {
    return '${AppFormat.dateWithYear(booking.eventDate)} · '
        '${booking.eventType} · ${booking.guests} guests';
  }

  String infoText(BookingModel booking) {
    final String latest = AppFormat.rupees(booking.latestOffer().amount);
    if (booking.status == 'Requested') {
      return 'Offered $latest · listed ${AppFormat.rupees(booking.listedRent)}';
    } else if (booking.isManagerTurn()) {
      return 'New counter: $latest';
    } else if (booking.status == 'Negotiating') {
      return 'You offered $latest · waiting for reply';
    } else if (booking.status == 'Accepted') {
      return 'Waiting for the ${AppFormat.rupees(booking.advance())} advance';
    } else if (booking.status == 'Confirmed') {
      return 'Advance received · ${AppFormat.rupees(booking.advance())}';
    } else if (booking.status == 'Completed') {
      return 'Event done · ${AppFormat.rupees(booking.agreedAmount())}';
    }
    return 'You declined this request';
  }

  String buttonText(BookingModel booking) {
    if (booking.isManagerTurn()) {
      return 'Reply';
    }
    return 'View';
  }

  // Green when the manager has to answer
  bool isButtonFilled(BookingModel booking) {
    return booking.isManagerTurn();
  }

  void openRequest(BookingModel booking) {
    Get.to(() => RequestDetailScreen(bookingId: booking.id));
  }
}
