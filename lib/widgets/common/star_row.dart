import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';

/// A row of 5 stars. The first [rating] stars are filled (orange),
/// the others are empty outlines.
///
/// API: rating comes from the review (1 to 5).
/// Later: wrap each star in a GestureDetector so the user can tap a rating.
class StarRow extends StatelessWidget {
  final int rating; // 0 to 5
  final double size; // size of one star
  final double gap; // space between the stars

  const StarRow({
    super.key,
    required this.rating,
    this.size = 18,
    this.gap = 2,
  });

  // One star: filled if the rating reaches this position, outline if not.
  Widget _star(AppColors colors, int position) {
    final bool isFilled = rating >= position;

    return Icon(
      isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
      size: size,
      color: isFilled ? colors.iconStar : colors.borderStrong,
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
