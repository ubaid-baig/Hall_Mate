import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// A coloured box with an image icon. It stands in for a venue photo.
///
/// API: when you have real photos, replace the Column/Icon inside this
/// widget with the real image (for example the venue's photo URL).
class PhotoPlaceholder extends StatelessWidget {
  final String photoStyle; // DUMMY ONLY: 'emerald', 'marigold' or 'slate'
  final double? width;
  final double height;
  final double iconSize;
  final bool showLabel; // shows the text "Hall photo" under the icon
  final BorderRadius borderRadius;
  final Widget? topRow; // optional row on top of the photo (tag + heart)

  const PhotoPlaceholder({
    super.key,
    required this.photoStyle,
    required this.height,
    required this.borderRadius,
    this.width,
    this.iconSize = 26,
    this.showLabel = false,
    this.topRow,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Pick the background and icon colour from the dummy style name.
    Color bgColor = colors.photoEmerald;
    Color inkColor = colors.photoEmeraldInk;
    if (photoStyle == 'marigold') {
      bgColor = colors.photoMarigold;
      inkColor = colors.photoMarigoldInk;
    } else if (photoStyle == 'slate') {
      bgColor = colors.photoSlate;
      inkColor = colors.photoSlateInk;
    }

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.image_outlined, size: iconSize, color: inkColor),
        if (showLabel) ...[
          const SizedBox(height: 6),
          Text('Hall photo', style: AppTextStyles.labelSmall(color: inkColor)),
        ],
      ],
    );

    return Container(
      width: width,
      height: height,
      padding: topRow == null ? null : const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bgColor, borderRadius: borderRadius),
      child: topRow == null
          ? Center(child: content)
          : Column(
              children: [
                topRow!,
                Expanded(child: Center(child: content)),
              ],
            ),
    );
  }
}
