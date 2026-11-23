import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// One time slot (Lunch or Dinner) on the Booking request screen.
///  - not available: grey box, "Already booked"
///  - available and selected: green look
///  - available and not selected: white box
///
/// API: label, note and isAvailable come from the slots of the chosen date.
class SlotCard extends StatelessWidget {
  final String label; // for example 'Lunch'
  final String note; // for example '7 pm – 11 pm' or 'Already booked'
  final bool isAvailable; // API: false when the slot is already booked
  final bool isSelected; // true for the slot the user picked

  const SlotCard({
    super.key,
    required this.label,
    required this.note,
    required this.isAvailable,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Default look: available but not selected
    Color bgColor = colors.bgSurface;
    Color borderColor = colors.border;
    double borderWidth = 1;
    Color? labelColor;
    Color noteColor = colors.textMuted;

    if (!isAvailable) {
      bgColor = colors.bgSubtle;
      borderColor = colors.borderDashed;
      labelColor = colors.textMuted;
    } else if (isSelected) {
      bgColor = colors.primaryTint;
      borderColor = colors.primaryBorder;
      borderWidth = 2;
      labelColor = colors.primaryInk;
      noteColor = colors.primaryInk;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        // NOTE: Figma has a dashed border for a booked slot. Flutter has no
        // dashed border without a package, so this is a plain border.
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.titleMedium(color: labelColor)),
          const SizedBox(height: 2),
          Text(note, style: AppTextStyles.caption(color: noteColor)),
        ],
      ),
    );
  }
}
