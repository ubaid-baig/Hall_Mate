import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import '../../../controller/manager/dashboard/manager_dashboard.dart';

// Amber colour used for the "under review" warning.
// If your AppColors already has a warning colour, replace this with it.
const Color _amber = Color(0xFFE0A24A);

class ManagerDashboardReviewScreen extends StatelessWidget {
  const ManagerDashboardReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final ManagerDashboardController controller =
        Get.put(ManagerDashboardController());

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Green header (full width) ----------
            const _Header(),

            // ---------- Everything below the header ----------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: sh * 0.02),
                  const _EarningsCard(),
                  SizedBox(height: sh * 0.02),
                  const _ReviewBanner(),
                  SizedBox(height: sh * 0.02),

                  const Row(
                    children: [
                      Expanded(
                          child: _StatCard(value: '0', label: 'New requests')),
                      SizedBox(width: 10),
                      Expanded(
                          child: _StatCard(value: '0', label: 'Negotiating')),
                      SizedBox(width: 10),
                      Expanded(
                          child:
                              _StatCard(value: '0', label: 'Upcoming events')),
                    ],
                  ),
                  SizedBox(height: sh * 0.03),

                  Text('Manage venue', style: _sectionStyle()),
                  SizedBox(height: sh * 0.015),
                  Row(
                    children: [
                      Expanded(
                        child: _ManageCard(
                          icon: Icons.edit_outlined,
                          title: 'Venue details',
                          subtitle: 'Banquet form',
                          onTap: () {
                            // Get.to(VenueDetailsScreen());
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ManageCard(
                          icon: Icons.image_outlined,
                          title: 'Photos & videos',
                          subtitle: '15 photos · 1 video',
                          onTap: () {
                            // Get.to(PhotosScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ManageCard(
                          icon: Icons.sell_outlined,
                          title: 'Packages',
                          subtitle: 'Silver · Gold',
                          onTap: () {
                            // Get.to(PackagesScreen());
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ManageCard(
                          icon: Icons.calendar_month_outlined,
                          title: 'Calendar',
                          subtitle: 'Slots & peak prices',
                          onTap: () {
                            // Get.to(CalendarScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sh * 0.03),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('New requests', style: _sectionStyle()),
                      TextButton(
                        onPressed: () {
                          // Get.to(RequestsScreen());
                        },
                        child: Text(
                          'See all',
                          style: AppTextStyles.titleSmall(
                              color: colors.primaryInk),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sh * 0.005),
                  const _EmptyRequestsBox(),
                  SizedBox(height: sh * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: colors.bgScreen,
            border: Border(top: BorderSide(color: colors.borderStrong)),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentTab.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            backgroundColor: colors.bgScreen,
            elevation: 0,
            selectedItemColor: colors.primaryInk,
            unselectedItemColor: colors.textMuted,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_outlined),
                activeIcon: Icon(Icons.grid_view_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inbox_outlined),
                label: 'Requests',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle _sectionStyle() => AppTextStyles.titleSmall()
    .copyWith(fontSize: 17, fontWeight: FontWeight.w800);

// =====================================================================
// Header (green area at the top)
// =====================================================================

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final sw = MediaQuery.of(context).size.width;
    final topInset = MediaQuery.of(context).padding.top; // status bar height

    return Container(
      width: double.infinity,
      color: colors.primary,
      padding: EdgeInsets.only(
        left: sw * 0.05,
        right: sw * 0.05,
        top: topInset + 14,
        bottom: 18,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good evening, Imran',
                  style: AppTextStyles.bodySmall(
                      color: colors.textOnPrimary.withOpacity(0.75)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Shaan Banquet Hall',
                  style: AppTextStyles.h1(color: colors.textOnPrimary)
                      .copyWith(fontSize: 24),
                ),
                const SizedBox(height: 3),
                Text(
                  'Banquet · Gulshan-e-Iqbal',
                  style: AppTextStyles.bodySmall(
                      color: colors.textOnPrimary.withOpacity(0.75)),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                          radius: 3.5, backgroundColor: _amber),
                      const SizedBox(width: 6),
                      Text(
                        'Under review · hidden from search',
                        style: AppTextStyles.bodySmall(color: _amber),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Get.to(NotificationsScreen());
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.textOnPrimary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.notifications_none,
                      size: 20, color: colors.textOnPrimary),
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: _amber,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.primary, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Earnings card (Rs 0 because venue is not live yet)
// =====================================================================

class _EarningsCard extends StatelessWidget {
  const _EarningsCard();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgScreen,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Earnings in December',
                  style: AppTextStyles.bodySmall(color: colors.textSecondary)),
              GestureDetector(
                onTap: () {
                  // Get.to(EarningsScreen());
                },
                child: Text(
                  'Details',
                  style: AppTextStyles.titleSmall(color: colors.primaryInk),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Rs 0', style: AppTextStyles.h1().copyWith(fontSize: 30)),
          const SizedBox(height: 6),
          Text(
            'Earnings start once your venue is live',
            style: AppTextStyles.bodySmall(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// "Your venue is under review" banner
// =====================================================================

class _ReviewBanner extends StatelessWidget {
  const _ReviewBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _amber.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _amber.withOpacity(0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.access_time, size: 22, color: _amber),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your venue is under review',
                  style: AppTextStyles.titleSmall(color: _amber),
                ),
                const SizedBox(height: 4),
                Text(
                  'Customers can\'t see Shaan Banquet Hall yet. Finish your '
                  'photos and packages while the admin checks your details.',
                  style: AppTextStyles.bodySmall(color: _amber)
                      .copyWith(height: 1.4),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // Get.to(SetupScreen());
                  },
                  child: Text(
                    'Finish setup →',
                    style: AppTextStyles.titleSmall(color: _amber),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Stat card and Manage card
// =====================================================================

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bgScreen,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.borderStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTextStyles.h1().copyWith(fontSize: 22)),
          const SizedBox(height: 2),
          Text(label,
              style: AppTextStyles.bodySmall(color: colors.textSecondary)),
        ],
      ),
    );
  }
}

class _ManageCard extends StatelessWidget {
  const _ManageCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.bgScreen,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderStrong),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: colors.primaryInk),
            ),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.titleSmall()),
            const SizedBox(height: 2),
            Text(subtitle,
                style: AppTextStyles.bodySmall(color: colors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// Empty "New requests" box (dashed border)
// =====================================================================

class _EmptyRequestsBox extends StatelessWidget {
  const _EmptyRequestsBox();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return CustomPaint(
      painter: _DashedBorderPainter(color: colors.borderStrong, radius: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Text(
          'Booking requests will show up here once your venue is approved '
          'and live in search.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall(color: colors.textSecondary)
              .copyWith(height: 1.4),
        ),
      ),
    );
  }
}

/// Flutter has no built-in dashed border, so we draw one ourselves.
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(radius),
      ));

    const dashLength = 6.0;
    const gapLength = 4.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashLength),
          paint,
        );
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}