import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/home_controller.dart';
import 'package:hall_mate/widgets/venue_card.dart';
import 'package:hall_mate/widgets/venue_row_card.dart';
import 'package:hall_mate/widgets/venue_type_tile.dart';
import 'package:hall_mate/view/notifications_screen.dart';
import 'package:hall_mate/widgets/filters_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    // Creates the controller the first time and reuses it after that.
    final HomeController controller = Get.put(HomeController());

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
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: colors.primaryInk,
                        ),
                        const SizedBox(width: 6),
                        // API: the user's location
                        Text(
                          controller.location,
                          style: AppTextStyles.titleSmall(),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: colors.textMuted,
                        ),
                      ],
                    ),

                    // Stack puts widgets on top of each other. The first child
                    // (the bell button) is the base. Positioned places the orange
                    // dot, measured from the top and right edge of the Stack.
                    Stack(
                      children: [
                        GestureDetector(
                          // Opens the Notifications screen
                          onTap: () {
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
                        if (controller.hasNewNotification)
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
                child: Row(
                  children: [
                    Expanded(
                      child: VenueTypeTile(
                        label: 'Ballroom',
                        icon: Icons.light_outlined,
                        isSelected: controller.selectedTypeIndex == 0,
                      ),
                    ),
                    SizedBox(width: sw * 0.03),
                    Expanded(
                      child: VenueTypeTile(
                        label: 'Banquet',
                        icon: Icons.restaurant_outlined,
                        isSelected: controller.selectedTypeIndex == 1,
                      ),
                    ),
                    SizedBox(width: sw * 0.03),
                    Expanded(
                      child: VenueTypeTile(
                        label: 'Outdoor',
                        icon: Icons.festival_outlined,
                        isSelected: controller.selectedTypeIndex == 2,
                      ),
                    ),
                  ],
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
                      // Later: open the full venues list
                      onPressed: () {},
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
              SizedBox(
                height: 268,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // API: the number of featured venues from the API
                  itemCount: controller.featuredVenues.length,
                  itemBuilder: (context, index) {
                    // API: this is one venue from the API list
                    final venue = controller.featuredVenues[index];

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
                          child: VenueCard(
                            name: venue['name'],
                            rating: venue['rating'],
                            subtitle: venue['subtitle'],
                            price: venue['price'],
                            tag: venue['tag'],
                            isFavorite: venue['isFavorite'],
                            photoStyle: venue['photo'],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
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
              Column(
                // API: one card for every venue in the nearby list
                children: controller.nearbyVenues.map((venue) {
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
              ),
              SizedBox(height: sh * 0.01),
            ],
          ),
        ),
      ),
    );
  }
}
