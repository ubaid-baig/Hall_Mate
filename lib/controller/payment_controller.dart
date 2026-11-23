import 'package:get/get.dart';

class PaymentController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Pay advance screen.
  //
  // When you connect the API:
  //  - GET /bookings/{id} gives the agreed price, guests and total.
  //  - The advance is 25% of the total. The balance is the rest.
  //    Later these will be calculated here instead of typed.
  //  - Paying is POST /payments with the booking id and the payment method.
  //    (In a student project the Pay button can just record the payment.)
  // ══════════════════════════════════════════════════════════

  // ── Top bar ──
  String bookingId = 'HM-1042'; // API

  // ── Green card ──
  String advanceLabel = 'Advance to confirm (25%)';
  String advanceAmount = 'Rs 1,87,500';
  String summaryLine = 'Shaan Banquet Hall · Sat 19 Dec · Dinner';

  // ── Price rows ──
  String agreedPrice = 'Rs 2,500 / head';
  String guests = '300';
  String total = 'Rs 7,50,000';
  String payNowLabel = 'Pay now (25%)';
  String payNow = 'Rs 1,87,500';
  String balance = 'Rs 5,62,500';

  // ── Payment methods ──
  // 'iconType' decides the picture: card, wallet or bank.
  // Which method is selected (index in the list). Later: make it RxInt.
  int selectedMethodIndex = 0;
  List<Map<String, String>> methods = [
    {
      'iconType': 'card',
      'title': 'Debit / credit card',
      'subtitle': 'Visa ending 4242',
    },
    {
      'iconType': 'wallet',
      'title': 'JazzCash',
      'subtitle': 'Mobile wallet',
    },
    {
      'iconType': 'wallet',
      'title': 'Easypaisa',
      'subtitle': 'Mobile wallet',
    },
    {
      'iconType': 'bank',
      'title': 'Bank transfer',
      'subtitle': 'Upload your receipt after paying',
    },
  ];

  // ── Note and button ──
  String infoNote =
      'Your 19 Dec dinner slot is blocked for you as soon as the advance is paid.';
  String payButtonText = 'Pay Rs 1,87,500';
}
