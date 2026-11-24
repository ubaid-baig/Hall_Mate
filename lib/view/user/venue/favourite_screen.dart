import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/widgets/user/venue/venue_card.dart';
import '../../../controller/user/venue/favourite_controller.dart';

// Saved venues. Opens from Profile > Account > Saved venues.
class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final FavouriteController controller = Get.put(FavouriteController());

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
                      // API: how many venues are saved
                      Text(
                        controller.countText,
                        style: AppTextStyles.caption(color: colors.textMuted),
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
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.filters.length,
                        itemBuilder: (context, index) {
                          final bool isSelected =
                              controller.selectedFilterIndex == index;

                          return Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? sw * 0.05 : 0,
                              right: 8,
                            ),
                            child: GestureDetector(
                              // Later: set the selected chip in the controller
                              // and show only the venues of that type.
                              onTap: () {},
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
                    ),
                    SizedBox(height: sh * 0.015),

                    // ── Saved venues (this part scrolls up and down) ──
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          // API: one card for every saved venue
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
            ),
          ],
        ),
      ),
    );
  }
}
