import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// Shared pieces for the "Venue setup" screens (Ballroom, Outdoor, ...).
/// They are public (no underscore) so several screens can import them.

// Amber colour for the "Ballroom only" / "Outdoor only" badge.
// If your AppColors already has a warning colour, replace this with it.
const Color venueAmber = Color(0xFFE0A24A);

TextStyle venueCardTitle() => AppTextStyles.titleSmall()
    .copyWith(fontSize: 17, fontWeight: FontWeight.w800);

/// One shared look for every text box.
InputDecoration venueInputDecoration(
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
// Top bar: back arrow + title + "Step 1 of 3 · ... form"
// =====================================================================

class VenueTopBar extends StatelessWidget {
  const VenueTopBar({super.key, required this.subtitle});

  final String subtitle;

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
                Text(subtitle,
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

class VenueStepProgress extends StatelessWidget {
  const VenueStepProgress({super.key, this.current = 0});

  /// 0 = Details, 1 = Photos, 2 = Packages
  final int current;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    const steps = ['Details', 'Photos', 'Packages'];

    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: i == current ? colors.primaryInk : colors.borderStrong,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  steps[i],
                  style: AppTextStyles.bodySmall(
                    color:
                        i == current ? colors.primaryInk : colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (i != steps.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

// =====================================================================
// Green info banner
// =====================================================================

class VenueInfoBanner extends StatelessWidget {
  const VenueInfoBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.primary.withOpacity(0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: colors.primaryInk),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall(color: colors.primaryInk)
                  .copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Card, card header, label, text box
// =====================================================================

/// A rounded box with a border. Every section sits inside one.
class VenueCard extends StatelessWidget {
  const VenueCard({super.key, required this.child});

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

/// Card title on the left and a small yellow badge on the right.
class VenueCardHeader extends StatelessWidget {
  const VenueCardHeader({super.key, required this.title, required this.badge});

  final String title;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: venueCardTitle()),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: venueAmber.withOpacity(0.18),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(badge, style: AppTextStyles.bodySmall(color: venueAmber)),
        ),
      ],
    );
  }
}

/// The small title above a text box or a group of chips.
class VenueLabel extends StatelessWidget {
  const VenueLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppTextStyles.titleSmall()),
    );
  }
}

/// A text box with an optional icon on the left.
class VenueField extends StatelessWidget {
  const VenueField({
    super.key,
    required this.controller,
    required this.hint,
    this.icon,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTextStyles.bodyLarge(),
      decoration: venueInputDecoration(colors, hint: hint, icon: icon),
    );
  }
}

// =====================================================================
// Choice chips (pick ONE option)
// =====================================================================

class VenueChipGroup extends StatelessWidget {
  const VenueChipGroup({
    super.key,
    required this.options,
    required this.selected,
  });

  final List<String> options;
  final RxInt selected; // index of the chosen option

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (int i = 0; i < options.length; i++)
            GestureDetector(
              onTap: () => selected.value = i,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: selected.value == i
                      ? colors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected.value == i
                        ? colors.primary
                        : colors.borderStrong,
                  ),
                ),
                child: Text(
                  options[i],
                  style: AppTextStyles.bodyMedium(
                    color: selected.value == i
                        ? colors.textOnPrimary
                        : colors.textPrimary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// =====================================================================
// Switch row and divider
// =====================================================================

class VenueSwitchRow extends StatelessWidget {
  const VenueSwitchRow({
    super.key,
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

class VenueRowDivider extends StatelessWidget {
  const VenueRowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: AppColors.of(context).borderStrong);
  }
}

// =====================================================================
// Bottom bar with one big button
// =====================================================================

class VenueBottomBar extends StatelessWidget {
  const VenueBottomBar({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.fromLTRB(sw * 0.05, 12, sw * 0.05, 12),
      decoration: BoxDecoration(
        color: colors.bgScreen,
        border: Border(top: BorderSide(color: colors.borderStrong)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: (sh * 0.065).clamp(48.0, 58.0),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.textOnPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              text,
              style: AppTextStyles.labelButton(color: colors.textOnPrimary),
            ),
          ),
        ),
      ),
    );
  }
}