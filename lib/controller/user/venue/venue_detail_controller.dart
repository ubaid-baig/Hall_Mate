import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/utils/app_format.dart';

class VenueDetailController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();

  // ── Free dates: the next 14 days, starting today ──
  List<DateTime> nextDays() {
    List<DateTime> days = [];
    for (int i = 0; i < 14; i++) {
      days.add(data.day(i));
    }
    return days;
  }

  // Which day is selected (0 = today)
  RxInt selectedDateIndex = 0.obs;

  void selectDate(int index) {
    selectedDateIndex.value = index;
  }

  DateTime selectedDate() {
    return nextDays()[selectedDateIndex.value];
  }

  // A day is free when no accepted or paid booking has it
  bool isFree(VenueModel venue, DateTime date) {
    return !data.isDateBooked(venue.id, date);
  }

  // "Sat 19 Dec"
  String selectedDateText() {
    return AppFormat.shortDate(selectedDate());
  }

  // ── Feature tiles: capacity first, then up to 2 of the venue's features ──
  List<Map<String, String>> featureTiles(VenueModel venue) {
    List<Map<String, String>> tiles = [
      {'icon': 'guests', 'label': 'Up to ${venue.maxGuests} guests'},
    ];
    for (var feature in venue.features) {
      if (tiles.length < 3) {
        tiles.add({'icon': feature, 'label': feature});
      }
    }
    return tiles;
  }

  // "(3 reviews)"
  String reviewsText(VenueModel venue) {
    if (venue.reviews.length == 1) {
      return '(1 review)';
    }
    return '(${venue.reviews.length} reviews)';
  }
}
