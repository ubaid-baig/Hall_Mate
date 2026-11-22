import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/venue_search_controller.dart';
import 'package:hall_mate/widgets/venue_card.dart';
import 'package:hall_mate/widgets/filters_sheet.dart';

// This is the "Search results" design. For now it is also shown in the
// Search tab. Later it will open from the Home search bar.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final VenueSearchController controller = Get.put(VenueSearchController());

    return Scaffold(
      backgroundColor: colors.bgScreen,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar: back arrow, title, map button ──
            Padding(
              padding: EdgeInsets.only(
                left: sw * 0.05,
                right: sw * 0.05,
                top: sh * 0.015,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    // Later: Get.back() once this screen opens from Home.
                    // (Inside the tab there is nothing to go back to.)
                    onTap: () {},
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
                        Text(controller.title, style: AppTextStyles.h3()),
                        const SizedBox(height: 2),
                        // API: number of results
                        Text(
                          controller.resultText,
                          style: AppTextStyles.caption(color: colors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    // Later: show the venues on a map
                    onTap: () {},
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colors.bgSurface,
                        border: Border.all(color: colors.border),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.map_outlined,
                        size: 22,
                        color: colors.textPrimary,
                      ),
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
                  Stack(
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
                              // API: number of active filters
                              '${controller.filterCount}',
                              style: AppTextStyles.labelTiny(
                                color: colors.textOnAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: sh * 0.015),

            // ── Active filter chips (scroll sideways) ──
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                // API: the filters the user chose
                itemCount: controller.filterChips.length,
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
                            controller.filterChips[index],
                            style: AppTextStyles.titleSmall(
                              color: colors.primaryInk,
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Later: tap the x to remove this filter
                          Icon(Icons.close, size: 16, color: colors.primaryInk),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: sh * 0.008),

            // ── "Free on ..." text and sort button ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      controller.freeOnText,
                      style: AppTextStyles.bodySmall(color: colors.textMuted),
                    ),
                  ),
                  TextButton(
                    // Later: open a sort menu
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.sortText,
                          style: AppTextStyles.titleSmall(),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: colors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Venue list (this part scrolls up and down) ──
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  // API: one card for every venue in the search results
                  children: controller.venues.map((venue) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: sw * 0.05,
                        right: sw * 0.05,
                        bottom: sh * 0.018,
                      ),
                      child: VenueCard(
                        name: venue['name'],
                        rating: venue['rating'],
                        subtitle: venue['subtitle'],
                        price: venue['price'],
                        tag: venue['tag'],
                        isFavorite: venue['isFavorite'],
                        photoStyle: venue['photo'],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
