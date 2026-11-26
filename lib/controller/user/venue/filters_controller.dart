import 'package:get/get.dart';

// ══════════════════════════════════════════════════════════
// The Filters bottom sheet.
//
// The choices are kept here, and the Search screen reads them:
//  - every choice shows as a chip on the Search screen
//  - the Search list only shows the venues that match
// Nothing is chosen at the start, so the Search screen has no chips.
//
// When you connect the API, send the choices as the query:
//   GET /venues?type=Banquet&date=2026-12-19&slot=Dinner&guests=300
//       &amenities=Parking,Family hall
// ══════════════════════════════════════════════════════════
class FiltersController extends GetxController {
  // ── Venue type ── -1 = any, 0 Ballroom, 1 Banquet, 2 Outdoor
  List<String> types = ['Ballroom', 'Banquet', 'Outdoor'];
  RxInt selectedTypeIndex = (-1).obs;

  // Tap a type to choose it. Tap it again to remove it.
  void selectType(int index) {
    if (selectedTypeIndex.value == index) {
      selectedTypeIndex.value = -1;
    } else {
      selectedTypeIndex.value = index;
    }
  }

  // "Banquet", or '' when no type is chosen
  String selectedType() {
    if (selectedTypeIndex.value == -1) {
      return '';
    }
    return types[selectedTypeIndex.value];
  }

  // ── Date ── '' = any date. The date box opens the date picker.
  RxString dateText = ''.obs;
  List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List<String> monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  // Called after a date is picked: saves it as "Sat, 19   Dec"
  void setDate(DateTime date) {
    dateText.value =
        '${dayNames[date.weekday - 1]}, ${date.day} ${monthNames[date.month - 1]}';
  }

  // ── Slot ── 0 = Dinner, 1 = Lunch (only used when a date is chosen)
  List<String> slots = ['Dinner', 'Lunch'];
  RxInt selectedSlotIndex = 0.obs;

  void selectSlot(int index) {
    selectedSlotIndex.value = index;
  }

  // ── Guests ── 0 = any. The stepper goes up and down by 50.
  RxInt guests = 0.obs;

  void addGuests() {
    if (guests.value < 2000) {
      guests.value = guests.value + 50;
    }
  }

  void removeGuests() {
    if (guests.value >= 50) {
      guests.value = guests.value - 50;
    }
  }

  // What the stepper shows: "Any" or "300"
  String guestsText() {
    if (guests.value == 0) {
      return 'Any';
    }
    return '${guests.value}';
  }

  // ── Budget ── Later: the slider will change these (it is only drawn now).
  String budgetText = 'Rs 5 – 8 lakh';
  String budgetMinText = 'Rs 2 lakh';
  String budgetMaxText = 'Rs 15 lakh+';

  // ── Amenities ──
  List<String> amenities = [
    'Parking',
    'Family hall',
    'Generator',
    'In-house catering',
    'Valet',
  ];

  // The amenities the user chose
  RxList<String> selectedAmenities = <String>[].obs;

  // Tap to add, tap again to remove
  void toggleAmenity(String amenity) {
    if (selectedAmenities.contains(amenity)) {
      selectedAmenities.remove(amenity);
    } else {
      selectedAmenities.add(amenity);
    }
  }

  // ── Reset / Clear: everything back to "nothing chosen" ──
  void clearAll() {
    selectedTypeIndex.value = -1;
    dateText.value = '';
    selectedSlotIndex.value = 0;
    guests.value = 0;
    selectedAmenities.clear();
  }
}
