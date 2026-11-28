import 'package:get/get.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/model/chat_model.dart';
import 'package:hall_mate/model/notification_model.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/utils/app_format.dart';

// ══════════════════════════════════════════════════════════════
// The ONE place where Hall Mate keeps its data.
//
// Created once in main.dart. Customer screens and manager screens both
// read and change these lists, so both sides always show the same thing:
// a request the customer sends appears in the manager's Requests,
// a counter offer from the manager appears in the customer's booking.
//
// Later (API): every list comes from the server and every method
// below sends a request to the server first.
// ══════════════════════════════════════════════════════════════
class AppDataController extends GetxController {
  RxList<VenueModel> venues = <VenueModel>[].obs;
  RxList<BookingModel> bookings = <BookingModel>[].obs;
  RxList<ChatModel> chats = <ChatModel>[].obs;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  // The areas of Karachi a venue can be in.
  // Home ("Near you") and the manager's venue form use the same list.
  List<String> areas = [
    'Gulshan-e-Iqbal',
    'Clifton',
    'DHA',
    'North Nazimabad',
    'PECHS',
    'Bahadurabad',
  ];

  // The dummy dates are counted from today, so they never go out of date.
  DateTime today = AppFormat.today();

  int nextBookingNumber = 1046; // the next booking is HM-1046
  int nextChatNumber = 6; // the next chat is c6
  int nextVenueNumber = 7; // the next venue is v7

  @override
  void onInit() {
    super.onInit();
    venues.addAll(dummyVenues());
    bookings.addAll(dummyBookings());
    chats.addAll(dummyChats());
    notifications.addAll(dummyNotifications());
  }

  // A date [days] after today (a minus number = before today)
  DateTime day(int days) {
    return DateTime(today.year, today.month, today.day + days);
  }

  // The same, with a time of day
  DateTime at(int days, int hour, int minute) {
    return DateTime(today.year, today.month, today.day + days, hour, minute);
  }

  // ════════════════════════ FIND ════════════════════════

  VenueModel venueById(String id) {
    for (var venue in venues) {
      if (venue.id == id) {
        return venue;
      }
    }
    return venues.first;
  }

  BookingModel bookingById(String id) {
    for (var booking in bookings) {
      if (booking.id == id) {
        return booking;
      }
    }
    return bookings.first;
  }

  ChatModel chatById(String id) {
    for (var chat in chats) {
      if (chat.id == id) {
        return chat;
      }
    }
    return chats.first;
  }

  // Only the venues customers can see (setup finished)
  List<VenueModel> liveVenues() {
    List<VenueModel> result = [];
    for (var venue in venues) {
      if (venue.isLive) {
        result.add(venue);
      }
    }
    return result;
  }

  List<BookingModel> bookingsOfCustomer(String customerName) {
    List<BookingModel> result = [];
    for (var booking in bookings) {
      if (booking.customerName == customerName) {
        result.add(booking);
      }
    }
    return result;
  }

  List<BookingModel> bookingsOfVenue(String venueId) {
    List<BookingModel> result = [];
    for (var booking in bookings) {
      if (booking.venueId == venueId) {
        result.add(booking);
      }
    }
    return result;
  }

  // A date is taken once a booking for it is accepted, paid or done.
  bool isDateBooked(String venueId, DateTime date) {
    for (var booking in bookings) {
      final bool sameVenue = booking.venueId == venueId;
      final bool sameDay = AppFormat.isSameDay(booking.eventDate, date);
      final bool takesTheDate = booking.status == 'Accepted' ||
          booking.status == 'Confirmed' ||
          booking.status == 'Completed';
      if (sameVenue && sameDay && takesTheDate) {
        return true;
      }
    }
    return false;
  }

  // ════════════════ BOOKING ACTIONS (both sides) ════════════════

  // Customer: sends a new request. Returns the new booking id.
  String sendRequest({
    required VenueModel venue,
    required String customerName,
    required String customerPhone,
    required String eventType,
    required DateTime date,
    required int guests,
    required int amount,
  }) {
    final String id = 'HM-$nextBookingNumber';
    nextBookingNumber = nextBookingNumber + 1;

    // insert(0, ...) puts the newest booking at the top of the lists
    bookings.insert(
      0,
      BookingModel(
        id: id,
        venueId: venue.id,
        venueName: venue.name,
        venuePhoto: venue.photoStyle,
        customerName: customerName,
        customerPhone: customerPhone,
        eventType: eventType,
        eventDate: date,
        guests: guests,
        listedRent: venue.rent,
        status: 'Requested',
        offers: [
          OfferModel(amount: amount, byManager: false, sentAt: DateTime.now()),
        ],
      ),
    );

    tellManager(
      venueId: venue.id,
      iconType: 'request',
      title: 'New booking request',
      message: '$customerName · $eventType · $guests guests · '
          'offered ${AppFormat.rupees(amount)}.',
      bookingId: id,
    );
    return id;
  }

  // Either side: sends a new price.
  void sendOffer(BookingModel booking, int amount, bool byManager) {
    booking.offers.add(
      OfferModel(amount: amount, byManager: byManager, sentAt: DateTime.now()),
    );
    booking.status = 'Negotiating';
    bookings.refresh(); // tells every Obx that something inside changed

    final String date = AppFormat.shortDate(booking.eventDate);
    if (byManager) {
      tellCustomer(
        customerName: booking.customerName,
        iconType: 'counter',
        title: 'New counter offer',
        message: '${booking.venueName} offered '
            '${AppFormat.rupees(amount)} for $date.',
        bookingId: booking.id,
      );
    } else {
      tellManager(
        venueId: booking.venueId,
        iconType: 'counter',
        title: 'New counter offer',
        message: '${booking.customerName} offered '
            '${AppFormat.rupees(amount)} for $date.',
        bookingId: booking.id,
      );
    }
  }

  // Either side: accepts the other side's latest price.
  void acceptOffer(BookingModel booking, bool byManager) {
    booking.status = 'Accepted';

    // The date is now taken, so other open requests for the
    // same venue on the same day are declined.
    for (var other in bookings) {
      final bool sameVenue = other.venueId == booking.venueId;
      final bool sameDay = AppFormat.isSameDay(other.eventDate, booking.eventDate);
      if (other.id != booking.id && sameVenue && sameDay && other.isOpen()) {
        other.status = 'Declined';
        tellCustomer(
          customerName: other.customerName,
          iconType: 'declined',
          title: 'Date not available',
          message: '${other.venueName} is now booked on '
              '${AppFormat.shortDate(other.eventDate)}.',
          bookingId: other.id,
        );
      }
    }
    bookings.refresh();

    final String price = AppFormat.rupees(booking.agreedAmount());
    final String advance = AppFormat.rupees(booking.advance());
    if (byManager) {
      tellCustomer(
        customerName: booking.customerName,
        iconType: 'accepted',
        title: 'Offer accepted',
        message: '${booking.venueName} accepted $price. '
            'Pay the $advance advance to confirm.',
        bookingId: booking.id,
      );
    } else {
      tellManager(
        venueId: booking.venueId,
        iconType: 'accepted',
        title: 'Offer accepted',
        message: '${booking.customerName} accepted $price. '
            'The $advance advance comes next.',
        bookingId: booking.id,
      );
    }
  }

  // Manager: says no to a request.
  void declineRequest(BookingModel booking) {
    booking.status = 'Declined';
    bookings.refresh();

    tellCustomer(
      customerName: booking.customerName,
      iconType: 'declined',
      title: 'Request declined',
      message: '${booking.venueName} declined your request for '
          '${AppFormat.shortDate(booking.eventDate)}.',
      bookingId: booking.id,
    );
  }

  // Customer: pays the 25% advance.
  void payAdvance(BookingModel booking, String method) {
    booking.status = 'Confirmed';
    booking.paymentMethod = method;
    bookings.refresh();

    tellManager(
      venueId: booking.venueId,
      iconType: 'payment',
      title: 'Advance received',
      message: '${booking.customerName} paid '
          '${AppFormat.rupees(booking.advance())} for '
          '${AppFormat.shortDate(booking.eventDate)}.',
      bookingId: booking.id,
    );
  }

  // Customer: writes a review after the event.
  void addReview(BookingModel booking, int rating, String text) {
    final VenueModel venue = venueById(booking.venueId);
    final DateTime d = booking.eventDate;
    venue.reviews.insert(
      0,
      ReviewModel(
        customerName: booking.customerName,
        eventLine:
            '${booking.eventType} · ${AppFormat.monthNames[d.month - 1]} ${d.year}',
        rating: rating,
        text: text,
      ),
    );
    booking.isReviewed = true;
    venues.refresh();
    bookings.refresh();

    tellManager(
      venueId: booking.venueId,
      iconType: 'review',
      title: 'New review',
      message: '${booking.customerName} rated your venue $rating stars.',
      bookingId: booking.id,
    );
  }

  // ════════════════ MANAGER DASHBOARD MATHS ════════════════

  int countByStatus(String venueId, String status) {
    int count = 0;
    for (var booking in bookingsOfVenue(venueId)) {
      if (booking.status == status) {
        count = count + 1;
      }
    }
    return count;
  }

  // Advances paid through the app (Confirmed + Completed bookings)
  int advancesReceived(String venueId) {
    int total = 0;
    for (var booking in bookingsOfVenue(venueId)) {
      if (booking.status == 'Confirmed' || booking.status == 'Completed') {
        total = total + booking.advance();
      }
    }
    return total;
  }

  // Balances the customers will pay at the venue (Confirmed bookings)
  int balanceToCollect(String venueId) {
    int total = 0;
    for (var booking in bookingsOfVenue(venueId)) {
      if (booking.status == 'Confirmed') {
        total = total + booking.balance();
      }
    }
    return total;
  }

  // ════════════════ VENUE (manager) ════════════════

  // A new manager signed up: an empty venue is made for her.
  String addVenue({
    required String name,
    required String type,
    required String managerName,
  }) {
    final String id = 'v$nextVenueNumber';
    nextVenueNumber = nextVenueNumber + 1;

    venues.add(
      VenueModel(
        id: id,
        name: name,
        type: type,
        area: '',
        address: '',
        rent: 0,
        minGuests: 100,
        maxGuests: 300,
        about: '',
        features: [],
        photoStyle: 'emerald',
        managerName: managerName,
        isLive: false,
        media: [],
        reviews: [],
      ),
    );
    return id;
  }

  // A venue is shown to customers once it has a rent, an area and
  // at least one photo. Called after every save and every photo change.
  void checkLive(VenueModel venue) {
    venue.isLive =
        venue.rent > 0 && venue.area.isNotEmpty && venue.photos().isNotEmpty;
    venues.refresh();
  }

  // New photos go after the other photos, new videos go at the end.
  // (Photos stay before videos, so the first photo is the cover.)
  void addMedia(VenueModel venue, List<MediaModel> items) {
    for (var item in items) {
      if (item.isVideo) {
        venue.media.add(item);
      } else {
        venue.media.insert(venue.photos().length, item);
      }
    }
    checkLive(venue);
  }

  // The cover is the first photo, so moving a photo to the top makes it the cover.
  void setCover(VenueModel venue, MediaModel item) {
    venue.media.remove(item);
    venue.media.insert(0, item);
    venues.refresh();
  }

  void deleteMedia(VenueModel venue, MediaModel item) {
    venue.media.remove(item);
    checkLive(venue);
  }

  // ════════════════ CHAT (both sides) ════════════════

  List<ChatModel> chatsOfCustomer(String customerName) {
    List<ChatModel> result = [];
    for (var chat in chats) {
      if (chat.customerName == customerName) {
        result.add(chat);
      }
    }
    return result;
  }

  List<ChatModel> chatsOfVenue(String venueId) {
    List<ChatModel> result = [];
    for (var chat in chats) {
      if (chat.venueId == venueId) {
        result.add(chat);
      }
    }
    return result;
  }

  // Finds the chat between this customer and this venue.
  // If they never talked, a new empty chat is made.
  ChatModel chatFor(BookingModel booking) {
    for (var chat in chats) {
      if (chat.venueId == booking.venueId &&
          chat.customerName == booking.customerName) {
        return chat;
      }
    }

    final VenueModel venue = venueById(booking.venueId);
    final ChatModel chat = ChatModel(
      id: 'c$nextChatNumber',
      venueId: venue.id,
      venueName: venue.name,
      venuePhoto: venue.photoStyle,
      managerName: venue.managerName,
      customerName: booking.customerName,
      bookingId: booking.id,
      messages: [],
    );
    nextChatNumber = nextChatNumber + 1;
    chats.insert(0, chat);
    return chat;
  }

  void sendMessage(ChatModel chat, String text, bool byManager) {
    chat.messages.add(
      MessageModel(text: text, byManager: byManager, sentAt: DateTime.now()),
    );
    // Move this chat to the top of the list
    chats.remove(chat);
    chats.insert(0, chat);

    if (byManager) {
      chat.unreadForCustomer = chat.unreadForCustomer + 1;
      tellCustomer(
        customerName: chat.customerName,
        iconType: 'message',
        title: 'New message from ${chat.venueName}',
        message: '“$text”',
        chatId: chat.id,
      );
    } else {
      chat.unreadForManager = chat.unreadForManager + 1;
      tellManager(
        venueId: chat.venueId,
        iconType: 'message',
        title: 'New message from ${chat.customerName}',
        message: '“$text”',
        chatId: chat.id,
      );
    }
    chats.refresh();
  }

  // The chat is opened: its unread number goes back to 0
  void markChatRead(ChatModel chat, bool byManager) {
    if (byManager) {
      chat.unreadForManager = 0;
    } else {
      chat.unreadForCustomer = 0;
    }
    chats.refresh();
  }

  // ════════════════ NOTIFICATIONS (both sides) ════════════════

  void tellManager({
    required String venueId,
    required String iconType,
    required String title,
    required String message,
    String? bookingId,
    String? chatId,
  }) {
    notifications.insert(
      0,
      NotificationModel(
        forManager: true,
        venueId: venueId,
        iconType: iconType,
        title: title,
        message: message,
        group: 'TODAY',
        time: 'Just now',
        bookingId: bookingId,
        chatId: chatId,
      ),
    );
  }

  void tellCustomer({
    required String customerName,
    required String iconType,
    required String title,
    required String message,
    String? bookingId,
    String? chatId,
  }) {
    notifications.insert(
      0,
      NotificationModel(
        forManager: false,
        customerName: customerName,
        iconType: iconType,
        title: title,
        message: message,
        group: 'TODAY',
        time: 'Just now',
        bookingId: bookingId,
        chatId: chatId,
      ),
    );
  }

  // The notifications of one manager (key = venue id)
  // or of one customer (key = customer name)
  List<NotificationModel> notificationsFor(bool forManager, String key) {
    List<NotificationModel> result = [];
    for (var item in notifications) {
      if (forManager && item.forManager && item.venueId == key) {
        result.add(item);
      } else if (!forManager && !item.forManager && item.customerName == key) {
        result.add(item);
      }
    }
    return result;
  }

  int unreadCount(bool forManager, String key) {
    int count = 0;
    for (var item in notificationsFor(forManager, key)) {
      if (item.isUnread) {
        count = count + 1;
      }
    }
    return count;
  }

  void markRead(NotificationModel item) {
    item.isUnread = false;
    notifications.refresh();
  }

  void markAllRead(bool forManager, String key) {
    for (var item in notificationsFor(forManager, key)) {
      item.isUnread = false;
    }
    notifications.refresh();
  }

  // ══════════════════════════════════════════════════════════════
  // DUMMY DATA (until the API is ready)
  // Every number below follows the maths in BookingModel:
  // advance = price ÷ 4, balance = price - advance.
  // ══════════════════════════════════════════════════════════════

  List<VenueModel> dummyVenues() {
    return [
      VenueModel(
        id: 'v1',
        name: 'Shaan Banquet Hall',
        type: 'Banquet',
        area: 'Gulshan-e-Iqbal',
        address: 'Block 13-D, University Road, Karachi',
        rent: 300000,
        minGuests: 150,
        maxGuests: 500,
        about: 'A family-friendly banquet hall with a separate family hall, '
            'on-site parking and room for up to 500 guests. Bring the caterer '
            'of your choice. Ideal for walimas, mehndis and office events.',
        features: ['Family hall', 'Parking', 'Generator'],
        photoStyle: 'emerald',
        managerName: 'Imran Siddiqui',
        isLive: true,
        media: [
          MediaModel(title: 'Main hall', photoStyle: 'emerald'),
          MediaModel(title: 'Stage', photoStyle: 'marigold'),
          MediaModel(title: 'Family hall', photoStyle: 'slate'),
          MediaModel(title: 'Entrance', photoStyle: 'marigold'),
          MediaModel(title: 'Dining area', photoStyle: 'emerald'),
          MediaModel(title: 'Bridal room', photoStyle: 'slate'),
          MediaModel(title: 'Lighting', photoStyle: 'marigold'),
          MediaModel(title: 'Parking', photoStyle: 'slate'),
          MediaModel(title: 'Lobby', photoStyle: 'emerald'),
          MediaModel(title: 'Stage side', photoStyle: 'marigold'),
          MediaModel(title: 'Table setup', photoStyle: 'emerald'),
          MediaModel(title: 'Garden entry', photoStyle: 'slate'),
          MediaModel(title: 'Exterior', photoStyle: 'marigold'),
          MediaModel(title: 'Waiting area', photoStyle: 'emerald'),
          MediaModel(title: 'Night view', photoStyle: 'slate'),
          MediaModel(title: 'Walkthrough video', isVideo: true, photoStyle: 'slate'),
        ],
        reviews: [
          ReviewModel(
            customerName: 'Sana Khan',
            eventLine: 'Walima · ${AppFormat.monthNames[day(-18).month - 1]} ${day(-18).year}',
            rating: 5,
            text: 'The staff handled 400 guests without any delay. '
                'The family hall was a big plus.',
          ),
          ReviewModel(
            customerName: 'Ayesha Noor',
            eventLine: 'Birthday · Oct 2026',
            rating: 4,
            text: 'Lovely décor and quick service. Booking through the app was easy.',
          ),
          ReviewModel(
            customerName: 'Hamza Qureshi',
            eventLine: 'Mehndi · Sep 2026',
            rating: 4,
            text: 'Good hall, but the parking was full by 9 pm.',
          ),
        ],
      ),
      VenueModel(
        id: 'v2',
        name: 'Royal Palm Banquet',
        type: 'Banquet',
        area: 'Gulshan-e-Iqbal',
        address: 'Block 6, Rashid Minhas Road, Karachi',
        rent: 250000,
        minGuests: 120,
        maxGuests: 400,
        about: 'A modern banquet with a separate family hall and a backup '
            'generator. Popular for mehndis and engagements.',
        features: ['Family hall', 'Generator'],
        photoStyle: 'marigold',
        managerName: 'Kamran Ali',
        isLive: true,
        media: [
          MediaModel(title: 'Main hall', photoStyle: 'marigold'),
          MediaModel(title: 'Stage', photoStyle: 'emerald'),
          MediaModel(title: 'Family hall', photoStyle: 'slate'),
        ],
        reviews: [
          ReviewModel(
            customerName: 'Maria Siddiqui',
            eventLine: 'Mehndi · Oct 2026',
            rating: 5,
            text: 'Very helpful staff and a beautiful stage.',
          ),
          ReviewModel(
            customerName: 'Adeel Shah',
            eventLine: 'Engagement · Sep 2026',
            rating: 4,
            text: 'Good value for the area.',
          ),
        ],
      ),
      VenueModel(
        id: 'v3',
        name: 'Al-Noor Banquet & Marquee',
        type: 'Banquet',
        area: 'Gulshan-e-Iqbal',
        address: 'Block 10-A, Main Rashid Minhas Road, Karachi',
        rent: 220000,
        minGuests: 150,
        maxGuests: 600,
        about: 'A large hall with a marquee for bigger events and parking '
            'for 120 cars.',
        features: ['Parking', 'Generator'],
        photoStyle: 'slate',
        managerName: 'Nadia Hussain',
        isLive: true,
        media: [
          MediaModel(title: 'Main hall', photoStyle: 'slate'),
          MediaModel(title: 'Marquee', photoStyle: 'emerald'),
          MediaModel(title: 'Parking', photoStyle: 'marigold'),
        ],
        reviews: [
          ReviewModel(
            customerName: 'Taha Rizvi',
            eventLine: 'Walima · Oct 2026',
            rating: 4,
            text: 'Plenty of space and easy parking.',
          ),
        ],
      ),
      VenueModel(
        id: 'v4',
        name: 'Noor Ballroom',
        type: 'Ballroom',
        area: 'Clifton',
        address: 'Block 5, Clifton, Karachi',
        rent: 450000,
        minGuests: 100,
        maxGuests: 350,
        about: 'An elegant ballroom with a fixed stage, a wooden dance floor, '
            'a full sound system and valet parking.',
        features: ['Stage', 'Sound system', 'Valet'],
        photoStyle: 'marigold',
        managerName: 'Omar Farooq',
        isLive: true,
        media: [
          MediaModel(title: 'Ballroom', photoStyle: 'marigold'),
          MediaModel(title: 'Dance floor', photoStyle: 'slate'),
          MediaModel(title: 'Chandeliers', photoStyle: 'emerald'),
          MediaModel(title: 'Ballroom tour', isVideo: true, photoStyle: 'slate'),
        ],
        reviews: [
          ReviewModel(
            customerName: 'Mehwish Ali',
            eventLine: 'Reception · Oct 2026',
            rating: 5,
            text: 'The lighting and sound were perfect.',
          ),
          ReviewModel(
            customerName: 'Fahad Iqbal',
            eventLine: 'Corporate · Sep 2026',
            rating: 4,
            text: 'Great venue, valet was a little slow.',
          ),
        ],
      ),
      VenueModel(
        id: 'v5',
        name: 'Gulshan Garden Lawn',
        type: 'Outdoor',
        area: 'Gulshan-e-Iqbal',
        address: 'Block 3, Gulshan-e-Iqbal, Karachi',
        rent: 280000,
        minGuests: 200,
        maxGuests: 800,
        about: 'A green lawn for up to 800 guests. A covered marquee can be '
            'set up within 2 hours if rain is forecast.',
        features: ['Marquee', 'Generator', 'Lighting'],
        photoStyle: 'slate',
        managerName: 'Saad Malik',
        isLive: true,
        media: [
          MediaModel(title: 'Lawn', photoStyle: 'slate'),
          MediaModel(title: 'Marquee', photoStyle: 'emerald'),
          MediaModel(title: 'Night lights', photoStyle: 'marigold'),
        ],
        reviews: [
          ReviewModel(
            customerName: 'Hina Javed',
            eventLine: 'Mehndi · Oct 2026',
            rating: 4,
            text: 'Beautiful lights at night.',
          ),
          ReviewModel(
            customerName: 'Usama Khan',
            eventLine: 'Barat · Sep 2026',
            rating: 4,
            text: 'The marquee kept everyone dry in the rain.',
          ),
        ],
      ),
      VenueModel(
        id: 'v6',
        name: 'Seaside Garden Lawn',
        type: 'Outdoor',
        area: 'DHA',
        address: 'Phase 8, DHA, Karachi',
        rent: 350000,
        minGuests: 300,
        maxGuests: 1000,
        about: 'A seaside lawn in DHA Phase 8 for big outdoor weddings.',
        features: ['Marquee', 'Generator', 'Lighting'],
        photoStyle: 'emerald',
        managerName: 'Rabia Khan',
        isLive: true,
        media: [
          MediaModel(title: 'Lawn', photoStyle: 'emerald'),
          MediaModel(title: 'Sea view', photoStyle: 'slate'),
          MediaModel(title: 'Stage', photoStyle: 'marigold'),
        ],
        reviews: [
          ReviewModel(
            customerName: 'Sara Ahmed',
            eventLine: 'Walima · Oct 2026',
            rating: 5,
            text: 'The sea breeze made the evening perfect.',
          ),
        ],
      ),
    ];
  }

  List<BookingModel> dummyBookings() {
    return [
      // ── Ali Raza's bookings (the demo customer) ──

      // Shaan sent a counter offer. Ali's turn.
      // If Ali accepts: price 2,80,000 -> advance 70,000, balance 2,10,000
      BookingModel(
        id: 'HM-1042',
        venueId: 'v1',
        venueName: 'Shaan Banquet Hall',
        venuePhoto: 'emerald',
        customerName: 'Ali Raza',
        customerPhone: '+92 300 1234567',
        eventType: 'Walima',
        eventDate: day(21),
        guests: 300,
        listedRent: 300000,
        status: 'Negotiating',
        offers: [
          OfferModel(amount: 250000, byManager: false, sentAt: at(-2, 21, 14)),
          OfferModel(amount: 280000, byManager: true, sentAt: at(-1, 11, 2)),
        ],
      ),
      // Waiting for Royal Palm to reply.
      BookingModel(
        id: 'HM-1043',
        venueId: 'v2',
        venueName: 'Royal Palm Banquet',
        venuePhoto: 'marigold',
        customerName: 'Ali Raza',
        customerPhone: '+92 300 1234567',
        eventType: 'Mehndi',
        eventDate: day(35),
        guests: 150,
        listedRent: 250000,
        status: 'Requested',
        offers: [
          OfferModel(amount: 230000, byManager: false, sentAt: at(-1, 18, 40)),
        ],
      ),
      // Paid: price 2,60,000 -> advance 65,000, balance 1,95,000
      BookingModel(
        id: 'HM-1031',
        venueId: 'v5',
        venueName: 'Gulshan Garden Lawn',
        venuePhoto: 'slate',
        customerName: 'Ali Raza',
        customerPhone: '+92 300 1234567',
        eventType: 'Barat',
        eventDate: day(48),
        guests: 220,
        listedRent: 280000,
        status: 'Confirmed',
        paymentMethod: 'JazzCash',
        offers: [
          OfferModel(amount: 240000, byManager: false, sentAt: at(-9, 20, 5)),
          OfferModel(amount: 260000, byManager: true, sentAt: at(-8, 10, 30)),
        ],
      ),
      // Done, no review yet: price 4,20,000 -> advance 1,05,000
      BookingModel(
        id: 'HM-0987',
        venueId: 'v4',
        venueName: 'Noor Ballroom',
        venuePhoto: 'marigold',
        customerName: 'Ali Raza',
        customerPhone: '+92 300 1234567',
        eventType: 'Birthday',
        eventDate: day(-21),
        guests: 120,
        listedRent: 450000,
        status: 'Completed',
        paymentMethod: 'Debit / credit card',
        offers: [
          OfferModel(amount: 400000, byManager: false, sentAt: at(-40, 19, 0)),
          OfferModel(amount: 420000, byManager: true, sentAt: at(-39, 12, 15)),
        ],
      ),

      // ── Other customers of Shaan Banquet Hall (for the demo manager) ──

      BookingModel(
        id: 'HM-1045',
        venueId: 'v1',
        venueName: 'Shaan Banquet Hall',
        venuePhoto: 'emerald',
        customerName: 'Usman Tariq',
        customerPhone: '+92 321 5550142',
        eventType: 'Barat',
        eventDate: day(34),
        guests: 400,
        listedRent: 300000,
        status: 'Requested',
        offers: [
          OfferModel(amount: 265000, byManager: false, sentAt: at(-1, 23, 10)),
        ],
      ),
      BookingModel(
        id: 'HM-1044',
        venueId: 'v1',
        venueName: 'Shaan Banquet Hall',
        venuePhoto: 'emerald',
        customerName: 'Hira Ahmed',
        customerPhone: '+92 333 5550198',
        eventType: 'Mehndi',
        eventDate: day(28),
        guests: 180,
        listedRent: 300000,
        status: 'Requested',
        offers: [
          OfferModel(amount: 300000, byManager: false, sentAt: at(-1, 20, 30)),
        ],
      ),
      // Zainab answered Imran's counter. Imran's turn.
      BookingModel(
        id: 'HM-1039',
        venueId: 'v1',
        venueName: 'Shaan Banquet Hall',
        venuePhoto: 'emerald',
        customerName: 'Zainab Malik',
        customerPhone: '+92 345 5550177',
        eventType: 'Birthday',
        eventDate: day(12),
        guests: 220,
        listedRent: 300000,
        status: 'Negotiating',
        offers: [
          OfferModel(amount: 240000, byManager: false, sentAt: at(-3, 17, 0)),
          OfferModel(amount: 270000, byManager: true, sentAt: at(-2, 10, 45)),
          OfferModel(amount: 255000, byManager: false, sentAt: at(-1, 16, 20)),
        ],
      ),
      // Paid: price 2,90,000 -> advance 72,500, balance 2,17,500
      BookingModel(
        id: 'HM-1036',
        venueId: 'v1',
        venueName: 'Shaan Banquet Hall',
        venuePhoto: 'emerald',
        customerName: 'Faisal Mehmood',
        customerPhone: '+92 300 5550111',
        eventType: 'Mehndi',
        eventDate: day(4),
        guests: 250,
        listedRent: 300000,
        status: 'Confirmed',
        paymentMethod: 'Easypaisa',
        offers: [
          OfferModel(amount: 280000, byManager: false, sentAt: at(-12, 19, 30)),
          OfferModel(amount: 290000, byManager: true, sentAt: at(-11, 11, 0)),
        ],
      ),
      // Done and reviewed: price 3,00,000 -> advance 75,000
      BookingModel(
        id: 'HM-1019',
        venueId: 'v1',
        venueName: 'Shaan Banquet Hall',
        venuePhoto: 'emerald',
        customerName: 'Sana Khan',
        customerPhone: '+92 312 5550133',
        eventType: 'Walima',
        eventDate: day(-18),
        guests: 400,
        listedRent: 300000,
        status: 'Completed',
        paymentMethod: 'Bank transfer',
        isReviewed: true,
        offers: [
          OfferModel(amount: 300000, byManager: false, sentAt: at(-50, 20, 0)),
        ],
      ),
      BookingModel(
        id: 'HM-1012',
        venueId: 'v1',
        venueName: 'Shaan Banquet Hall',
        venuePhoto: 'emerald',
        customerName: 'Bilal Khan',
        customerPhone: '+92 300 5550166',
        eventType: 'Birthday',
        eventDate: day(16),
        guests: 200,
        listedRent: 300000,
        status: 'Declined',
        offers: [
          OfferModel(amount: 180000, byManager: false, sentAt: at(-6, 15, 45)),
        ],
      ),
    ];
  }

  List<ChatModel> dummyChats() {
    return [
      ChatModel(
        id: 'c1',
        venueId: 'v1',
        venueName: 'Shaan Banquet Hall',
        venuePhoto: 'emerald',
        managerName: 'Imran Siddiqui',
        customerName: 'Ali Raza',
        bookingId: 'HM-1042',
        unreadForCustomer: 1,
        messages: [
          MessageModel(
            text: 'Assalam-o-Alaikum Ali! Thanks for your request for '
                '${AppFormat.shortDate(day(21))}.',
            byManager: true,
            sentAt: at(-2, 21, 30),
          ),
          MessageModel(
            text: 'Walaikum Assalam. Can the stage be white and gold?',
            byManager: false,
            sentAt: at(-2, 21, 41),
          ),
          MessageModel(
            text: 'Sure, a white & gold stage is possible. '
                'I have sent you a new offer of Rs 2,80,000.',
            byManager: true,
            sentAt: at(-1, 11, 5),
          ),
        ],
      ),
      ChatModel(
        id: 'c4',
        venueId: 'v1',
        venueName: 'Shaan Banquet Hall',
        venuePhoto: 'emerald',
        managerName: 'Imran Siddiqui',
        customerName: 'Hira Ahmed',
        bookingId: 'HM-1044',
        unreadForManager: 1,
        messages: [
          MessageModel(
            text: 'Is there parking for 60 cars?',
            byManager: false,
            sentAt: at(-1, 20, 35),
          ),
        ],
      ),
      ChatModel(
        id: 'c2',
        venueId: 'v2',
        venueName: 'Royal Palm Banquet',
        venuePhoto: 'marigold',
        managerName: 'Kamran Ali',
        customerName: 'Ali Raza',
        bookingId: 'HM-1043',
        messages: [
          MessageModel(
            text: 'Is the date still free?',
            byManager: false,
            sentAt: at(-1, 18, 45),
          ),
          MessageModel(
            text: 'Yes, we can hold it for you until tomorrow.',
            byManager: true,
            sentAt: at(-1, 19, 10),
          ),
        ],
      ),
      ChatModel(
        id: 'c5',
        venueId: 'v1',
        venueName: 'Shaan Banquet Hall',
        venuePhoto: 'emerald',
        managerName: 'Imran Siddiqui',
        customerName: 'Zainab Malik',
        bookingId: 'HM-1039',
        messages: [
          MessageModel(
            text: 'Can you do Rs 2,55,000? That is my final offer.',
            byManager: false,
            sentAt: at(-1, 16, 25),
          ),
        ],
      ),
      ChatModel(
        id: 'c3',
        venueId: 'v5',
        venueName: 'Gulshan Garden Lawn',
        venuePhoto: 'slate',
        managerName: 'Saad Malik',
        customerName: 'Ali Raza',
        bookingId: 'HM-1031',
        messages: [
          MessageModel(
            text: 'The rain backup marquee is included.',
            byManager: true,
            sentAt: at(-8, 10, 40),
          ),
          MessageModel(
            text: 'Great, thank you!',
            byManager: false,
            sentAt: at(-8, 10, 52),
          ),
        ],
      ),
    ];
  }

  List<NotificationModel> dummyNotifications() {
    return [
      // ── Ali Raza (customer) ──
      NotificationModel(
        forManager: false,
        customerName: 'Ali Raza',
        iconType: 'request',
        title: 'Request sent',
        message: 'Your request to Royal Palm Banquet is waiting for a reply.',
        group: 'YESTERDAY',
        time: '6:40 pm',
        isUnread: false,
        bookingId: 'HM-1043',
      ),
      NotificationModel(
        forManager: false,
        customerName: 'Ali Raza',
        iconType: 'message',
        title: 'New message from Shaan Banquet Hall',
        message: '“Sure, a white & gold stage is possible.”',
        group: 'YESTERDAY',
        time: '11:05 am',
        chatId: 'c1',
      ),
      NotificationModel(
        forManager: false,
        customerName: 'Ali Raza',
        iconType: 'counter',
        title: 'New counter offer',
        message: 'Shaan Banquet Hall offered Rs 2,80,000 for '
            '${AppFormat.shortDate(day(21))}.',
        group: 'YESTERDAY',
        time: '11:02 am',
        bookingId: 'HM-1042',
      ),
      NotificationModel(
        forManager: false,
        customerName: 'Ali Raza',
        iconType: 'payment',
        title: 'Booking confirmed',
        message: 'Gulshan Garden Lawn received your Rs 65,000 advance.',
        group: 'EARLIER',
        time: '${day(-8).day} ${AppFormat.monthNames[day(-8).month - 1]}',
        isUnread: false,
        bookingId: 'HM-1031',
      ),
      NotificationModel(
        forManager: false,
        customerName: 'Ali Raza',
        iconType: 'review',
        title: 'How was your event?',
        message: 'Rate Noor Ballroom and help other families choose.',
        group: 'EARLIER',
        time: '${day(-20).day} ${AppFormat.monthNames[day(-20).month - 1]}',
        isUnread: false,
        bookingId: 'HM-0987',
      ),

      // ── Shaan Banquet Hall (manager Imran) ──
      NotificationModel(
        forManager: true,
        venueId: 'v1',
        iconType: 'request',
        title: 'New booking request',
        message: 'Usman Tariq · Barat · 400 guests · offered Rs 2,65,000.',
        group: 'YESTERDAY',
        time: '11:10 pm',
        bookingId: 'HM-1045',
      ),
      NotificationModel(
        forManager: true,
        venueId: 'v1',
        iconType: 'message',
        title: 'New message from Hira Ahmed',
        message: '“Is there parking for 60 cars?”',
        group: 'YESTERDAY',
        time: '8:35 pm',
        chatId: 'c4',
      ),
      NotificationModel(
        forManager: true,
        venueId: 'v1',
        iconType: 'request',
        title: 'New booking request',
        message: 'Hira Ahmed · Mehndi · 180 guests · offered Rs 3,00,000.',
        group: 'YESTERDAY',
        time: '8:30 pm',
        bookingId: 'HM-1044',
      ),
      NotificationModel(
        forManager: true,
        venueId: 'v1',
        iconType: 'counter',
        title: 'New counter offer',
        message: 'Zainab Malik offered Rs 2,55,000 for '
            '${AppFormat.shortDate(day(12))}.',
        group: 'YESTERDAY',
        time: '4:20 pm',
        bookingId: 'HM-1039',
      ),
      NotificationModel(
        forManager: true,
        venueId: 'v1',
        iconType: 'payment',
        title: 'Advance received',
        message: 'Faisal Mehmood paid Rs 72,500 for '
            '${AppFormat.shortDate(day(4))}.',
        group: 'EARLIER',
        time: '${day(-11).day} ${AppFormat.monthNames[day(-11).month - 1]}',
        isUnread: false,
        bookingId: 'HM-1036',
      ),
      NotificationModel(
        forManager: true,
        venueId: 'v1',
        iconType: 'review',
        title: 'New review',
        message: 'Sana Khan rated your venue 5 stars.',
        group: 'EARLIER',
        time: '${day(-16).day} ${AppFormat.monthNames[day(-16).month - 1]}',
        isUnread: false,
        bookingId: 'HM-1019',
      ),
    ];
  }
}
