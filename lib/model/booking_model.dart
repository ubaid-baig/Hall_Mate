// One price sent during the bargaining.
class OfferModel {
  int amount; // total rent offered, in rupees
  bool byManager; // true = the venue sent it, false = the customer sent it
  DateTime sentAt;

  OfferModel({
    required this.amount,
    required this.byManager,
    required this.sentAt,
  });
}

// One booking between a customer and a venue.
// The customer side and the manager side both read the SAME object,
// so a change made by one side shows on the other side straight away.
//
// Status flow:
// Requested -> Negotiating -> Accepted -> Confirmed -> Completed
// (or Declined by the manager)
class BookingModel {
  String id; // for example 'HM-1042'
  String venueId;
  String venueName;
  String venuePhoto; // DUMMY ONLY: colour of the venue box
  String customerName;
  String customerPhone;
  String eventType; // Walima, Barat, Mehndi, Birthday, Corporate
  DateTime eventDate;
  int guests;
  int listedRent; // the venue's rent when the request was sent
  String status;
  List<OfferModel> offers;
  String paymentMethod; // filled when the advance is paid
  bool isReviewed;

  BookingModel({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.venuePhoto,
    required this.customerName,
    required this.customerPhone,
    required this.eventType,
    required this.eventDate,
    required this.guests,
    required this.listedRent,
    required this.status,
    required this.offers,
    this.paymentMethod = '',
    this.isReviewed = false,
  });

  // ══════════════ All the booking maths lives here ══════════════

  // The advance is 25% of the price. ( ~/ divides and drops the decimals )
  static int advanceOf(int amount) {
    return amount ~/ 4;
  }

  // "17% below the listed rent"
  // percent = (listed - amount) x 100 / listed, rounded
  static String compareWithListed(int amount, int listed) {
    if (amount <= 0) {
      return 'Enter your price';
    }
    if (amount == listed) {
      return 'Same as the listed rent';
    }
    if (amount < listed) {
      final int percent = ((listed - amount) * 100 / listed).round();
      return '$percent% below the listed rent';
    }
    final int percent = ((amount - listed) * 100 / listed).round();
    return '$percent% above the listed rent';
  }

  OfferModel latestOffer() {
    return offers.last;
  }

  // The price both sides agreed on (the latest offer once it is accepted)
  int agreedAmount() {
    return latestOffer().amount;
  }

  int advance() {
    return advanceOf(agreedAmount());
  }

  // What is left to pay at the venue
  int balance() {
    return agreedAmount() - advance();
  }

  // The date the customer sent the request = time of the first offer
  DateTime requestedOn() {
    return offers.first.sentAt;
  }

  // Still bargaining?
  bool isOpen() {
    return status == 'Requested' || status == 'Negotiating';
  }

  // The customer sent the latest offer, so the manager must answer
  bool isManagerTurn() {
    return isOpen() && !latestOffer().byManager;
  }

  // The manager sent the latest offer, so the customer must answer
  bool isCustomerTurn() {
    return isOpen() && latestOffer().byManager;
  }

  // Which circle of the step tracker is lit.
  // 5 = every step done (Completed)
  int stepIndex() {
    if (status == 'Negotiating') {
      return 1;
    } else if (status == 'Accepted') {
      return 2;
    } else if (status == 'Confirmed') {
      return 3;
    } else if (status == 'Completed') {
      return 5;
    }
    return 0; // Requested
  }
}
