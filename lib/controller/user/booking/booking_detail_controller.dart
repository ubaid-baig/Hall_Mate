import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/model/chat_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/user/booking/payment_screen.dart';
import 'package:hall_mate/view/user/chat/chat_room_screen.dart';

// Booking detail (customer side). The manager's Request detail
// has a controller with the same functions, seen from the venue's side.
class BookingDetailController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();

  List<String> steps = [
    'Requested',
    'Negotiating',
    'Accepted',
    'Confirmed',
    'Completed',
  ];

  // ── One offer card ──

  // Who sent it: 'You' or the venue
  String offerSender(BookingModel booking, OfferModel offer) {
    if (offer.byManager) {
      return booking.venueName;
    }
    return 'You';
  }

  // "17% below the listed rent · Mon 16 Nov, 9:14 pm"
  String offerNote(BookingModel booking, OfferModel offer) {
    return '${BookingModel.compareWithListed(offer.amount, booking.listedRent)}'
        ' · ${AppFormat.dateAndTime(offer.sentAt)}';
  }

  // The pill on the card. Only the last offer is 'Latest' (or 'Accepted').
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
    if (booking.isCustomerTurn()) {
      return '${booking.venueName} sent a new offer. Reply within 24 hours.';
    } else if (booking.isOpen()) {
      return 'Waiting for ${booking.venueName} to reply.';
    } else if (booking.status == 'Accepted') {
      return 'Offer accepted at ${AppFormat.rupees(booking.agreedAmount())}. '
          'Pay the 25% advance to confirm your date.';
    } else if (booking.status == 'Confirmed') {
      return 'Advance paid. ${AppFormat.rupees(booking.balance())} '
          'is paid at the venue.';
    } else if (booking.status == 'Completed') {
      return booking.isReviewed
          ? 'Thank you for your review.'
          : 'Your event is over. How was it?';
    }
    return '${booking.venueName} declined this request.';
  }

  // "Accept · Rs 2,80,000"
  String acceptText(BookingModel booking) {
    return 'Accept · ${AppFormat.rupees(booking.latestOffer().amount)}';
  }

  // Accepts the venue's price, then the payment screen opens
  void accept(BookingModel booking) {
    data.acceptOffer(booking, false);
    Get.to(() => PaymentScreen(bookingId: booking.id));
    Get.snackbar('Offer accepted', 'Pay the advance to confirm your date');
  }

  // Opens the chat with this venue (a new chat is made if there is none)
  void openChat(BookingModel booking) {
    final ChatModel chat = data.chatFor(booking);
    data.markChatRead(chat, false);
    Get.to(() => ChatRoomScreen(chatId: chat.id));
  }
}
