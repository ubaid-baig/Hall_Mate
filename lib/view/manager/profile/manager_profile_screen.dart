import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/manager/manager_notifications_controller.dart';
import 'package:hall_mate/controller/manager/manager_profile_controller.dart';
import 'package:hall_mate/controller/shared/theme_controller.dart';
import 'package:hall_mate/view/manager/dashboard/manager_notifications_screen.dart';
import 'package:hall_mate/view/manager/venue/media_manager_screen.dart';
import 'package:hall_mate/widgets/common/profile_row.dart';

// Profile tab (manager). Built like the customer's Profile,
// with the manager's own rows.
class ManagerProfileScreen extends StatelessWidget {
  const ManagerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final ManagerProfileController controller = Get.put(
      ManagerProfileController(),
    );
    final ThemeController themeController = Get.find<ThemeController>();
    final ManagerNotificationsController notificationsController = Get.put(
      ManagerNotificationsController(),
    );

    return Scaffold(
      backgroundColor: colors.bgScreen,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: sw * 0.05,
              right: sw * 0.05,
              top: sh * 0.02,
              bottom: sh * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Profile card ──
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: sh * 0.025,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: colors.bgSurface,
                    border: Border.all(color: colors.border),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Obx: the photo shows after it is taken
                      Obx(
                        () => controller.pickedImage.value != null
                            ? CircleAvatar(
                                radius: 36,
                                backgroundImage:
                                    FileImage(controller.pickedImage.value!),
                              )
                            : CircleAvatar(
                                radius: 36,
                                backgroundColor: colors.photoEmerald,
                                child: Text(
                                  controller.initials(),
                                  style: AppTextStyles.titleLarge(
                                    color: colors.photoEmeraldInk,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: sh * 0.012),
                      Text(controller.name(), style: AppTextStyles.h2()),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.email()} · ${controller.phone()}',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall(color: colors.textMuted),
                      ),
                      SizedBox(height: sh * 0.012),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primarySoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.storefront_outlined,
                              size: 16,
                              color: colors.primaryInk,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Venue manager',
                              style: AppTextStyles.labelSmall(
                                color: colors.primaryInk,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: sh * 0.018),
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: controller.openCamera,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.bgSurface,
                            foregroundColor: colors.textPrimary,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(color: colors.borderStrong),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.photo_camera_outlined,
                                size: 18,
                                color: colors.textPrimary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Change photo',
                                style: AppTextStyles.titleSmall(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sh * 0.025),

                // ── MY VENUE ──
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    'MY VENUE',
                    style: AppTextStyles.labelSmall(color: colors.textMuted),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: colors.bgSurface,
                    border: Border.all(color: colors.border),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  // Obx: the venue name, counts and unread number stay up to date
                  child: Obx(
                    () => Column(
                      children: [
                        ProfileRow(
                          icon: Icons.storefront_outlined,
                          title: 'Venue details',
                          subtitle:
                              '${controller.venue().name} · ${controller.venue().type}',
                          onTap: () {
                            controller.openVenueTab();
                          },
                        ),
                        ProfileRow(
                          icon: Icons.image_outlined,
                          title: 'Photos & videos',
                          subtitle: controller.venue().mediaCountText(),
                          onTap: () {
                            Get.to(() => const MediaManagerScreen(isSetup: false));
                          },
                        ),
                        ProfileRow(
                          icon: Icons.notifications_none_rounded,
                          title: 'Notifications',
                          subtitle: notificationsController.unreadText(),
                          showDivider: false,
                          onTap: () {
                            Get.to(() => const ManagerNotificationsScreen());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.025),

                // ── PREFERENCES ──
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    'PREFERENCES',
                    style: AppTextStyles.labelSmall(color: colors.textMuted),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: colors.bgSurface,
                    border: Border.all(color: colors.border),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ProfileRow(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark mode',
                    subtitle: 'Switch between light and dark',
                    showDivider: false,
                    trailing: Obx(
                      () => Switch(
                        value: themeController.isDarkMode.value,
                        onChanged: themeController.toggleTheme,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.02),

                // ── Log out ──
                Container(
                  decoration: BoxDecoration(
                    color: colors.bgSurface,
                    border: Border.all(color: colors.border),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ProfileRow(
                    icon: Icons.logout_rounded,
                    title: 'Log out',
                    isDanger: true,
                    showDivider: false,
                    onTap: () {
                      controller.logOut();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
