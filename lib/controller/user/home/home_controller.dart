import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/controller/shared/nav_controller.dart';
import 'package:hall_mate/model/venue_model.dart';

class HomeController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();
  final AuthController auth = Get.find<AuthController>();

  // "Ali" in "Hi Ali, let's find your venue"
  String userName() {
    return auth.firstName();
  }

  // The same list the manager picks her area from
  List<String> areas() {
    return data.areas;
  }

  RxString selectedArea = 'Gulshan-e-Iqbal'.obs;

  void selectArea(String area) {
    selectedArea.value = area;
  }

  // The orange dot on the bell: any unread notification?
  bool hasNewNotification() {
    return data.unreadCount(false, auth.userName()) > 0;
  }

  void openSearchTab() {
    Get.find<NavController>().changeIndex(1);
  }

  // ── Browse by type ── -1 = all types
  List<String> venueTypes = ['Ballroom', 'Banquet', 'Outdoor'];

  RxInt selectedTypeIndex = (-1).obs;

  // Tap a type to show only that type. Tap it again to show all.
  void selectType(int index) {
    if (selectedTypeIndex.value == index) {
      selectedTypeIndex.value = -1;
    } else {
      selectedTypeIndex.value = index;
    }
  }

  List<VenueModel> filterByType(List<VenueModel> venues) {
    if (selectedTypeIndex.value == -1) {
      return venues;
    }
    final String selectedType = venueTypes[selectedTypeIndex.value];
    List<VenueModel> result = [];
    for (var venue in venues) {
      if (venue.type == selectedType) {
        result.add(venue);
      }
    }
    return result;
  }

  // Every venue customers can see
  List<VenueModel> featuredVenues() {
    return filterByType(data.liveVenues());
  }

  // Only the venues in the chosen area
  List<VenueModel> nearbyVenues() {
    List<VenueModel> result = [];
    for (var venue in data.liveVenues()) {
      if (venue.area == selectedArea.value) {
        result.add(venue);
      }
    }
    return filterByType(result);
  }

  String emptyText() {
    if (selectedTypeIndex.value == -1) {
      return 'No venues here yet';
    }
    return 'No ${venueTypes[selectedTypeIndex.value]} venues here yet';
  }
}
