import 'package:get/get.dart';
import 'package:hall_mate/utils/app_format.dart';

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

  // ── Date ── null = any date. Only venues free on this date are shown.
  Rxn<DateTime> selectedDate = Rxn<DateTime>();

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  // "Sat 19 Dec", or '' when no date is chosen
  String dateText() {
    if (selectedDate.value == null) {
      return '';
    }
    return AppFormat.shortDate(selectedDate.value!);
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

  // ── Budget: the highest rent the customer wants to pay ──
  List<String> budgetLabels = ['Any', '2.5 lakh', '3 lakh', '4 lakh'];
  List<int> budgetValues = [0, 250000, 300000, 400000]; // 0 = any

  RxInt selectedBudgetIndex = 0.obs;

  void selectBudget(int index) {
    selectedBudgetIndex.value = index;
  }

  int maxRent() {
    return budgetValues[selectedBudgetIndex.value];
  }

  // ── Amenities ── (the same names the manager switches on in her form)
  List<String> amenities = ['Parking', 'Family hall', 'Generator', 'Valet'];

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
    selectedDate.value = null;
    guests.value = 0;
    selectedBudgetIndex.value = 0;
    selectedAmenities.clear();
  }
}
