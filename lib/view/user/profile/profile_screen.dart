import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/user/profile/profile_controller.dart';
import 'package:hall_mate/controller/shared/theme_controller.dart';
import 'package:hall_mate/widgets/user/profile/profile_row.dart';
import 'package:hall_mate/view/user/venue/favourite_screen.dart';

// This is the "Profile & settings" tab.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final ProfileController controller = Get.put(ProfileController());
    // Already created in main.dart
    final ThemeController themeController = Get.find<ThemeController>();

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
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: colors.photoMarigold,
                        child: Text(
                          // API: first letters of the user's name
                          controller.initials,
                          style: AppTextStyles.titleLarge(
                            color: colors.photoMarigoldInk,
                          ),
                        ),
                      ),
                      SizedBox(height: sh * 0.012),
                      // API: name, email and phone come from the user profile
                      Text(controller.name, style: AppTextStyles.h2()),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.email} · ${controller.phone}',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall(color: colors.textMuted),
                      ),
                      SizedBox(height: sh * 0.012),
                      // API: the user's role (Customer or Venue manager)
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
                              controller.role,
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
                          // Later: open the Edit profile screen
                          onPressed: () {},
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
                                Icons.edit_outlined,
                                size: 18,
                                color: colors.textPrimary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Edit profile',
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
                      // Later: add onTap to each row to open its screen
                      const ProfileRow(
                        icon: Icons.person_outline,
                        title: 'Personal info',
                        subtitle: 'Name, phone and photo',
                      ),
                      const ProfileRow(
                        icon: Icons.lock_outline_rounded,
                        title: 'Change password',
                      ),
                      ProfileRow(
                        icon: Icons.credit_card_outlined,
                        title: 'Payment methods',
                        // API: the saved card
                        subtitle: 'Card ending ${controller.cardEnding}',
                      ),
                      ProfileRow(
                        icon: Icons.favorite_border_rounded,
                        title: 'Saved venues',
                        // API: number of favourite venues
                        subtitle: '${controller.savedVenuesCount} venues',
                        showDivider: false,
                        // Opens the Saved venues screen
                        onTap: () {
                          Get.to(() => const FavouriteScreen());
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sh * 0.025),

                // ── PREFERENCES (Notifications + Dark mode Switch + Language) ──
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
                  child: Column(
                    children: [
                      ProfileRow(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifications',
                        subtitle: 'Offers, messages and reminders',
                        trailing: Obx(
                          () => Switch(
                            value: controller.isNotificationsOn.value,
                            onChanged: controller.toggleNotifications,
                          ),
                        ),
                      ),
                      // The dark mode Switch we built earlier.
                      ProfileRow(
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark mode',
                        subtitle: 'Switch between light and dark',
                        trailing: Obx(
                          () => Switch(
                            value: themeController.isDarkMode.value,
                            onChanged: themeController.toggleTheme,
                          ),
                        ),
                      ),
                      ProfileRow(
                        icon: Icons.language_rounded,
                        title: 'Language',
                        subtitle: controller.language,
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sh * 0.025),

                // ── SUPPORT ──
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    'SUPPORT',
                    style: AppTextStyles.labelSmall(color: colors.textMuted),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: colors.bgSurface,
                    border: Border.all(color: colors.border),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    children: [
                      ProfileRow(
                        icon: Icons.help_outline_rounded,
                        title: 'Help center',
                      ),
                      ProfileRow(
                        icon: Icons.verified_user_outlined,
                        title: 'Terms & privacy',
                        showDivider: false,
                      ),
                    ],
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
                  child: const ProfileRow(
                    icon: Icons.logout_rounded,
                    title: 'Log out',
                    isDanger: true,
                    showDivider: false,
                    // Later: clear the saved token and go to the Login screen
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
