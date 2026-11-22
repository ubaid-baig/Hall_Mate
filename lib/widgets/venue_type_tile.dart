import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// One tile of "Browse by type" (Ballroom, Banquet, Outdoor).
/// The selected tile is filled with the primary colour.
///
/// Later: wrap it in a GestureDetector and change the selected index
/// in HomeController (then filter the venues from the API by type).
class VenueTypeTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const VenueTypeTile({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary : colors.bgSurface,
        border: Border.all(color: isSelected ? colors.primary : colors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? colors.accent : colors.primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isSelected ? colors.textOnAccent : colors.primaryInk,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: AppTextStyles.titleSmall(
              color: isSelected ? colors.textOnPrimary : null,
            ),
          ),
        ],
      ),
    );
  }
}
