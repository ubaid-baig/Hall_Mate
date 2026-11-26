import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaItem {
  const MediaItem(this.name, this.color, {this.isVideo = false});

  final String name;
  final Color color; // placeholder colour until real images are used
  final bool isVideo;
}

class MediaManagerController extends GetxController {
  /// How many tiles show before "Show all" is tapped.
  static const int previewCount = 9;

  final RxList<MediaItem> items = <MediaItem>[
    MediaItem('Main hall', Color(0xFF3C6E71)),
    MediaItem('Walkthrough', Color(0xFF3B4A6B), isVideo: true),
    MediaItem('Stage', Color(0xFF2F7F6A)),
    MediaItem('Family hall', Color(0xFF3F5B4F)),
    MediaItem('Dining', Color(0xFF4A5F7A)),
    MediaItem('Entrance', Color(0xFF7A5B3A)),
    MediaItem('Bridal room', Color(0xFF2F6F6A)),
    MediaItem('Lighting', Color(0xFF45557A)),
    MediaItem('Parking', Color(0xFF7A5E3E)),
    MediaItem('Garden entry', Color(0xFF3F6B4F)),
    MediaItem('Stage side', Color(0xFF2F7F6A)),
    MediaItem('Table setup', Color(0xFF4A5F7A)),
    MediaItem('Buffet', Color(0xFF7A5B3A)),
    MediaItem('Lobby', Color(0xFF3C6E71)),
    MediaItem('Bridal suite', Color(0xFF45557A)),
    MediaItem('Exterior', Color(0xFF7A5E3E)),
  ].obs;

  /// Index of the selected tile. -1 = nothing selected.
  final RxInt selectedIndex = 2.obs;
  final RxString coverName = 'Main hall'.obs;
  final RxBool showAll = false.obs;

  /// Upload in progress (static demo value).
  final RxDouble uploadProgress = 0.72.obs;

  int get photoCount => items.where((e) => !e.isVideo).length;
  int get videoCount => items.where((e) => e.isVideo).length;

  List<MediaItem> get visibleItems =>
      showAll.value ? items.toList() : items.take(previewCount).toList();

  void toggleSelect(int i) =>
      selectedIndex.value = selectedIndex.value == i ? -1 : i;

  void clearSelection() => selectedIndex.value = -1;

  void setAsCover() {
    final i = selectedIndex.value;
    if (i < 0) return;
    coverName.value = items[i].name;
    clearSelection();
  }

  void deleteSelected() {
    final i = selectedIndex.value;
    if (i < 0) return;
    final removed = items.removeAt(i);
    if (coverName.value == removed.name && items.isNotEmpty) {
      coverName.value = items.first.name;
    }
    clearSelection();
  }

  /// Drag and drop: move the tile at [from] to position [to].
  void move(int from, int to) {
    if (from == to) return;
    final item = items.removeAt(from);
    items.insert(to, item);
    clearSelection();
  }

  void pickFiles() {
    // TODO: use the image_picker package here to choose photos / videos.
    Get.snackbar('Upload', 'Connect the image_picker package to choose files.');
  }
}