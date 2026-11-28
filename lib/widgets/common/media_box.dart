import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/widgets/common/photo_placeholder.dart';

// Shows one photo or video of a venue.
//  - a photo picked from the phone: the real picture
//  - a video: a dark box with a play button and its name
//  - dummy items: the coloured placeholder box
// Used by the manager's Photos & videos and the customer's venue screens.
class MediaBox extends StatelessWidget {
  final MediaModel media;
  final double? width;
  final double height;
  final BorderRadius borderRadius;
  final bool showLabel;
  // Optional row drawn on top of a photo (for example a tag and a heart)
  final Widget? topRow;

  const MediaBox({
    super.key,
    required this.media,
    required this.height,
    required this.borderRadius,
    this.width,
    this.showLabel = true,
    this.topRow,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // ── Video ──
    if (media.isVideo) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colors.photoSlate,
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: colors.bgSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                size: 22,
                color: colors.textPrimary,
              ),
            ),
            if (showLabel) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  media.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSmall(color: colors.photoSlateInk),
                ),
              ),
            ],
          ],
        ),
      );
    }

    // ── Photo picked from the phone ──
    if (media.filePath != null) {
      return Container(
        width: width,
        height: height,
        padding: topRow == null ? null : const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: DecorationImage(
            image: FileImage(File(media.filePath!)),
            fit: BoxFit.cover,
          ),
        ),
        child: topRow == null ? null : Column(children: [topRow!]),
      );
    }

    // ── Dummy photo ──
    return PhotoPlaceholder(
      photoStyle: media.photoStyle,
      width: width,
      height: height,
      iconSize: 24,
      showLabel: showLabel,
      label: media.title,
      borderRadius: borderRadius,
      topRow: topRow,
    );
  }
}
