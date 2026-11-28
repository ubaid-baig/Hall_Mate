import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/manager/media_manager_controller.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/widgets/common/action_button.dart';
import 'package:hall_mate/widgets/manager/media_tile.dart';

// Photos & videos of the manager's venue.
//  - isSetup true:  step 2 of 2 after sign up, with a "Finish setup" button
//  - isSetup false: opened from the Dashboard or the My venue tab
class MediaManagerScreen extends StatelessWidget {
  final bool isSetup;

  const MediaManagerScreen({super.key, required this.isSetup});

  // Tap a tile: a small sheet with "Set as cover" and "Delete"
  void _showTileSheet(
    BuildContext context,
    AppColors colors,
    MediaManagerController controller,
    MediaModel item,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppTextStyles.h3()),
                const SizedBox(height: 4),
                Text(
                  item.isVideo ? 'Video' : 'Photo',
                  style: AppTextStyles.bodySmall(color: colors.textMuted),
                ),
                const SizedBox(height: 16),

                // Only a photo can be the cover
                if (!item.isVideo && !controller.isCover(item)) ...[
                  ActionButton(
                    label: 'Set as cover',
                    icon: Icons.star_outline_rounded,
                    bgColor: colors.primary,
                    borderColor: colors.primary,
                    textColor: colors.textOnPrimary,
                    onTap: () {
                      Navigator.pop(context);
                      controller.setCover(item);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
                ActionButton(
                  label: 'Delete',
                  icon: Icons.delete_outline,
                  bgColor: colors.dangerSoft,
                  borderColor: colors.dangerSoft,
                  textColor: colors.danger,
                  onTap: () {
                    Navigator.pop(context);
                    controller.delete(item);
                  },
                ),
                const SizedBox(height: 10),
                ActionButton(
                  label: 'Cancel',
                  bgColor: colors.bgSurface,
                  borderColor: colors.borderStrong,
                  textColor: colors.textPrimary,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // The tile at place [index] of a row, or an empty space
  Widget _tileOrSpace(
    BuildContext context,
    AppColors colors,
    MediaManagerController controller,
    List<MediaModel> row,
    int index,
  ) {
    if (index >= row.length) {
      return const SizedBox();
    }
    final MediaModel item = row[index];
    return MediaTile(
      media: item,
      isCover: controller.isCover(item),
      onTap: () {
        _showTileSheet(context, colors, controller, item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final MediaManagerController controller = Get.put(MediaManagerController());

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sw * 0.05,
                vertical: 12,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Photos & videos', style: AppTextStyles.h3()),
                      const SizedBox(height: 2),
                      // Obx: the numbers change after every upload or delete
                      Obx(
                        () => Text(
                          isSetup
                              ? 'Step 2 of 2 · ${controller.venue().mediaCountText()}'
                              : controller.venue().mediaCountText(),
                          style: AppTextStyles.caption(color: colors.textMuted),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: colors.border, height: 1),

            Expanded(
              child: Container(
                width: double.infinity,
                color: colors.bgScreen,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: sw * 0.05,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Upload buttons ──
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.bgSurface,
                          border: Border.all(color: colors.borderDashed),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 32,
                              color: colors.primaryInk,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Upload photos or videos',
                              style: AppTextStyles.titleMedium(),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Pick them from your phone\'s gallery',
                              style: AppTextStyles.bodySmall(
                                color: colors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: ActionButton(
                                    label: 'Add photos',
                                    icon: Icons.image_outlined,
                                    bgColor: colors.primary,
                                    borderColor: colors.primary,
                                    textColor: colors.textOnPrimary,
                                    onTap: () {
                                      controller.addPhotos();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ActionButton(
                                    label: 'Add video',
                                    icon: Icons.videocam_outlined,
                                    bgColor: colors.bgSurface,
                                    borderColor: colors.primaryBorder,
                                    textColor: colors.primaryInk,
                                    onTap: () {
                                      controller.addVideo();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: sh * 0.025),

                      Text('Gallery', style: AppTextStyles.h3()),
                      const SizedBox(height: 4),
                      Text(
                        'Tap a photo to make it the cover or to delete it. '
                        'The cover shows first in search.',
                        style: AppTextStyles.bodySmall(color: colors.textMuted),
                      ),
                      const SizedBox(height: 12),

                      // ── The grid: rows of 3 tiles ──
                      // Obx: a new photo appears straight away
                      Obx(() {
                        final List<List<MediaModel>> rows = controller.rows();

                        if (rows.isEmpty) {
                          return Text(
                            'No photos yet. Add at least one photo.',
                            style: AppTextStyles.bodyMedium(
                              color: colors.textMuted,
                            ),
                          );
                        }

                        return Column(
                          children: rows.map((row) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              // Always 3 places in a row. An empty place
                              // keeps the tiles of the last row narrow.
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _tileOrSpace(
                                      context,
                                      colors,
                                      controller,
                                      row,
                                      0,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _tileOrSpace(
                                      context,
                                      colors,
                                      controller,
                                      row,
                                      1,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _tileOrSpace(
                                      context,
                                      colors,
                                      controller,
                                      row,
                                      2,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

            // ── Finish button (setup only) ──
            if (isSetup)
              Container(
                color: colors.bgSurface,
                child: Column(
                  children: [
                    Divider(color: colors.border, height: 1),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: sw * 0.05,
                        vertical: 12,
                      ),
                      child: ActionButton(
                        label: 'Finish setup',
                        height: 52,
                        bgColor: colors.primary,
                        borderColor: colors.primary,
                        textColor: colors.textOnPrimary,
                        onTap: () {
                          controller.finishSetup();
                        },
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
