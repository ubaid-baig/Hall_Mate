import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/manager/dashboard_controller.dart';
import 'package:hall_mate/controller/manager/requests_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/manager/dashboard/manager_notifications_screen.dart';
import 'package:hall_mate/view/manager/venue/media_manager_screen.dart';
import 'package:hall_mate/widgets/manager/manage_card.dart';
import 'package:hall_mate/widgets/manager/request_card.dart';
import 'package:hall_mate/widgets/manager/stat_card.dart';

// Dashboard tab: the manager's home.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final DashboardController controller = Get.put(DashboardController());
    // The request cards use the same texts as the Requests tab
    final RequestsController requestsController = Get.put(RequestsController());

    return Scaffold(
      backgroundColor: colors.bgScreen,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: sw * 0.05,
            right: sw * 0.05,
            top: sh * 0.02,
            bottom: sh * 0.03,
          ),
          // Obx: every number follows the shared bookings list
          child: Obx(() {
            final VenueModel venue = controller.venue();
            final List<BookingModel> waiting = controller.waitingForMe();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header: greeting, venue, live status (left), bell (right) ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.greeting(),
                            style: AppTextStyles.bodyMedium(
                              color: colors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(venue.name, style: AppTextStyles.h2()),
                          const SizedBox(height: 2),
                          Text(
                            controller.venueLine(),
                            style: AppTextStyles.bodySmall(
                              color: colors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Green = customers can find it, grey = hidden
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: venue.isLive
                                  ? colors.successSoft
                                  : colors.bgNeutral,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              venue.isLive
                                  ? 'Live · visible in search'
                                  : 'Hidden · setup not finished',
                              style: AppTextStyles.labelSmall(
                                color: venue.isLive
                                    ? colors.successInk
                                    : colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // The bell, with an orange dot while something is unread
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const ManagerNotificationsScreen());
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: colors.bgSurface,
                              border: Border.all(color: colors.border),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.notifications_none_rounded,
                              size: 22,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                        if (controller.hasNewNotification())
                          Positioned(
                            top: 10,
                            right: 11,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: colors.accent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colors.bgSurface,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: sh * 0.022),

                // ── Setup banner (only while the venue is hidden) ──
                if (!venue.isLive) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.accentSoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Finish your venue setup',
                          style: AppTextStyles.titleMedium(
                            color: colors.accentStrongInk,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Customers can\'t see your venue yet. Add the rent, '
                          'the area and at least one photo.',
                          style: AppTextStyles.bodySmall(
                            color: colors.accentInk,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.openTab(2);
                          },
                          child: Text(
                            'Finish setup →',
                            style: AppTextStyles.titleSmall(
                              color: colors.accentStrongInk,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sh * 0.018),
                ],

                // ── Green earnings card ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Advances received',
                        style: AppTextStyles.bodyMedium(
                          color: colors.textOnPrimaryMute,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.advancesText(),
                        style: AppTextStyles.h1(color: colors.textOnPrimary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.collectText(),
                        style: AppTextStyles.bodySmall(
                          color: colors.textOnPrimaryMute,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sh * 0.015),

                // ── 3 small numbers ──
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        value: '${controller.newRequests()}',
                        label: 'New requests',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        value: '${controller.negotiating()}',
                        label: 'Negotiating',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        value: '${controller.upcoming()}',
                        label: 'Upcoming',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sh * 0.028),

                // ── Manage venue ──
                Text('Manage venue', style: AppTextStyles.h3()),
                SizedBox(height: sh * 0.014),
                Row(
                  children: [
                    Expanded(
                      child: ManageCard(
                        icon: Icons.edit_outlined,
                        title: 'Venue details',
                        subtitle: 'Rent ${AppFormat.rupees(venue.rent)}',
                        // Opens the My venue tab
                        onTap: () {
                          controller.openTab(2);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ManageCard(
                        icon: Icons.image_outlined,
                        title: 'Photos & videos',
                        subtitle: venue.mediaCountText(),
                        onTap: () {
                          Get.to(() => const MediaManagerScreen(isSetup: false));
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sh * 0.028),

                // ── Requests that wait for my answer ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Needs your reply', style: AppTextStyles.h3()),
                    TextButton(
                      // Opens the Requests tab
                      onPressed: () {
                        controller.openTab(1);
                      },
                      child: Text(
                        'See all',
                        style: AppTextStyles.titleSmall(color: colors.primaryInk),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (waiting.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colors.bgSurface,
                      border: Border.all(color: colors.borderDashed),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'No requests are waiting for you.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium(color: colors.textMuted),
                    ),
                  ),
                Column(
                  children: waiting.map((booking) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RequestCard(
                        initials: AppFormat.initials(booking.customerName),
                        customerName: booking.customerName,
                        details: requestsController.detailsText(booking),
                        status: booking.status,
                        infoText: requestsController.infoText(booking),
                        buttonText: requestsController.buttonText(booking),
                        isButtonFilled: requestsController.isButtonFilled(booking),
                        onPressed: () {
                          requestsController.openRequest(booking);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
