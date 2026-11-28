import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/utils/app_format.dart';

// Used by the "Make a counter offer" sheet.
// The same sheet opens for the customer and for the manager,
// only "byManager" is different.
class CounterOfferController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();

  TextEditingController priceController = TextEditingController();

  RxInt price = 0.obs;

  // Called every time the sheet opens:
  // the field starts with the other side's latest offer.
  void start(BookingModel booking) {
    price.value = booking.latestOffer().amount;
    priceController.text = '${price.value}';
  }

  void updatePrice(String text) {
    price.value = int.tryParse(text.replaceAll(',', '')) ?? 0;
  }

  // "Their latest offer: Rs 2,80,000"
  String theirOfferText(BookingModel booking) {
    return 'Their latest offer: ${AppFormat.rupees(booking.latestOffer().amount)}';
  }

  // "7% below the listed rent"
  String compareText(BookingModel booking) {
    return BookingModel.compareWithListed(price.value, booking.listedRent);
  }

  // "Advance once accepted: Rs 65,000"
  String advanceText() {
    return 'Advance once accepted: '
        '${AppFormat.rupees(BookingModel.advanceOf(price.value))}';
  }

  // Returns true if the offer was sent (then the sheet closes)
  bool send(BookingModel booking, bool byManager) {
    if (price.value <= 0) {
      Get.snackbar('Price missing', 'Please enter your price');
      return false;
    }
    if (price.value == booking.latestOffer().amount) {
      Get.snackbar('Same price', 'To agree to this price, tap Accept instead');
      return false;
    }
    data.sendOffer(booking, price.value, byManager);
    return true;
  }
}
