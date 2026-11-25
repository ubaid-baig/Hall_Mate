import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';

/// A row of 5 stars. The first [rating] stars are filled (orange),
/// the others are empty outlines.
///
/// API: rating comes from the review (1 to 5).
///
/// onStarTap is optional. If the screen passes it, the stars can be
/// tapped, and it receives the number of the tapped star (1 to 5).
class StarRow extends StatelessWidget {
  final int rating; // 0 to 5
  final double size; // size of one star
  final double gap; // space between the stars
  // A function that receives a number: void Function(int)
  final void Function(int)? onStarTap;

  const StarRow({
    super.key,
    required this.rating,
    this.size = 18,
    this.gap = 2,
    this.onStarTap,
  });

  // One star: filled if the rating reaches this position, outline if not.
  Widget _star(AppColors colors, int position) {
    final bool isFilled = rating >= position;

    return GestureDetector(
      onTap: () {
        // Only if the screen passed a function (?. means "if not null")
        onStarTap?.call(position);
      },
      child: Icon(
        isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
        size: size,
        color: isFilled ? colors.iconStar : colors.borderStrong,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _star(colors, 1),
        SizedBox(width: gap),
        _star(colors, 2),
        SizedBox(width: gap),
        _star(colors, 3),
        SizedBox(width: gap),
        _star(colors, 4),
        SizedBox(width: gap),
        _star(colors, 5),
      ],
    );
  }
}
