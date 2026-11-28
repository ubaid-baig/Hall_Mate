import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/manager/venue_form_controller.dart';
import 'package:hall_mate/view/manager/venue/media_manager_screen.dart';
import 'package:hall_mate/widgets/common/action_button.dart';
import 'package:hall_mate/widgets/common/profile_row.dart';
import 'package:hall_mate/widgets/manager/form_widgets.dart';

// Venue details form. One form for Banquet, Ballroom and Outdoor.
//  - isSetup true:  step 1 of 2 right after a manager signs up
//  - isSetup false: the "My venue" tab, to edit the details later
class VenueFormScreen extends StatelessWidget {
  final bool isSetup;

  const VenueFormScreen({super.key, required this.isSetup});

  // The "Choose your area" bottom sheet (the same one as on Home)
  void _showAreaSheet(
    BuildContext context,
    AppColors colors,
    VenueFormController controller,
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
                  children: controller.areas().map((area) {
                    final bool isSelected = controller.selectedArea.value == area;
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
                          color: isSelected ? colors.primaryTint : colors.bgSurface,
                          border: Border.all(
                            color: isSelected ? colors.primaryBorder : colors.border,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(area, style: AppTextStyles.titleSmall()),
                            ),
                            if (isSelected)
                              Icon(Icons.check, size: 20, color: colors.primaryInk),
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
    final VenueFormController controller = Get.put(VenueFormController());
    final String type = controller.venue().type;

    return Scaffold(
      backgroundColor: colors.bgScreen,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: sw * 0.05,
                  right: sw * 0.05,
                  top: sh * 0.02,
                  bottom: sh * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Title ──
                    Text(
                      isSetup ? 'Set up your venue' : 'My venue',
                      style: AppTextStyles.h1(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isSetup
                          ? 'Step 1 of 2 · Venue details'
                          : 'Edit what customers see about your venue',
                      style: AppTextStyles.bodyMedium(color: colors.textSecondary),
                    ),

                    // ── Step bars (setup only): Details / Photos ──
                    if (isSetup) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                color: colors.border,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: sh * 0.022),

                    // ════════ Basic info ════════
                    FormSection(
                      title: 'Basic info',
                      badge: type,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabeledField(
                            label: 'Venue name',
                            controller: controller.nameController,
                            hint: 'e.g. Shaan Banquet Hall',
                          ),

                          // Area: tap to pick from the list
                          Text('Area', style: AppTextStyles.titleSmall()),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              _showAreaSheet(context, colors, controller);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: colors.bgScreen,
                                border: Border.all(color: colors.borderStrong),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 20,
                                    color: colors.primaryInk,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    // Obx: shows the picked area
                                    child: Obx(
                                      () => Text(
                                        controller.selectedArea.value.isEmpty
                                            ? 'Pick your area'
                                            : controller.selectedArea.value,
                                        style: AppTextStyles.bodyLarge(
                                          color: controller.selectedArea.value.isEmpty
                                              ? colors.textMuted
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 22,
                                    color: colors.textMuted,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          LabeledField(
                            label: 'Full address',
                            controller: controller.addressController,
                            hint: 'Street, block and landmark',
                          ),
                          LabeledField(
                            label: 'Rent per event (Rs)',
                            controller: controller.rentController,
                            hint: 'e.g. 300000',
                            isNumber: true,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: LabeledField(
                                  label: 'Min guests',
                                  controller: controller.minGuestsController,
                                  hint: '150',
                                  isNumber: true,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: LabeledField(
                                  label: 'Max guests',
                                  controller: controller.maxGuestsController,
                                  hint: '500',
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Food is not part of the rent. Customers bring '
                            'their own caterer.',
                            style: AppTextStyles.bodySmall(color: colors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: sh * 0.018),

                    // ════════ Type details: 3 switches ════════
                    FormSection(
                      title: '$type details',
                      badge: '$type only',
                      // Obx: a switch moves as soon as it is tapped
                      child: Obx(
                        () => Column(
                          children: controller.typeFeatures().map((feature) {
                            return SwitchRow(
                              title: feature,
                              subtitle: controller.featureNote(feature),
                              value: controller.selectedFeatures.contains(feature),
                              onChanged: (isOn) {
                                controller.toggleFeature(feature, isOn);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: sh * 0.018),

                    // ════════ About ════════
                    FormSection(
                      title: 'About your venue',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          LabeledField(
                            label: 'Description',
                            controller: controller.aboutController,
                            hint: 'What makes your venue special?',
                            maxLines: 4,
                            onChanged: (text) {
                              controller.updateAboutLength(text);
                            },
                          ),
                          // Obx: the number changes while you type
                          Obx(
                            () => Text(
                              '${controller.aboutLength.value} / '
                              '${VenueFormController.aboutMaxLength}',
                              style: AppTextStyles.caption(color: colors.textMuted),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ════════ Photos & videos (My venue tab only) ════════
                    if (!isSetup) ...[
                      SizedBox(height: sh * 0.018),
                      Container(
                        decoration: BoxDecoration(
                          color: colors.bgSurface,
                          border: Border.all(color: colors.border),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        // Obx: the count changes after an upload
                        child: Obx(
                          () => ProfileRow(
                            icon: Icons.image_outlined,
                            title: 'Photos & videos',
                            subtitle: controller.venue().mediaCountText(),
                            showDivider: false,
                            onTap: () {
                              Get.to(() => const MediaManagerScreen(isSetup: false));
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── Save button (stays in place) ──
            Container(
              color: colors.bgSurface,
              child: Column(
                children: [
                  Divider(color: colors.border, height: 1),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.05,
                      vertical: 12,
                    ),
                    child: ActionButton(
                      label: isSetup ? 'Save & continue' : 'Save changes',
                      height: 52,
                      bgColor: colors.primary,
                      borderColor: colors.primary,
                      textColor: colors.textOnPrimary,
                      onTap: () {
                        if (isSetup) {
                          controller.saveAndContinue();
                        } else {
                          controller.saveChanges();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
