import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

import '../../../controller/user/home/home_controller.dart';
import '../../../widgets/user/venue/filters_sheet.dart';
import '../../../widgets/user/venue/venue_card.dart';
import '../../../widgets/user/venue/venue_row_card.dart';
import '../../../widgets/user/venue/venue_type_tile.dart';
import 'notifications_screen.dart';
import 'package:hall_mate/controller/user/venue/favourite_controller.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // The "Choose your area" bottom sheet. Opens when the location is tapped.
  void _showAreaSheet(
      BuildContext context,
      AppColors colors,
      HomeController controller,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose your area', style: AppTextStyles.h3()),
                const SizedBox(height: 12),
                Column(
                  // One row for every area in the controller's list
                  children: controller.areas.map((area) {
                    final bool isSelected =
                        controller.selectedArea.value == area;

                    return GestureDetector(
                      onTap: () {
                        controller.selectArea(area);
                        Navigator.pop(context); // close the sheet
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primaryTint
                              : colors.bgSurface,
                          border: Border.all(
                            color: isSelected
                                ? colors.primaryBorder
                                : colors.border,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                area,
                                style: AppTextStyles.titleSmall(),
                              ),
                            ),
                            // A check mark only on the selected area
                            if (isSelected)
                              Icon(
                                Icons.check,
                                size: 20,
                                color: colors.primaryInk,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    // Creates the controller the first time and reuses it after that.
    final HomeController controller = Get.put(HomeController());
    // The saved venues (hearts). Created once in main.dart.
    final FavouriteController favController = Get.find<FavouriteController>();

    return Scaffold(
      backgroundColor: colors.bgScreen,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: location (left) and bell (right) ──
              Padding(
                padding: EdgeInsets.only(
                  left: sw * 0.05,
                  right: sw * 0.05,
                  top: sh * 0.015,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tap the location to choose another area
                    GestureDetector(
                      onTap: () {
                        _showAreaSheet(context, colors, controller);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: colors.primaryInk,
                          ),
                          const SizedBox(width: 6),
                          // Obx: the text changes when another area is picked
                          Obx(
                                () => Text(
                              '${controller.selectedArea.value}, Karachi',
                              style: AppTextStyles.titleSmall(),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: colors.textMuted,
                          ),
                        ],
                      ),
                    ),

                    // Obx: the dot disappears when hasNewNotification becomes false
                    Obx(
                          () => Stack(
                        children: [
                          GestureDetector(
                            // Hides the dot, then opens the Notifications screen
                            onTap: () {
                              controller.markNotificationsSeen();
                              Get.to(() => const NotificationsScreen());
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: colors.bgSurface,
                                border: Border.all(color: colors.border),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.notifications_none_rounded,
                                size: 22,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          // API: show the dot only if there are unread notifications
                          if (controller.hasNewNotification.value)
                            Positioned(
                              top: 10,
                              right: 11,
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: colors.accent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: colors.bgSurface,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: sh * 0.012),

              // ── Greeting ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                child: Text(
                  // API: userName comes from the logged-in user
                  'Hi ${controller.userName}, let\'s find\nyour venue',
                  style: AppTextStyles.h1(),
                ),
              ),
              SizedBox(height: sh * 0.02),

              // ── Search field + filter button ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        onTap: () {
                          controller.openSearchTab();
                        },
                        textInputAction: TextInputAction.search,
                        style: AppTextStyles.bodyLarge(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colors.bgSurface,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 22,
                            color: colors.textMuted,
                          ),
                          hintText: 'Search halls or areas',
                          hintStyle: AppTextStyles.bodyLarge(
                            color: colors.textMuted,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: colors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: colors.primaryBorder),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      // Opens the Filters bottom sheet
                      onTap: () {
                        FiltersSheet.show(context);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          size: 22,
                          color: colors.textOnPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: sh * 0.028),

              // ── Browse by type ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                child: Text('Browse by type', style: AppTextStyles.h3()),
              ),
              SizedBox(height: sh * 0.014),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                // Obx rebuilds the three tiles when selectedTypeIndex changes,
                // so the tapped tile turns green.
                child: Obx(
                      () => Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.selectType(0);
                          },
                          child: VenueTypeTile(
                            label: controller.venueTypes[0],
                            icon: Icons.light_outlined,
                            isSelected: controller.selectedTypeIndex.value == 0,
                          ),
                        ),
                      ),
                      SizedBox(width: sw * 0.03),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.selectType(1);
                          },
                          child: VenueTypeTile(
                            label: controller.venueTypes[1],
                            icon: Icons.restaurant_outlined,
                            isSelected: controller.selectedTypeIndex.value == 1,
                          ),
                        ),
                      ),
                      SizedBox(width: sw * 0.03),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.selectType(2);
                          },
                          child: VenueTypeTile(
                            label: controller.venueTypes[2],
                            icon: Icons.festival_outlined,
                            isSelected: controller.selectedTypeIndex.value == 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: sh * 0.028),

              // ── Featured venues (scrolls sideways) ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Featured venues', style: AppTextStyles.h3()),
                    TextButton(
                      // Opens the Search tab with all venues
                      onPressed: () {
                        controller.openSearchTab();
                      },
                      child: Text(
                        'See all',
                        style: AppTextStyles.titleSmall(
                          color: colors.primaryInk,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Obx rebuilds the list when a type tile is tapped.
              // The { } body lets us work out the list first, then return a widget.
              Obx(() {
                // Only the venues of the selected type (or all of them)
                final List<Map<String, dynamic>> featured =
                controller.filterByType(controller.featuredVenues);

                // Nothing of this type: show a short message instead of a gap
                if (featured.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.05,
                      vertical: sh * 0.02,
                    ),
                    child: Text(
                      controller.emptyText(),
                      style: AppTextStyles.bodyMedium(color: colors.textMuted),
                    ),
                  );
                }

                return SizedBox(
                  height: 268,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // API: the number of featured venues from the API
                    itemCount: featured.length,
                    itemBuilder: (context, index) {
                      // API: this is one venue from the API list
                      final venue = featured[index];

                      return Padding(
                        // The first card starts after the screen padding.
                        padding: EdgeInsets.only(
                          left: index == 0 ? sw * 0.05 : 0,
                          right: sw * 0.035,
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: sw * 0.7,
                            // ListView builds the cards a moment later, outside the
                            // Featured Obx, so each card gets its own Obx to watch
                            // the saved list. Then a heart tap redraws the card.
                            child: Obx(
                                  () => VenueCard(
                                name: venue['name'],
                                rating: venue['rating'],
                                subtitle: venue['subtitle'],
                                price: venue['price'],
                                tag: venue['tag'],
                                // Red heart if this venue is in the saved list
                                isFavorite: favController.isSaved(venue['name']),
                                // Tap the heart: save or unsave this venue
                                onFavoriteTap: () {
                                  favController.toggleFavourite(venue);
                                },
                                photoStyle: venue['photo'],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              SizedBox(height: sh * 0.012),

              // ── Near you ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Near you', style: AppTextStyles.h3()),
                    TextButton(
                      // Later: open the map view
                      onPressed: () {},
                      child: Text(
                        'Map view',
                        style: AppTextStyles.titleSmall(
                          color: colors.primaryInk,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                // Only the nearby venues of the selected type (or all of them)
                final List<Map<String, dynamic>> nearby =
                controller.filterByType(controller.nearbyVenues);

                if (nearby.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.05,
                      vertical: sh * 0.02,
                    ),
                    child: Text(
                      controller.emptyText(),
                      style: AppTextStyles.bodyMedium(color: colors.textMuted),
                    ),
                  );
                }

                return Column(
                  // API: one card for every venue in the nearby list
                  children: nearby.map((venue) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: sw * 0.05,
                        right: sw * 0.05,
                        bottom: sh * 0.015,
                      ),
                      child: VenueRowCard(
                        name: venue['name'],
                        rating: venue['rating'],
                        subtitle: venue['subtitle'],
                        price: venue['price'],
                        photoStyle: venue['photo'],
                      ),
                    );
                  }).toList(),
                );
              }),
              SizedBox(height: sh * 0.01),
            ],
          ),
        ),
      ),
    );
  }
}