import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/widgets/common/media_box.dart';

// One photo or video in the manager's "Photos & videos" grid.
// The cover photo has an orange "Cover" badge on its corner.
class MediaTile extends StatelessWidget {
  final MediaModel media;
  final bool isCover;
  final VoidCallback onTap;

  const MediaTile({
    super.key,
    required this.media,
    required this.isCover,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      // Stack: the picture at the back, the badge on top of it
      child: Stack(
        children: [
          MediaBox(
            media: media,
            width: double.infinity,
            height: 100,
            borderRadius: BorderRadius.circular(14),
          ),
          if (isCover)
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Cover',
                  style: AppTextStyles.labelTiny(color: colors.textOnAccent),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
