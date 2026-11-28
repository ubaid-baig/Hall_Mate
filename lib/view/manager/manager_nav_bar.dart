import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/manager/manager_nav_controller.dart';
import 'package:hall_mate/view/manager/chat/manager_chat_screen.dart';
import 'package:hall_mate/view/manager/dashboard/dashboard_screen.dart';
import 'package:hall_mate/view/manager/profile/manager_profile_screen.dart';
import 'package:hall_mate/view/manager/requests/requests_screen.dart';
import 'package:hall_mate/view/manager/venue/venue_form_screen.dart';

class ManagerNavBar extends StatelessWidget {
  const ManagerNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final ManagerNavController navController = Get.find<ManagerNavController>();

    final List<Widget> screenList = [
      const DashboardScreen(),
      const RequestsScreen(),
      const VenueFormScreen(isSetup: false),
      const ManagerChatScreen(),
      const ManagerProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: colors.bgScreen,
      body: Obx(() => screenList[navController.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navController.currentIndex.value,
          onTap: navController.changeIndex,
          type: BottomNavigationBarType.shifting,
          elevation: 1,
          backgroundColor: colors.bgSurface,
          selectedItemColor: colors.primaryInk,
          unselectedItemColor: colors.textMuted,
          selectedLabelStyle: AppTextStyles.bodySmall(
            color: colors.primaryInk,
          ),
          unselectedLabelStyle: AppTextStyles.bodySmall(
            color: colors.textMuted,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: navController.currentIndex.value == 0
                      ? colors.primarySoft
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.grid_view_outlined),
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: navController.currentIndex.value == 1
                      ? colors.primarySoft
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.inbox_outlined),
              ),
              label: 'Requests',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: navController.currentIndex.value == 2
                      ? colors.primarySoft
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.storefront_outlined),
              ),
              label: 'My venue',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: navController.currentIndex.value == 3
                      ? colors.primarySoft
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.mode_comment_outlined),
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: navController.currentIndex.value == 4
                      ? colors.primarySoft
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person_outline),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
