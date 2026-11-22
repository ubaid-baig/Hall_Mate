import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/filters_controller.dart';
import 'package:hall_mate/widgets/action_button.dart';
import 'package:hall_mate/widgets/guest_stepper.dart';

/// The "Filters" bottom sheet. It is opened from the filter button
/// on the Home screen and on the Search results screen.
///
/// Both screens call the same one line:  FiltersSheet.show(context);
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
  // fillWidth true: the chip fills the space it is given (for the venue types).
  // fillWidth false: the chip is only as wide as its text (for the amenities).
  Widget _chip(AppColors colors, String label, bool isSelected, bool fillWidth) {
    final Widget text = Text(
      label,
      style: AppTextStyles.titleSmall(
        color: isSelected ? colors.textOnPrimary : null,
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary : colors.bgSurface,
        border: Border.all(color: isSelected ? colors.primary : colors.borderStrong),
        borderRadius: BorderRadius.circular(20),
      ),
      child: fillWidth ? Center(child: text) : text,
    );
  }

  // One half of the Dinner | Lunch switch.
  Widget _segment(AppColors colors, String label, bool isSelected) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: isSelected ? colors.bgSurface : Colors.transparent,
        border: Border.all(color: isSelected ? colors.border : Colors.transparent),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.titleSmall(
            color: isSelected ? null : colors.textMuted,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final FiltersController controller = Get.put(FiltersController());

    // ── Budget slider measurements ──
    // The slider is drawn with plain boxes (it cannot be dragged yet).
    // The sheet has 20 padding on each side, so the line is (sw - 40) wide.
    // The two round thumbs are 24 wide. Their places are guessed from Figma.
    final double trackWidth = sw - 40;
    final double leftSpace = trackWidth * 0.14 - 12;
    final double activeWidth = trackWidth * 0.42 - 24;
    final double rightSpace = trackWidth - leftSpace - 24 - activeWidth - 24;

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
                    // Later: put every filter back to its start value
                    onPressed: () {},
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
              Row(
                children: [
                  Expanded(
                    child: _chip(
                      colors,
                      'Ballroom',
                      controller.selectedTypeIndex == 0,
                      true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _chip(
                      colors,
                      'Banquet',
                      controller.selectedTypeIndex == 1,
                      true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _chip(
                      colors,
                      'Outdoor',
                      controller.selectedTypeIndex == 2,
                      true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ── Date and Slot ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date', style: AppTextStyles.titleSmall()),
                        const SizedBox(height: 10),
                        Container(
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
                              Text(
                                controller.dateText,
                                style: AppTextStyles.bodyMedium(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Slot', style: AppTextStyles.titleSmall()),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colors.bgSubtle,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _segment(
                                  colors,
                                  'Dinner',
                                  controller.selectedSlotIndex == 0,
                                ),
                              ),
                              Expanded(
                                child: _segment(
                                  colors,
                                  'Lunch',
                                  controller.selectedSlotIndex == 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                  GuestStepper(value: controller.guestsText),
                ],
              ),
              const SizedBox(height: 18),

              // ── Budget ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Budget', style: AppTextStyles.titleSmall()),
                  Text(
                    controller.budgetText,
                    style: AppTextStyles.titleSmall(color: colors.primaryInk),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // The slider: grey line, thumb, green line, thumb, grey line.
              Row(
                children: [
                  Container(
                    width: leftSpace,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.borderStrong,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: colors.bgSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.primary, width: 3),
                    ),
                  ),
                  Container(
                    width: activeWidth,
                    height: 4,
                    color: colors.primary,
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: colors.bgSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.primary, width: 3),
                    ),
                  ),
                  Container(
                    width: rightSpace,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.borderStrong,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.budgetMinText,
                    style: AppTextStyles.caption(color: colors.textMuted),
                  ),
                  Text(
                    controller.budgetMaxText,
                    style: AppTextStyles.caption(color: colors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ── Amenities (two rows of chips) ──
              Text('Amenities', style: AppTextStyles.titleSmall()),
              const SizedBox(height: 10),
              Row(
                children: [
                  _chip(
                    colors,
                    controller.amenities[0]['label'],
                    controller.amenities[0]['isSelected'],
                    false,
                  ),
                  const SizedBox(width: 8),
                  _chip(
                    colors,
                    controller.amenities[1]['label'],
                    controller.amenities[1]['isSelected'],
                    false,
                  ),
                  const SizedBox(width: 8),
                  _chip(
                    colors,
                    controller.amenities[2]['label'],
                    controller.amenities[2]['isSelected'],
                    false,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _chip(
                    colors,
                    controller.amenities[3]['label'],
                    controller.amenities[3]['isSelected'],
                    false,
                  ),
                  const SizedBox(width: 8),
                  _chip(
                    colors,
                    controller.amenities[4]['label'],
                    controller.amenities[4]['isSelected'],
                    false,
                  ),
                ],
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
                      // Later: put every filter back to its start value
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ActionButton(
                      // API: the number of venues that match
                      label: controller.showButtonText,
                      height: 52,
                      bgColor: colors.primary,
                      borderColor: colors.primary,
                      textColor: colors.textOnPrimary,
                      // Closes the sheet.
                      // Later: also send the filters to the API and show the results.
                      onTap: () {
                        Navigator.pop(context);
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
