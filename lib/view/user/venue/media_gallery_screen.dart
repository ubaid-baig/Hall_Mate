import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/user/venue/media_gallery_controller.dart';
import 'package:hall_mate/widgets/common/photo_placeholder.dart';

// Media gallery. Opens from the "1 / 15 photos" button on Venue detail.
// It is always dark (like a photo viewer), so it uses the DARK colours even
// when the app is in light mode. Every Text below has its colour written
// for that reason.
class MediaGalleryScreen extends StatelessWidget {
  const MediaGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    // Always the dark colours
    final colors = AppColors.dark;
    final MediaGalleryController controller = Get.put(MediaGalleryController());

    return Scaffold(
      backgroundColor: colors.bgScreen,
      body: SafeArea(
        child: Column(
          children: [
            // ════════ TOP BAR: close, counter, share ════════
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sw * 0.04,
                vertical: 10,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.bgSubtle,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 22,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        // API: position of the selected photo and the total
                        Text(
                          controller.counterText,
                          style: AppTextStyles.titleMedium(
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          controller.venueName,
                          style: AppTextStyles.caption(color: colors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    // Later: share this photo
                    onTap: () {},
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.bgSubtle,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.share_outlined,
                        size: 20,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ════════ BIG PICTURE (takes all the free space) ════════
            Expanded(
              // API: the selected photo (here only a coloured box)
              child: PhotoPlaceholder(
                photoStyle: controller.bigPhoto,
                width: double.infinity,
                height: double.infinity,
                iconSize: 32,
                showLabel: true,
                label: controller.bigLabel,
                borderRadius: BorderRadius.zero,
              ),
            ),

            // ════════ BOTTOM PART: title, small pictures, tabs, video ════════
            Padding(
              padding: EdgeInsets.only(
                left: sw * 0.05,
                right: sw * 0.05,
                top: 14,
                bottom: 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // API: the title and uploader of the selected photo
                  Text(
                    controller.photoTitle,
                    style: AppTextStyles.titleMedium(color: colors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.uploadedBy,
                    style: AppTextStyles.caption(color: colors.textMuted),
                  ),
                  const SizedBox(height: 12),

                  // ── Small pictures (scroll sideways) ──
                  SizedBox(
                    height: 52,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // API: one small picture for every photo
                      itemCount: controller.thumbs.length,
                      itemBuilder: (context, index) {
                        final bool isSelected =
                            controller.selectedThumbIndex == index;

                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            // Later: show this photo in the big picture
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? colors.accent
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: PhotoPlaceholder(
                                photoStyle: controller.thumbs[index],
                                width: 44,
                                height: 44,
                                iconSize: 20,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Tabs: Photos | Videos ──
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colors.bgSurface,
                      border: Border.all(color: colors.border),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            // Later: show the photos
                            onTap: () {},
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(
                                color: controller.selectedTabIndex == 0
                                    ? colors.textPrimary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  controller.photosTab,
                                  style: AppTextStyles.titleSmall(
                                    color: controller.selectedTabIndex == 0
                                        ? colors.bgScreen
                                        : colors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            // Later: show the videos
                            onTap: () {},
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(
                                color: controller.selectedTabIndex == 1
                                    ? colors.textPrimary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  controller.videosTab,
                                  style: AppTextStyles.titleSmall(
                                    color: controller.selectedTabIndex == 1
                                        ? colors.bgScreen
                                        : colors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Video row ──
                  GestureDetector(
                    // Later: play the walkthrough video
                    onTap: () {},
                    child: Row(
                      children: [
                        Container(
                          width: 96,
                          height: 58,
                          decoration: BoxDecoration(
                            // The placeholder colour follows the app theme
                            color: AppColors.of(context).photoSlate,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: colors.bgScreen,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.play_arrow_rounded,
                                size: 20,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // API: title and length of the video
                              Text(
                                controller.videoTitle,
                                style: AppTextStyles.titleSmall(
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.videoSubtitle,
                                style: AppTextStyles.caption(
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
