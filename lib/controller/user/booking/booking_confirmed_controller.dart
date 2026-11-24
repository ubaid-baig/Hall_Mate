import 'package:get/get.dart';

class BookingConfirmedController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Booking confirmed screen.
  //
  // When you connect the API:
  //  - This is the receipt. Take it from the payment response
  //    (POST /payments) or from GET /bookings/{id}.
  // ══════════════════════════════════════════════════════════

  String subtitle = 'Shaan Banquet Hall has blocked\nSat 19 Dec (dinner) for you.';

  // ── Receipt rows ──
  String bookingId = 'HM-1042';
  String venue = 'Shaan Banquet Hall';
  String dateAndSlot = 'Sat 19 Dec 2026 · Dinner';
  String guestsAndPackage = '300 · Gold';
  String agreedPrice = 'Rs 7,50,000';
  String advancePaid = 'Rs 1,87,500';
  String balanceDue = 'Rs 5,62,500';
}
