import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/widgets/common/action_button.dart';
import 'package:hall_mate/widgets/common/guest_stepper.dart';

import 'package:hall_mate/controller/user/venue/filters_controller.dart';
import 'package:hall_mate/controller/shared/nav_controller.dart';
import 'package:hall_mate/utils/app_format.dart';

/// The "Filters" bottom sheet. It is opened from the filter button
/// on the Home screen and on the Search results screen.
///
/// Both screens call the same one line:  FiltersSheet.show(context);
///
/// Every tap changes FiltersController straight away, and the Search
/// screen reads the same controller (its chips and its list).
class FiltersSheet extends StatelessWidget {
  const FiltersSheet({super.key});

  // Opens the sheet with showModalBottomSheet (the same widget you used in
  // the to-do app). It is written here once, so Home and Search do not repeat it.
  static void show(BuildContext context) {
    final colors = AppColors.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return const FiltersSheet();
      },
    );
  }

  // A rounded chip. Selected = green fill, not selected = white with a border.
  // fillWidth true: the chip fills the space it is given (types and budget).
  // fillWidth false: the chip is only as wide as its text (for the amenities).
  Widget _chip(AppColors colors, String label, bool isSelected, bool fillWidth) {
    final Widget text = Text(
      label,
      style: AppTextStyles.titleSmall(
        color: isSelected ? colors.textOnPrimary : null,
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: fillWidth ? 4 : 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary : colors.bgSurface,
        border: Border.all(color: isSelected ? colors.primary : colors.borderStrong),
        borderRadius: BorderRadius.circular(20),
      ),
      child: fillWidth ? Center(child: text) : text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final FiltersController controller = Get.put(FiltersController());

    return SafeArea(
      child: Padding(
        // viewInsets.bottom is the keyboard height (used in your New Task sheet).
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Drag handle ──
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.borderStrong,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // ── Title and Reset ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: AppTextStyles.h2()),
                  TextButton(
                    // Every filter back to "nothing chosen"
                    onPressed: () {
                      controller.clearAll();
                    },
                    child: Text(
                      'Reset',
                      style: AppTextStyles.titleSmall(color: colors.primaryInk),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // ── Venue type ──
              Text('Venue type', style: AppTextStyles.titleSmall()),
              const SizedBox(height: 10),
              // Obx: the green chip moves when another type is tapped
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectType(0);
                        },
                        child: _chip(
                          colors,
                          controller.types[0],
                          controller.selectedTypeIndex.value == 0,
                          true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectType(1);
                        },
                        child: _chip(
                          colors,
                          controller.types[1],
                          controller.selectedTypeIndex.value == 1,
                          true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectType(2);
                        },
                        child: _chip(
                          colors,
                          controller.types[2],
                          controller.selectedTypeIndex.value == 2,
                          true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ── Date: only venues free on this day are shown ──
              Text('Event date', style: AppTextStyles.titleSmall()),
              const SizedBox(height: 10),
              GestureDetector(
                // Tap the box to pick a date (like in the to-do app)
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: controller.selectedDate.value ?? AppFormat.today(),
                    firstDate: AppFormat.today(),
                    lastDate: DateTime(AppFormat.today().year + 2),
                  );
                  if (picked != null) {
                    controller.setDate(picked);
                  }
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: colors.bgSurface,
                    border: Border.all(color: colors.border),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: colors.primaryInk,
                      ),
                      const SizedBox(width: 10),
                      // Obx: shows the picked date, or "Any date"
                      Obx(
                        () => Text(
                          controller.selectedDate.value == null
                              ? 'Any date'
                              : controller.dateText(),
                          style: AppTextStyles.bodyMedium(
                            color: controller.selectedDate.value == null
                                ? colors.textMuted
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // ── Guests ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Guests', style: AppTextStyles.titleSmall()),
                      const SizedBox(height: 2),
                      Text(
                        'Hall must fit this many',
                        style: AppTextStyles.caption(color: colors.textMuted),
                      ),
                    ],
                  ),
                  // Obx: the number changes on - and + (50 at a time)
                  Obx(
                    () => GuestStepper(
                      value: controller.guestsText(),
                      onMinus: () {
                        controller.removeGuests();
                      },
                      onPlus: () {
                        controller.addGuests();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ── Budget: the highest rent ──
              Text('Rent up to', style: AppTextStyles.titleSmall()),
              const SizedBox(height: 10),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectBudget(0);
                        },
                        child: _chip(
                          colors,
                          controller.budgetLabels[0],
                          controller.selectedBudgetIndex.value == 0,
                          true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectBudget(1);
                        },
                        child: _chip(
                          colors,
                          controller.budgetLabels[1],
                          controller.selectedBudgetIndex.value == 1,
                          true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectBudget(2);
                        },
                        child: _chip(
                          colors,
                          controller.budgetLabels[2],
                          controller.selectedBudgetIndex.value == 2,
                          true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectBudget(3);
                        },
                        child: _chip(
                          colors,
                          controller.budgetLabels[3],
                          controller.selectedBudgetIndex.value == 3,
                          true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ── Amenities (two rows of chips) ──
              Text('Amenities', style: AppTextStyles.titleSmall()),
              const SizedBox(height: 10),
              // Obx: a chip turns green when tapped, white when tapped again
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.toggleAmenity(controller.amenities[0]);
                          },
                          child: _chip(
                            colors,
                            controller.amenities[0],
                            controller.selectedAmenities.contains(
                              controller.amenities[0],
                            ),
                            false,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            controller.toggleAmenity(controller.amenities[1]);
                          },
                          child: _chip(
                            colors,
                            controller.amenities[1],
                            controller.selectedAmenities.contains(
                              controller.amenities[1],
                            ),
                            false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.toggleAmenity(controller.amenities[2]);
                          },
                          child: _chip(
                            colors,
                            controller.amenities[2],
                            controller.selectedAmenities.contains(
                              controller.amenities[2],
                            ),
                            false,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            controller.toggleAmenity(controller.amenities[3]);
                          },
                          child: _chip(
                            colors,
                            controller.amenities[3],
                            controller.selectedAmenities.contains(
                              controller.amenities[3],
                            ),
                            false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Buttons ──
              Row(
                children: [
                  SizedBox(
                    width: sw * 0.28,
                    child: ActionButton(
                      label: 'Clear',
                      height: 52,
                      bgColor: colors.bgSurface,
                      borderColor: colors.borderStrong,
                      textColor: colors.textPrimary,
                      // Every filter back to "nothing chosen"
                      onTap: () {
                        controller.clearAll();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ActionButton(
                      label: 'Show venues',
                      height: 52,
                      bgColor: colors.primary,
                      borderColor: colors.primary,
                      textColor: colors.textOnPrimary,
                      // Closes the sheet and opens the Search tab (tab 1),
                      // which shows the chosen filters and the matching venues.
                      onTap: () {
                        Navigator.pop(context);
                        Get.find<NavController>().changeIndex(1);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
