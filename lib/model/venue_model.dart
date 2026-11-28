// One photo or video of a venue.
class MediaModel {
  String title; // for example 'Main hall'
  bool isVideo;
  // DUMMY ONLY: the colour of the grey box until a real file is picked
  // ('emerald', 'marigold' or 'slate')
  String photoStyle;
  // The path of a photo or video the manager picked from the phone.
  // null = dummy item (only a coloured box is shown)
  String? filePath;

  MediaModel({
    required this.title,
    this.isVideo = false,
    this.photoStyle = 'emerald',
    this.filePath,
  });
}

// One review a customer wrote after the event.
class ReviewModel {
  String customerName;
  String eventLine; // for example 'Walima · Nov 2026'
  int rating; // 1 to 5
  String text;

  ReviewModel({
    required this.customerName,
    required this.eventLine,
    required this.rating,
    required this.text,
  });
}

class VenueModel {
  String id; // for example 'v1'
  String name;
  String type; // 'Ballroom', 'Banquet' or 'Outdoor'
  String area; // for example 'Gulshan-e-Iqbal'
  String address;
  int rent; // rent for one event, in rupees
  int minGuests;
  int maxGuests;
  String about;
  List<String> features; // for example ['Family hall', 'Parking']
  String photoStyle; // DUMMY ONLY: colour of the cover box
  String managerName;
  // false = the manager has not finished the setup, so customers can't see it
  bool isLive;
  List<MediaModel> media;
  List<ReviewModel> reviews;

  VenueModel({
    required this.id,
    required this.name,
    required this.type,
    required this.area,
    required this.address,
    required this.rent,
    required this.minGuests,
    required this.maxGuests,
    required this.about,
    required this.features,
    required this.photoStyle,
    required this.managerName,
    required this.isLive,
    required this.media,
    required this.reviews,
  });

  // "Gulshan-e-Iqbal · up to 500 guests"
  String subtitle() {
    return '$area · up to $maxGuests guests';
  }

  // The photos only (videos are left out)
  List<MediaModel> photos() {
    List<MediaModel> result = [];
    for (var item in media) {
      if (!item.isVideo) {
        result.add(item);
      }
    }
    return result;
  }

  List<MediaModel> videos() {
    List<MediaModel> result = [];
    for (var item in media) {
      if (item.isVideo) {
        result.add(item);
      }
    }
    return result;
  }

  // The cover is always the first photo in the list.
  // null when the venue has no photo yet.
  MediaModel? cover() {
    final List<MediaModel> list = photos();
    if (list.isEmpty) {
      return null;
    }
    return list.first;
  }

  // The cover, or a grey box when there is no photo yet
  MediaModel coverOrPlaceholder() {
    final MediaModel? photo = cover();
    if (photo == null) {
      return MediaModel(title: 'No photo yet', photoStyle: photoStyle);
    }
    return photo;
  }

  // "15 photos · 1 video"
  String mediaCountText() {
    final int p = photos().length;
    final int v = videos().length;
    return '$p photo${p == 1 ? '' : 's'} · $v video${v == 1 ? '' : 's'}';
  }

  // Average of all the review stars, for example 4.3
  double averageRating() {
    if (reviews.isEmpty) {
      return 0;
    }
    int total = 0;
    for (var review in reviews) {
      total = total + review.rating;
    }
    return total / reviews.length;
  }

  // "4.3", or "New" when there are no reviews yet
  String ratingText() {
    if (reviews.isEmpty) {
      return 'New';
    }
    return averageRating().toStringAsFixed(1);
  }
}
