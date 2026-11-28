import 'package:get/get.dart';
import 'package:hall_mate/controller/manager/manager_nav_controller.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/utils/app_format.dart';

// The manager's home. Every number is worked out from the shared
// bookings list, so it changes as soon as a customer does something.
class DashboardController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();
  final AuthController auth = Get.find<AuthController>();

  // The logged-in manager's venue
  VenueModel venue() {
    return data.venueById(auth.venueId());
  }

  // "Good evening, Imran"
  String greeting() {
    final int hour = DateTime.now().hour;
    String part = 'Good evening';
    if (hour < 12) {
      part = 'Good morning';
    } else if (hour < 17) {
      part = 'Good afternoon';
    }
    return '$part, ${auth.firstName()}';
  }

  // "Banquet · Gulshan-e-Iqbal"
  String venueLine() {
    final VenueModel v = venue();
    if (v.area.isEmpty) {
      return '${v.type} · area not set';
    }
    return '${v.type} · ${v.area}';
  }

  // The orange dot on the bell
  bool hasNewNotification() {
    return data.unreadCount(true, auth.venueId()) > 0;
  }

  // ── The 3 small numbers ──
  int newRequests() {
    return data.countByStatus(auth.venueId(), 'Requested');
  }

  int negotiating() {
    return data.countByStatus(auth.venueId(), 'Negotiating');
  }

  int upcoming() {
    return data.countByStatus(auth.venueId(), 'Confirmed');
  }

  // ── The green earnings card ──
  // advances = 25% of every Confirmed and Completed booking
  String advancesText() {
    return AppFormat.rupees(data.advancesReceived(auth.venueId()));
  }

  // "Rs 2,17,500 to collect at the venue · 1 upcoming event"
  String collectText() {
    final int count = upcoming();
    return '${AppFormat.rupees(data.balanceToCollect(auth.venueId()))} '
        'to collect at the venue · $count upcoming '
        'event${count == 1 ? '' : 's'}';
  }

  // The requests that wait for the manager's answer (2 at most)
  List<BookingModel> waitingForMe() {
    List<BookingModel> result = [];
    for (var booking in data.bookingsOfVenue(auth.venueId())) {
      if (booking.isManagerTurn() && result.length < 2) {
        result.add(booking);
      }
    }
    return result;
  }

  void openTab(int index) {
    Get.find<ManagerNavController>().changeIndex(index);
  }
}
