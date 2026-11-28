import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/model/chat_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/manager/chat/manager_chat_room_screen.dart';

// Request detail (manager side). It has the same functions as the
// customer's BookingDetailController, seen from the venue's side.
class RequestDetailController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();

  List<String> steps = [
    'Requested',
    'Negotiating',
    'Accepted',
    'Confirmed',
    'Completed',
  ];

  // ── One offer card ──

  String offerSender(BookingModel booking, OfferModel offer) {
    if (offer.byManager) {
      return 'You';
    }
    return booking.customerName;
  }

  // "17% below the listed rent · Mon 16 Nov, 9:14 pm"
  String offerNote(BookingModel booking, OfferModel offer) {
    return '${BookingModel.compareWithListed(offer.amount, booking.listedRent)}'
        ' · ${AppFormat.dateAndTime(offer.sentAt)}';
  }

  String offerTag(BookingModel booking, int index) {
    final bool isLast = index == booking.offers.length - 1;
    if (!isLast) {
      return 'Countered';
    } else if (booking.status == 'Declined') {
      return 'Declined';
    } else if (booking.isOpen()) {
      return 'Latest';
    }
    return 'Accepted';
  }

  // ── The grey line above the bottom buttons ──
  String bottomNote(BookingModel booking) {
    if (booking.isManagerTurn()) {
      return '${booking.customerName} sent an offer. Reply within 24 hours.';
    } else if (booking.isOpen()) {
      return 'Waiting for ${booking.customerName} to reply.';
    } else if (booking.status == 'Accepted') {
      return 'Agreed at ${AppFormat.rupees(booking.agreedAmount())}. '
          'Waiting for the ${AppFormat.rupees(booking.advance())} advance.';
    } else if (booking.status == 'Confirmed') {
      return 'Advance ${AppFormat.rupees(booking.advance())} received. '
          '${AppFormat.rupees(booking.balance())} to collect at the venue.';
    } else if (booking.status == 'Completed') {
      return booking.isReviewed
          ? 'Event done. ${booking.customerName} left a review.'
          : 'Event done.';
    }
    return 'You declined this request.';
  }

  // "Accept · Rs 2,55,000"
  String acceptText(BookingModel booking) {
    return 'Accept · ${AppFormat.rupees(booking.latestOffer().amount)}';
  }

  // The customer's price is accepted. The customer can now pay the advance.
  void accept(BookingModel booking) {
    data.acceptOffer(booking, true);
    Get.snackbar(
      'Offer accepted',
      '${booking.customerName} can now pay the advance',
    );
  }

  void decline(BookingModel booking) {
    data.declineRequest(booking);
    Get.snackbar('Request declined', '${booking.customerName} has been told');
  }

  // Opens the chat with this customer (a new chat is made if there is none)
  void openChat(BookingModel booking) {
    final ChatModel chat = data.chatFor(booking);
    data.markChatRead(chat, true);
    Get.to(() => ManagerChatRoomScreen(chatId: chat.id));
  }
}
