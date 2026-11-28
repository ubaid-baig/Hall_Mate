import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/user/booking/booking_confirmed_screen.dart';

class PaymentController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();

  RxInt selectedMethodIndex = 0.obs;

  void selectMethod(int index) {
    selectedMethodIndex.value = index;
  }

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

  // "Shaan Banquet Hall · Sat 19 Dec"
  String summaryLine(BookingModel booking) {
    return '${booking.venueName} · ${AppFormat.shortDate(booking.eventDate)}';
  }

  // Later (API): send the payment to the server first.
  // The booking becomes Confirmed for BOTH sides,
  // and the manager gets an "Advance received" notification.
  void pay(BookingModel booking) {
    final String method = methods[selectedMethodIndex.value]['title']!;
    data.payAdvance(booking, method);
    Get.off(() => BookingConfirmedScreen(bookingId: booking.id));
  }
}
