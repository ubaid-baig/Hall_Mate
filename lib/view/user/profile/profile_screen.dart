import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/shared/theme_controller.dart';
import 'package:hall_mate/controller/user/home/notifications_controller.dart';
import 'package:hall_mate/controller/user/profile/profile_controller.dart';
import 'package:hall_mate/controller/user/venue/favourite_controller.dart';
import 'package:hall_mate/view/user/home/notifications_screen.dart';
import 'package:hall_mate/view/user/venue/favourite_screen.dart';
import 'package:hall_mate/widgets/common/profile_row.dart';

// Profile tab (customer). The manager has her own Profile screen.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final ProfileController controller = Get.put(ProfileController());
    final ThemeController themeController = Get.find<ThemeController>();
    final FavouriteController favController = Get.find<FavouriteController>();
    final NotificationsController notificationsController = Get.put(
      NotificationsController(),
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
                                backgroundColor: colors.photoMarigold,
                                child: Text(
                                  controller.initials(),
                                  style: AppTextStyles.titleLarge(
                                    color: colors.photoMarigoldInk,
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
                              Icons.person_outline,
                              size: 16,
                              color: colors.primaryInk,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              controller.role(),
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
                          // Opens the camera to take a profile photo
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

                // ── ACCOUNT ──
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    'ACCOUNT',
                    style: AppTextStyles.labelSmall(color: colors.textMuted),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: colors.bgSurface,
                    border: Border.all(color: colors.border),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      ProfileRow(
                        icon: Icons.calendar_month_outlined,
                        title: 'My bookings',
                        subtitle: 'Requests, offers and payments',
                        onTap: () {
                          controller.openBookingsTab();
                        },
                      ),
                      // Obx: the number changes when a heart is tapped
                      Obx(
                        () => ProfileRow(
                          icon: Icons.favorite_border_rounded,
                          title: 'Saved venues',
                          subtitle: favController.countText(),
                          onTap: () {
                            Get.to(() => const FavouriteScreen());
                          },
                        ),
                      ),
                      // Obx: the unread number follows the notifications
                      Obx(
                        () => ProfileRow(
                          icon: Icons.notifications_none_rounded,
                          title: 'Notifications',
                          subtitle: notificationsController.unreadText(),
                          showDivider: false,
                          onTap: () {
                            Get.to(() => const NotificationsScreen());
                          },
                        ),
                      ),
                    ],
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
