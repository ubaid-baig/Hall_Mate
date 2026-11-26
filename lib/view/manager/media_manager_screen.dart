import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/manager/media_manager_controller.dart';
import 'package:hall_mate/widgets/manager/manager_widget.dart';
import 'package:hall_mate/widgets/manager/venue_setup.dart';

class MediaManagerScreen extends StatelessWidget {
  const MediaManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final MediaManagerController c = Get.put(MediaManagerController());

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              final videos = c.videoCount;
              return ManagerTopBar(
                title: 'Photos & videos',
                subtitle:
                    '${c.photoCount} photos · $videos video${videos == 1 ? '' : 's'}',
              );
            }),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(sw * 0.05, sh * 0.02, sw * 0.05, sh * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------- Upload box ----------
                    GestureDetector(
                      onTap: c.pickFiles,
                      child: DashedBox(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 26),
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: colors.bgScreen,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: colors.borderStrong),
                                ),
                                child: Icon(Icons.file_upload_outlined,
                                    size: 20, color: colors.textPrimary),
                              ),
                              const SizedBox(height: 10),
                              Text('Upload photos or videos',
                                  style: AppTextStyles.titleSmall()),
                              const SizedBox(height: 3),
                              Text(
                                'JPG, PNG or MP4 from your gallery or camera',
                                style: AppTextStyles.bodySmall(
                                    color: colors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: sh * 0.02),

                    // ---------- Upload progress ----------
                    Obx(
                      () => _UploadRow(
                        icon: Icons.image_outlined,
                        name: 'stage-decor.jpg',
                        progress: c.uploadProgress.value,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const _UploadRow(
                      icon: Icons.videocam_outlined,
                      name: 'walkthrough.mp4',
                      doneText: 'Uploaded · 2:14',
                    ),
                    SizedBox(height: sh * 0.025),

                    // ---------- Gallery ----------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Gallery', style: venueCardTitle()),
                        GestureDetector(
                          onTap: () => c.showAll.value = !c.showAll.value,
                          child: Obx(
                            () => Text(
                              c.showAll.value ? 'Show less' : 'Show all',
                              style: AppTextStyles.titleSmall(
                                  color: colors.primaryInk),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to select. Long-press and drag to reorder. '
                      'The cover shows first in search.',
                      style: AppTextStyles.bodySmall(color: colors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      final list = c.visibleItems;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (_, i) => _MediaTile(
                          index: i,
                          item: list[i],
                          controller: c,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ---------- Action bar (only while a tile is selected) ----------
      bottomNavigationBar: Obx(() {
        if (c.selectedIndex.value < 0) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.fromLTRB(sw * 0.05, 12, sw * 0.05, 12),
          decoration: BoxDecoration(
            color: colors.bgScreen,
            border: Border(top: BorderSide(color: colors.borderStrong)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: ManagerButton(
                    text: 'Set as cover',
                    icon: Icons.image_outlined,
                    type: ManagerButtonType.filled,
                    height: 48,
                    onPressed: c.setAsCover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ManagerButton(
                    text: 'Delete',
                    icon: Icons.delete_outline,
                    type: ManagerButtonType.danger,
                    height: 48,
                    onPressed: () => _confirmDelete(c),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: c.clearSelection,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.borderStrong),
                    ),
                    child: Icon(Icons.close, color: colors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

void _confirmDelete(MediaManagerController c) {
  Get.defaultDialog(
    title: 'Delete this file?',
    middleText: 'This cannot be undone.',
    textConfirm: 'Delete',
    textCancel: 'Cancel',
    onConfirm: () {
      c.deleteSelected();
      Get.back();
    },
  );
}

// =====================================================================
// One row in the "uploading" list
// =====================================================================

class _UploadRow extends StatelessWidget {
  const _UploadRow({
    required this.icon,
    required this.name,
    this.progress,
    this.doneText,
  });

  final IconData icon;
  final String name;
  final double? progress; // set while uploading
  final String? doneText; // set when finished

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final uploading = progress != null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bgScreen,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.borderStrong),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: venueAmber.withOpacity(0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: venueAmber),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: uploading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.titleSmall()),
                          ),
                          Text('${(progress! * 100).round()}%',
                              style: AppTextStyles.bodySmall(
                                  color: colors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        borderRadius: BorderRadius.circular(4),
                        color: colors.primaryInk,
                        backgroundColor: colors.borderStrong,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTextStyles.titleSmall()),
                      const SizedBox(height: 2),
                      Text(doneText ?? '',
                          style: AppTextStyles.bodySmall(
                              color: colors.textSecondary)),
                    ],
                  ),
          ),
          const SizedBox(width: 8),
          uploading
              ? Icon(Icons.close, size: 18, color: colors.textMuted)
              : Icon(Icons.check_circle, size: 22, color: colors.primaryInk),
        ],
      ),
    );
  }
}

// =====================================================================
// One gallery tile (tap = select, long-press + drag = reorder)
// =====================================================================

class _MediaTile extends StatelessWidget {
  const _MediaTile({
    required this.index,
    required this.item,
    required this.controller,
  });

  final int index;
  final MediaItem item;
  final MediaManagerController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedIndex.value == index;
      final isCover = controller.coverName.value == item.name;
      final body = _TileBody(item: item, selected: selected, isCover: isCover);

      return LongPressDraggable<int>(
        data: index,
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: 110,
            height: 110,
            child: Opacity(opacity: 0.9, child: body),
          ),
        ),
        childWhenDragging: Opacity(opacity: 0.3, child: body),
        child: DragTarget<int>(
          onWillAcceptWithDetails: (details) => details.data != index,
          onAcceptWithDetails: (details) => controller.move(details.data, index),
          builder: (context, candidate, rejected) => GestureDetector(
            onTap: () => controller.toggleSelect(index),
            child: Opacity(
              opacity: candidate.isEmpty ? 1 : 0.6,
              child: body,
            ),
          ),
        ),
      );
    });
  }
}

class _TileBody extends StatelessWidget {
  const _TileBody({
    required this.item,
    required this.selected,
    required this.isCover,
  });

  final MediaItem item;
  final bool selected;
  final bool isCover;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? colors.primaryInk : colors.borderStrong,
          width: selected ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: item.isVideo
                ? Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 22),
                  )
                : Icon(Icons.image_outlined,
                    size: 22, color: colors.textPrimary.withOpacity(0.8)),
          ),
          Positioned(
            left: 8,
            right: 8,
            bottom: 6,
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall(color: colors.textPrimary)
                  .copyWith(fontSize: 10.5),
            ),
          ),
          if (isCover)
            const Positioned(
              left: 6,
              top: 6,
              child: ManagerBadge(text: 'Cover', color: venueAmber, small: true),
            ),
          Positioned(
            right: 6,
            top: 6,
            child: selected
                ? Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check,
                        size: 14, color: colors.textOnPrimary),
                  )
                : Icon(Icons.drag_indicator,
                    size: 16, color: colors.textPrimary.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}