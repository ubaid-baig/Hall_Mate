import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/user/venue/media_gallery_controller.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/widgets/common/media_box.dart';

// The photos and videos the venue manager uploaded.
class MediaGalleryScreen extends StatelessWidget {
  final String venueId;
  final bool startOnVideos;

  const MediaGalleryScreen({
    super.key,
    required this.venueId,
    this.startOnVideos = false,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    // The gallery always uses the dark colours, like a photo viewer
    final colors = AppColors.dark;
    final MediaGalleryController controller = Get.put(
      MediaGalleryController(startTab: startOnVideos ? 1 : 0),
    );
    final AppDataController data = Get.find<AppDataController>();

    return Scaffold(
      backgroundColor: colors.bgScreen,
      body: SafeArea(
        // Obx: the big picture, the counter and the tabs change on every tap
        child: Obx(() {
          final VenueModel venue = data.venueById(venueId);
          final int tab = controller.selectedTabIndex.value;
          final int selected = controller.selectedIndex.value;
          final List<MediaModel> list = controller.items(venue);
          final MediaModel? item = controller.selectedItem(venue);

          return Column(
            children: [
              // ── Top bar: close (left), counter and venue name (middle) ──
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
                          Text(
                            controller.counterText(venue),
                            style: AppTextStyles.titleMedium(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            venue.name,
                            style: AppTextStyles.caption(color: colors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    // Same width as the close button, so the title is centred
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // ── The big photo or video ──
              Expanded(
                child: item == null
                    ? Center(
                        child: Text(
                          tab == 0 ? 'No photos yet' : 'No videos yet',
                          style: AppTextStyles.bodyMedium(
                            color: colors.textMuted,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (item.isVideo) {
                            controller.playVideo();
                          }
                        },
                        child: MediaBox(
                          media: item,
                          width: double.infinity,
                          height: double.infinity,
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
              ),

              // ── Title, thumbnails and tabs ──
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
                    if (item != null) ...[
                      Text(
                        item.title,
                        style: AppTextStyles.titleMedium(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Uploaded by the venue',
                        style: AppTextStyles.caption(color: colors.textMuted),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Small pictures (scroll sideways). Tap one to show it big.
                    if (list.isNotEmpty) ...[
                      SizedBox(
                        height: 52,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final bool isSelected = selected == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  controller.selectItem(index);
                                },
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
                                  child: MediaBox(
                                    media: list[index],
                                    width: 44,
                                    height: 44,
                                    showLabel: false,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // ── Photos / Videos tabs ──
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
                              onTap: () {
                                controller.selectTab(0);
                              },
                              child: Container(
                                height: 38,
                                decoration: BoxDecoration(
                                  color: tab == 0
                                      ? colors.textPrimary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    controller.photosTab(venue),
                                    style: AppTextStyles.titleSmall(
                                      color: tab == 0
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
                              onTap: () {
                                controller.selectTab(1);
                              },
                              child: Container(
                                height: 38,
                                decoration: BoxDecoration(
                                  color: tab == 1
                                      ? colors.textPrimary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    controller.videosTab(venue),
                                    style: AppTextStyles.titleSmall(
                                      color: tab == 1
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
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
