import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/manager/dashboard/manager_nav_controller.dart';
// import 'package:hall_mate/view/availability_calendar_screen.dart';
import 'package:hall_mate/view/manager/booking_requests.dart';
// import 'package:hall_mate/view/chat_screen.dart';
import 'package:hall_mate/view/manager/dashboard/Manager_dashboard_review_screen.dart';
import 'package:hall_mate/view/manager/dashboard/manager_dashboard_screen.dart';
import 'package:hall_mate/view/user/chat/chat_screen.dart';
import 'package:hall_mate/view/user/profile/profile_screen.dart';
// import 'package:hall_mate/view/profile_screen.dart';

// /// The frame of the manager app: the 5 screens + the bottom bar.
// /// Open it after a manager logs in:  Get.offAll(() => const ManagerNavBarWidget());
// class ManagerNavBarWidget extends StatelessWidget {
//    ManagerNavBarWidget({super.key, this.venueApproved = true});

//   /// false = the first tab shows the "under review" dashboard.
//   final bool venueApproved;
//   final ManagerNavController nav = Get.put(ManagerNavController());


//   static const List<(IconData, String)> _tabs = [
//     (Icons.grid_view_outlined, 'Dashboard'),
//     (Icons.inbox_outlined, 'Requests'),
//     (Icons.calendar_month_outlined, 'Calendar'),
//     (Icons.mode_comment_outlined, 'Chat'),
//     (Icons.person_outline, 'Profile'),
//   ];

//       final List<Widget> screens = [ 
//       ManagerDashboardScreen(),
//       ManagerDashboardReviewScreen(),
//       BookingRequestsScreen(),
//       ChatScreen(),
//       ProfileScreen(),
//     ];


//   @override
//   Widget build(BuildContext context) {
  
//     final colors = AppColors.of(context);

//     return Scaffold(
//       backgroundColor: colors.bgScreen,
//       body: Obx(() {
//         print('Manager creen ${screens[nav.currentIndex.value]}');
//         return screens[nav.currentIndex.value];
//       }),
//       bottomNavigationBar: Obx(
//         () => BottomNavigationBar(
//           currentIndex: nav.currentIndex.value,
//           onTap: nav.changeIndex,
//           type: BottomNavigationBarType.fixed, // all 5 labels always visible
//           elevation: 1,
//           backgroundColor: colors.bgSurface,
//           selectedItemColor: colors.primaryInk,
//           unselectedItemColor: colors.textMuted,
//           selectedLabelStyle:
//               AppTextStyles.bodySmall(color: colors.primaryInk),
//           unselectedLabelStyle:
//               AppTextStyles.bodySmall(color: colors.textMuted),
//           items: [
//             for (int i = 0; i < _tabs.length; i++)
//               BottomNavigationBarItem(
//                 icon: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: nav.currentIndex.value == i
//                         ? colors.primarySoft
//                         : Colors.transparent,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Icon(_tabs[i].$1),
//                 ),
//                 label: _tabs[i].$2,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }










// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hall_mate/constants/app_colors.dart';
// import 'package:hall_mate/constants/app_text_styles.dart';
// import 'package:hall_mate/controller/manager_nav_controller.dart';
// import 'package:hall_mate/view/availability_calendar_screen.dart';
// import 'package:hall_mate/view/booking_requests_screen.dart';
// import 'package:hall_mate/view/chat_screen.dart';
// import 'package:hall_mate/view/manager_dashboard_review_screen.dart';
// import 'package:hall_mate/view/manager_dashboard_screen.dart';
// import 'package:hall_mate/view/profile_screen.dart';

/// The frame of the manager app: the 5 screens + the bottom bar.
/// Open it after a manager logs in:  Get.offAll(() => const ManagerNavBarWidget());
class ManagerNavBarWidget extends StatelessWidget {
  const ManagerNavBarWidget({super.key, this.venueApproved = true});

  /// false = the first tab shows the "under review" dashboard.
  final bool venueApproved;

  static const List<(IconData, String)> _tabs = [
    (Icons.grid_view_outlined, 'Dashboard'),
    (Icons.inbox_outlined, 'Requests'),
    (Icons.calendar_month_outlined, 'Calendar'),
    (Icons.mode_comment_outlined, 'Chat'),
    (Icons.person_outline, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final ManagerNavController nav = Get.put(ManagerNavController());

    final List<Widget> screens = [
      venueApproved
          ? const ManagerDashboardScreen()
          : const ManagerDashboardReviewScreen(),
      const BookingRequestsScreen(),
      // const AvailabilityCalendarScreen(),
       const Center(
    child: Text('Calendar Screen'),
  ),

      ChatScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: colors.bgScreen,
      body: Obx(() => screens[nav.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: nav.currentIndex.value,
          onTap: nav.changeIndex,
          type: BottomNavigationBarType.fixed, // all 5 labels always visible
          elevation: 1,
          backgroundColor: colors.bgSurface,
          selectedItemColor: colors.primaryInk,
          unselectedItemColor: colors.textMuted,
          selectedLabelStyle:
              AppTextStyles.bodySmall(color: colors.primaryInk),
          unselectedLabelStyle:
              AppTextStyles.bodySmall(color: colors.textMuted),
          items: [
            for (int i = 0; i < _tabs.length; i++)
              BottomNavigationBarItem(
                icon: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  decoration: BoxDecoration(
                    color: nav.currentIndex.value == i
                        ? colors.primarySoft
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(_tabs[i].$1),
                ),
                label: _tabs[i].$2,
              ),
          ],
        ),
      ),
    );
  }
}