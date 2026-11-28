import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/user/venue/venue_search_controller.dart';
import 'package:hall_mate/widgets/user/venue/venue_card.dart';
import 'package:hall_mate/widgets/user/venue/filters_sheet.dart';
import 'package:hall_mate/controller/user/venue/favourite_controller.dart';
import 'package:hall_mate/model/venue_model.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final VenueSearchController controller = Get.put(VenueSearchController());
    // The saved venues (hearts). Created once in main.dart.
    final FavouriteController favController = Get.find<FavouriteController>();

    return Scaffold(
      backgroundColor: colors.bgScreen,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar: back arrow and title ──
            Padding(
              padding: EdgeInsets.only(
                left: sw * 0.05,
                right: sw * 0.05,
                top: sh * 0.015,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    // Search is a tab, so back goes to the Home tab
                    onTap: () {
                      controller.goToHomeTab();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // API: the venue type that was searched
                        // Obx: "Banquet venues" when a type is chosen in Filters
                        Obx(
                          () => Text(
                            controller.title(),
                            style: AppTextStyles.h3(),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Obx: the number changes while you type
                        Obx(
                          () => Text(
                            controller.resultText(),
                            style: AppTextStyles.caption(
                              color: colors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sh * 0.018),

            // ── Search field + filter button with the orange count badge ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      // Every letter typed is sent to the controller,
                      // and the list below updates straight away.
                      onChanged: (text) {
                        controller.updateSearch(text);
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
                        hintText: 'Search by name or area',
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

                  // Stack: the filter button is the base, Positioned puts the
                  // orange number badge on its top right corner.
                  // Obx: the number follows the chosen filters.
                  Obx(
                    () => Stack(
                    children: [
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
                      // No badge when there are no filters
                      if (controller.activeChips().isNotEmpty)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: colors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              // How many filters are chosen
                              '${controller.activeChips().length}',
                              style: AppTextStyles.labelTiny(
                                color: colors.textOnAccent,
                              ),
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
            SizedBox(height: sh * 0.015),

            // ── Active filter chips (scroll sideways) ──
            // One chip for every choice in the Filters sheet.
            // No choice = no chips (an empty SizedBox).
            // Obx: the chips change when filters are chosen or removed.
            // The list is made here first, because ListView builds the
            // chips a moment later, outside the Obx.
            Obx(() {
              final List<Map<String, String>> chips = controller.activeChips();

              if (chips.isEmpty) {
                return const SizedBox();
              }

              return SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: chips.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? sw * 0.05 : 0,
                      right: 8,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: colors.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            chips[index]['label']!,
                            style: AppTextStyles.titleSmall(
                              color: colors.primaryInk,
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Tap the x to remove this filter
                          GestureDetector(
                            onTap: () {
                              controller.removeChip(chips[index]);
                            },
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: colors.primaryInk,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
            }),
            SizedBox(height: sh * 0.008),

            // ── "Free on ..." text ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    // Obx: shows the date chosen in Filters, or "Any date"
                    child: Obx(
                      () => Text(
                        controller.freeOnText(),
                        style: AppTextStyles.bodySmall(color: colors.textMuted),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sh * 0.015),

            // ── Venue list (this part scrolls up and down) ──
            Expanded(
              // Obx: the list changes while you type, and when a heart is tapped
              child: Obx(() {
                final List<VenueModel> venues = controller.results();

                if (venues.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                    child: Text(
                      controller.emptyText(),
                      style: AppTextStyles.bodyMedium(color: colors.textMuted),
                    ),
                  );
                }

                return SingleChildScrollView(
                child: Column(
                  children: venues.map((venue) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: sw * 0.05,
                        right: sw * 0.05,
                        bottom: sh * 0.018,
                      ),
                      child: VenueCard(
                        venue: venue,
                        // Red heart if this venue is saved
                        isFavorite: favController.isSaved(venue.id),
                        // Tap the heart: save or unsave this venue
                        onFavoriteTap: () {
                          favController.toggleFavourite(venue.id);
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
    );
  }
}
