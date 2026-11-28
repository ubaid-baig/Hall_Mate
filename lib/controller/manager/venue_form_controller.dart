import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/view/manager/venue/media_manager_screen.dart';

// One form for every venue type. Only the 3 switches in the
// "<type> details" card change with the type (Banquet, Ballroom, Outdoor).
class VenueFormController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();
  final AuthController auth = Get.find<AuthController>();

  // The fields start with what the venue already has
  VenueFormController() {
    loadVenue();
  }

  VenueModel venue() {
    return data.venueById(auth.venueId());
  }

  // ── Text fields ──
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  TextEditingController minGuestsController = TextEditingController();
  TextEditingController maxGuestsController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  // ── Area: picked from the same list customers search by ──
  RxString selectedArea = ''.obs;

  List<String> areas() {
    return data.areas;
  }

  void selectArea(String area) {
    selectedArea.value = area;
  }

  // ── About: live "120 / 600" counter ──
  static const int aboutMaxLength = 600;

  RxInt aboutLength = 0.obs;

  void updateAboutLength(String text) {
    aboutLength.value = text.length;
  }

  // ── The switches of each venue type ──
  // These names are the same ones customers filter by.
  Map<String, List<String>> featuresByType = {
    'Banquet': ['Family hall', 'Parking', 'Generator'],
    'Ballroom': ['Stage', 'Sound system', 'Valet'],
    'Outdoor': ['Marquee', 'Generator', 'Lighting'],
  };

  Map<String, String> featureNotes = {
    'Family hall': 'Ladies and families can sit apart',
    'Parking': 'On-site parking for guests',
    'Generator': 'Backup power for lights and sound',
    'Stage': 'Fixed stage with a dance floor',
    'Sound system': 'Speakers and wireless mics',
    'Valet': 'Valet parking at the entrance',
    'Marquee': 'Covered marquee if it rains',
    'Lighting': 'Fairy lights and floodlights',
  };

  // The switches that are on
  RxList<String> selectedFeatures = <String>[].obs;

  List<String> typeFeatures() {
    return featuresByType[venue().type] ?? [];
  }

  String featureNote(String feature) {
    return featureNotes[feature] ?? '';
  }

  void toggleFeature(String feature, bool isOn) {
    if (isOn) {
      selectedFeatures.add(feature);
    } else {
      selectedFeatures.remove(feature);
    }
  }

  // Puts the venue's saved values into the fields
  void loadVenue() {
    final VenueModel v = venue();
    nameController.text = v.name;
    addressController.text = v.address;
    rentController.text = v.rent == 0 ? '' : '${v.rent}';
    minGuestsController.text = '${v.minGuests}';
    maxGuestsController.text = '${v.maxGuests}';
    aboutController.text = v.about;
    selectedArea.value = v.area;
    selectedFeatures.assignAll(v.features);
    aboutLength.value = v.about.length;
  }

  // Checks the fields, then saves them into the shared venue.
  // Returns false (and shows a message) if something is wrong.
  bool save() {
    final String name = nameController.text.trim();
    final int rent = int.tryParse(rentController.text.replaceAll(',', '')) ?? 0;
    final int minGuests = int.tryParse(minGuestsController.text) ?? 0;
    final int maxGuests = int.tryParse(maxGuestsController.text) ?? 0;

    if (name.isEmpty) {
      Get.snackbar('Venue name', 'Please enter the name of your venue');
      return false;
    }
    if (selectedArea.value.isEmpty) {
      Get.snackbar('Area', 'Please pick the area of your venue');
      return false;
    }
    if (rent <= 0) {
      Get.snackbar('Rent', 'Please enter the rent for one event');
      return false;
    }
    if (minGuests <= 0 || maxGuests < minGuests) {
      Get.snackbar('Guests', 'Max guests must be more than min guests');
      return false;
    }
    if (aboutController.text.length > aboutMaxLength) {
      Get.snackbar('About', 'Please keep it under $aboutMaxLength letters');
      return false;
    }

    final VenueModel v = venue();
    v.name = name;
    v.area = selectedArea.value;
    v.address = addressController.text.trim();
    v.rent = rent;
    v.minGuests = minGuests;
    v.maxGuests = maxGuests;
    v.about = aboutController.text.trim();
    v.features = List<String>.from(selectedFeatures);

    // Shown to customers once it has a rent, an area and a photo
    data.checkLive(v);
    return true;
  }

  // "Save" in the My venue tab
  void saveChanges() {
    if (save()) {
      Get.snackbar('Saved', 'Customers now see the new details');
    }
  }

  // "Save & continue" in the setup after sign up: step 2 is the photos
  void saveAndContinue() {
    if (save()) {
      Get.to(() => const MediaManagerScreen(isSetup: true));
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    rentController.dispose();
    minGuestsController.dispose();
    maxGuestsController.dispose();
    aboutController.dispose();
    super.onClose();
  }
}
