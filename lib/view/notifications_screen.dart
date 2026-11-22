import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/notifications_controller.dart';
import 'package:hall_mate/widgets/notification_tile.dart';

// Notifications. Opens from the bell on the Home screen.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  // One section: a small title (TODAY ...) and one white card with its rows.
  Widget _buildSection(
    AppColors colors,
    String title,
    List<Map<String, dynamic>> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: AppTextStyles.labelSmall(color: colors.textMuted),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.bgSurface,
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            // API: one row for every notification of that day
            children: items.map((item) {
              return NotificationTile(
                iconType: item['iconType'],
                title: item['title'],
                message: item['message'],
                time: item['time'],
                isUnread: item['isUnread'],
                // no line under the last row
                showDivider: item != items.last,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final NotificationsController controller = Get.put(
      NotificationsController(),
    );

    return Scaffold(
      // White, so the status bar area matches the white top bar.
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            // ════════ TOP BAR ════════
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Notifications', style: AppTextStyles.h3()),
                        const SizedBox(height: 2),
                        // API: how many notifications are not read yet
                        Text(
                          controller.unreadText,
                          style: AppTextStyles.caption(color: colors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    // Later: mark all notifications as read
                    onTap: () {},
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colors.bgSurface,
                        border: Border.all(color: colors.border),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 22,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: colors.border, height: 1),

            // ════════ LIST (this part scrolls up and down) ════════
            Expanded(
              child: Container(
                width: double.infinity,
                color: colors.bgScreen,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: sw * 0.05,
                      right: sw * 0.05,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(colors, 'TODAY', controller.today),
                        _buildSection(colors, 'YESTERDAY', controller.yesterday),
                        _buildSection(colors, 'EARLIER', controller.earlier),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
