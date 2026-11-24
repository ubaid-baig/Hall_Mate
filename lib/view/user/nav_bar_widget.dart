import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/shared/nav_controller.dart';
import 'package:hall_mate/view/user/booking/booking_screen.dart';
import 'package:hall_mate/view/user/chat/chat_screen.dart';
import 'package:hall_mate/view/user/home/home_screen.dart';
import 'package:hall_mate/view/user/profile/profile_screen.dart';
import 'package:hall_mate/view/user/venue/search_screen.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final NavController navController = Get.find<NavController>();

    final List<Widget> screenList = [
      HomeScreen(),
      SearchScreen(),
      BookingScreen(),
      ChatScreen(),
      ProfileScreen(),
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
                child: const Icon(Icons.home_outlined),
              ),
              label: 'Home',
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
                child: const Icon(Icons.search),
              ),
              label: 'Search',
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
                child: const Icon(Icons.calendar_month_outlined),
              ),
              label: 'Bookings',
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
