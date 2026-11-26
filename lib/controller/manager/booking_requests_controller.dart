import 'package:get/get.dart';

enum RequestStatus { newRequest, negotiating, accepted, archived }

class BookingRequest {
  BookingRequest({
    required this.initials,
    required this.name,
    required this.info,
    required this.packageLine,
    required this.total,
    required this.hoursLeft,
    RequestStatus initialStatus = RequestStatus.newRequest,
  }) : status = Rx<RequestStatus>(initialStatus);

  final String initials;
  final String name;
  final String info; // "Sun 27 Dec · Lunch · 180 guests"
  final String packageLine; // "Gold · offered Rs 2,650 (listed 2,800)"
  final int total; // in rupees
  final int hoursLeft; // 0 = no countdown
  final Rx<RequestStatus> status;
}

class BookingRequestsController extends GetxController {
  final RxList<BookingRequest> requests = <BookingRequest>[
    BookingRequest(
      initials: 'HA',
      name: 'Hira Ahmed',
      info: 'Sun 27 Dec · Lunch · 180 guests',
      packageLine: 'Silver · listed price Rs 2,200 / head',
      total: 396000,
      hoursLeft: 22,
    ),
    BookingRequest(
      initials: 'UT',
      name: 'Usman Tariq',
      info: 'Sat 2 Jan · Dinner · 400 guests',
      packageLine: 'Gold · offered Rs 2,650 (listed 2,800)',
      total: 1060000,
      hoursLeft: 20,
    ),
    BookingRequest(
      initials: 'BK',
      name: 'Bilal Khan',
      info: 'Fri 8 Jan · Dinner · 200 guests',
      packageLine: 'Silver · offered Rs 2,000 (listed 2,200)',
      total: 400000,
      hoursLeft: 9,
    ),
    BookingRequest(
      initials: 'AR',
      name: 'Ali Raza',
      info: 'Sat 19 Dec · Dinner · 300 guests',
      packageLine: 'Gold · offered Rs 2,500 (listed 2,900)',
      total: 750000,
      hoursLeft: 14,
      initialStatus: RequestStatus.negotiating,
    ),
    BookingRequest(
      initials: 'ZM',
      name: 'Zainab Malik',
      info: 'Fri 15 Jan · Lunch · 220 guests',
      packageLine: 'Silver · offered Rs 1,900 (listed 2,200)',
      total: 418000,
      hoursLeft: 6,
      initialStatus: RequestStatus.negotiating,
    ),
    BookingRequest(
      initials: 'FM',
      name: 'Faisal Mehmood',
      info: 'Sat 19 Dec · Lunch · 250 guests',
      packageLine: 'Gold · listed price Rs 2,800 / head',
      total: 700000,
      hoursLeft: 0,
      initialStatus: RequestStatus.accepted,
    ),
  ].obs;

  /// Which tab is selected.
  final Rx<RequestStatus> filter = RequestStatus.newRequest.obs;

  int count(RequestStatus s) =>
      requests.where((r) => r.status.value == s).length;

  List<BookingRequest> get visible =>
      requests.where((r) => r.status.value == filter.value).toList();

  void accept(BookingRequest r) {
    r.status.value = RequestStatus.accepted;
    Get.snackbar('Accepted', 'You accepted ${r.name}\'s request.');
  }

  void decline(BookingRequest r) {
    r.status.value = RequestStatus.archived;
  }

  void counter(BookingRequest r) {
    // TODO: open a dialog / screen to send a counter-offer.
    Get.snackbar('Counter offer', 'Counter-offers for ${r.name} come next.');
  }
}   