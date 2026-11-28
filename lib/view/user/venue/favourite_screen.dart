import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/widgets/user/venue/venue_card.dart';
import 'package:hall_mate/controller/user/venue/favourite_controller.dart';
import 'package:hall_mate/model/venue_model.dart';

// Saved venues. Opens from Profile > Account > Saved venues.
class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    // Created once in main.dart, so we only find it here.
    final FavouriteController controller = Get.find<FavouriteController>();

    return Scaffold(
      // White, so the status bar area matches the white top bar.
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            // ════════ TOP BAR ════════
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sw * 0.05,
                vertical: 12,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saved venues', style: AppTextStyles.h3()),
                      const SizedBox(height: 2),
                      // Obx: the count changes when a heart is tapped
                      Obx(
                        () => Text(
                          controller.countText(),
                          style: AppTextStyles.caption(color: colors.textMuted),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: colors.border, height: 1),

            // ════════ GREY PART: chips and the list ════════
            Expanded(
              child: Container(
                width: double.infinity,
                color: colors.bgScreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: sh * 0.015),

                    // ── Venue type chips (scroll sideways) ──
                    // Obx: the green chip moves when another chip is tapped.
                    // The value is read here first, because ListView builds
                    // the chips a moment later, outside the Obx.
                    Obx(() {
                    final int selected = controller.selectedFilterIndex.value;

                    return SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.filters.length,
                        itemBuilder: (context, index) {
                          final bool isSelected = selected == index;

                          return Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? sw * 0.05 : 0,
                              right: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                controller.selectFilter(index);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? colors.primary
                                      : colors.bgSurface,
                                  border: Border.all(
                                    color: isSelected
                                        ? colors.primary
                                        : colors.border,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    controller.filters[index],
                                    style: AppTextStyles.titleSmall(
                                      color: isSelected
                                          ? colors.textOnPrimary
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                    }),
                    SizedBox(height: sh * 0.015),

                    // ── Saved venues (this part scrolls up and down) ──
                    Expanded(
                      // Obx: the list changes when a chip or a heart is tapped
                      child: Obx(() {
                        final List<VenueModel> venues =
                            controller.filteredVenues();

                        if (venues.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: sw * 0.05,
                            ),
                            child: Text(
                              controller.emptyText(),
                              style: AppTextStyles.bodyMedium(
                                color: colors.textMuted,
                              ),
                            ),
                          );
                        }

                        return SingleChildScrollView(
                        child: Column(
                          // API: one card for every saved venue
                          children: venues.map((venue) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: sw * 0.05,
                                right: sw * 0.05,
                                bottom: sh * 0.018,
                              ),
                              child: VenueCard(
                                venue: venue,
                                isFavorite: true,
                                // Tap the heart: remove it from the saved list
                                onFavoriteTap: () {
                                  controller.toggleFavourite(venue.id);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
