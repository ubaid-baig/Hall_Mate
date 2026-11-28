import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';

class StarRow extends StatelessWidget {
  final int rating;
  final double size;
  final double gap;

  final void Function(int)? onStarTap;

  const StarRow({
    super.key,
    required this.rating,
    this.size = 18,
    this.gap = 2,
    this.onStarTap,
  });


  Widget _star(AppColors colors, int position) {
    final bool isFilled = rating >= position;

    return GestureDetector(
      onTap: () {
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
