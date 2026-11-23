import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import '../controller/venue_details_controller.dart';

// Amber colour for the "Banquet only" badge.
// If your AppColors already has a warning colour, replace this with it.
const Color _amber = Color(0xFFE0A24A);

class VenueDetailsScreen extends StatelessWidget {
  const VenueDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final VenueDetailsController c = Get.put(VenueDetailsController());

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: sh * 0.02),
                    const _StepProgress(),
                    SizedBox(height: sh * 0.02),

                    // ---------- Basic info ----------
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Basic info', style: _cardTitle()),
                          SizedBox(height: sh * 0.015),

                          _Label('Venue name'),
                          _Field(
                            controller: c.nameController,
                            icon: Icons.store_mall_directory_outlined,
                            hint: 'Venue name',
                          ),
                          SizedBox(height: sh * 0.018),

                          _Label('Area'),
                          _Field(
                            controller: c.areaController,
                            icon: Icons.location_on_outlined,
                            hint: 'Area',
                          ),
                          SizedBox(height: sh * 0.018),

                          _Label('Full address'),
                          _Field(
                            controller: c.addressController,
                            icon: Icons.map_outlined,
                            hint: 'Street, block and landmark',
                          ),
                          SizedBox(height: sh * 0.018),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _Label('Max guests'),
                                    _Field(
                                      controller: c.maxGuestsController,
                                      icon: Icons.people_outline,
                                      hint: '0',
                                      isNumber: true,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _Label('Min guests'),
                                    _Field(
                                      controller: c.minGuestsController,
                                      icon: Icons.people_outline,
                                      hint: '0',
                                      isNumber: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: sh * 0.018),

                    // ---------- Venue type ----------
                    const _VenueTypeCard(),
                    SizedBox(height: sh * 0.018),

                    // ---------- Banquet details ----------
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Banquet details', style: _cardTitle()),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _amber.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Banquet only',
                                  style: AppTextStyles.bodySmall(color: _amber),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          _SwitchRow(
                            title: 'In-house catering',
                            subtitle: 'Menus come from your packages',
                            value: c.inHouseCatering,
                          ),
                          const _RowDivider(),
                          _SwitchRow(
                            title: 'Separate family hall',
                            subtitle: 'Ladies and families can sit apart',
                            value: c.separateFamilyHall,
                          ),
                          const _RowDivider(),
                          _SwitchRow(
                            title: 'On-site parking',
                            subtitle: 'Shown as a facility to customers',
                            value: c.onSiteParking,
                          ),
                          const _RowDivider(),
                          const _PackagesRow(),
                        ],
                      ),
                    ),
                    SizedBox(height: sh * 0.018),

                    // ---------- About ----------
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('About your venue', style: _cardTitle()),
                          SizedBox(height: sh * 0.012),
                          TextField(
                            controller: c.aboutController,
                            maxLines: 5,
                            maxLength: VenueDetailsController.aboutMaxLength,
                            style: AppTextStyles.bodyLarge(),
                            decoration: _decoration(
                              colors,
                              hint: 'Describe your venue',
                            ).copyWith(counterText: ''),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Text(
                              '${c.aboutLength.value} / '
                              '${VenueDetailsController.aboutMaxLength}',
                              style: AppTextStyles.bodySmall(
                                  color: colors.textMuted),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: sh * 0.03),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ---------- Bottom buttons ----------
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(sw * 0.05, 12, sw * 0.05, 12),
        decoration: BoxDecoration(
          color: colors.bgScreen,
          border: Border(top: BorderSide(color: colors.borderStrong)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: (sh * 0.065).clamp(48.0, 58.0),
                  child: OutlinedButton(
                    onPressed: c.saveDraft,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.borderStrong),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text('Save draft', style: AppTextStyles.labelButton()),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: (sh * 0.065).clamp(48.0, 58.0),
                  child: ElevatedButton(
                    onPressed: c.saveAndContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.textOnPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Save & continue',
                      style:
                          AppTextStyles.labelButton(color: colors.textOnPrimary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle _cardTitle() => AppTextStyles.titleSmall()
    .copyWith(fontSize: 17, fontWeight: FontWeight.w800);

/// One shared look for every text box on this screen.
InputDecoration _decoration(
  AppColors colors, {
  required String hint,
  IconData? icon,
}) {
  return InputDecoration(
    filled: true,
    fillColor: colors.bgSurface,
    prefixIcon:
        icon == null ? null : Icon(icon, size: 20, color: colors.textMuted),
    hintText: hint,
    hintStyle: AppTextStyles.bodyLarge(color: colors.textMuted),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.borderStrong),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.primaryBorder),
    ),
  );
}

// =====================================================================
// Top bar: back arrow + title + "Step 1 of 3"
// =====================================================================

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      color: colors.bgScreen,
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Venue details',
                    style: AppTextStyles.titleSmall().copyWith(fontSize: 18)),
                const SizedBox(height: 2),
                Text('Step 1 of 3 · Banquet form',
                    style:
                        AppTextStyles.bodySmall(color: colors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Step progress: Details / Photos / Packages
// =====================================================================

class _StepProgress extends StatelessWidget {
  const _StepProgress();

  @override
  Widget build(BuildContext context) {
    const steps = ['Details', 'Photos', 'Packages'];
    const current = 0; // 0 = first step

    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          Expanded(child: _StepItem(label: steps[i], active: i == current)),
          if (i != steps.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 3,
          decoration: BoxDecoration(
            color: active ? colors.primaryInk : colors.borderStrong,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.bodySmall(
            color: active ? colors.primaryInk : colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// Small reusable pieces
// =====================================================================

/// A rounded box with a border. Every section sits inside one.
class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgScreen,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderStrong),
      ),
      child: child,
    );
  }
}

/// The small title above a text box.
class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppTextStyles.titleSmall()),
    );
  }
}

/// A text box with an icon on the left.
class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.icon,
    required this.hint,
    this.isNumber = false,
  });

  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final bool isNumber;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return TextField(
      controller: controller,
      style: AppTextStyles.bodyLarge(),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters:
          isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
      decoration: _decoration(colors, hint: hint, icon: icon),
    );
  }
}

class _VenueTypeCard extends StatelessWidget {
  const _VenueTypeCard();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return _Card(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.restaurant, size: 20, color: colors.primaryInk),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Banquet', style: AppTextStyles.titleSmall()),
                const SizedBox(height: 2),
                Text(
                  'Set when you signed up. Contact support to change it.',
                  style: AppTextStyles.bodySmall(color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A row with a title, a small description and an on/off switch.
class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final String title;
  final String subtitle;
  final RxBool value; // watched with Obx, so the switch updates itself

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleSmall()),
                const SizedBox(height: 2),
                Text(subtitle,
                    style:
                        AppTextStyles.bodySmall(color: colors.textSecondary)),
              ],
            ),
          ),
          Obx(
            () => Switch(
              value: value.value,
              onChanged: (v) => value.value = v,
              activeColor: Colors.white,
              activeTrackColor: colors.primary,
              inactiveTrackColor: colors.borderStrong,
            ),
          ),
        ],
      ),
    );
  }
}

class _PackagesRow extends StatelessWidget {
  const _PackagesRow();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Per-head menu packages',
                    style: AppTextStyles.titleSmall()),
                const SizedBox(height: 2),
                Text('Silver Rs 2,200 · Gold Rs 2,800',
                    style:
                        AppTextStyles.bodySmall(color: colors.textSecondary)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Get.to(PackagesScreen());
            },
            child: Text('Edit →',
                style: AppTextStyles.titleSmall(color: colors.primaryInk)),
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: AppColors.of(context).borderStrong);
  }
}