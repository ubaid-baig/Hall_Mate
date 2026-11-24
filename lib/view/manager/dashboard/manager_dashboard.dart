import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import '../../../controller/manager/dashboard/manager_dashboard.dart';

// Accent colour used for "Details", badges and offers.
// If your AppColors already has an accent/orange, replace this with it.
const Color _accent = Color(0xFFF5A83B);

class ManagerDashboardScreen extends StatelessWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final ManagerDashboardController controller =
        Get.put(ManagerDashboardController());

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: sw * 0.05,
            right: sw * 0.05,
            top: sh * 0.02,
            bottom: sh * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              SizedBox(height: sh * 0.025),

              const _EarningsCard(),
              SizedBox(height: sh * 0.015),

              const Row(
                children: [
                  Expanded(child: _StatCard(value: '3', label: 'New requests')),
                  SizedBox(width: 10),
                  Expanded(child: _StatCard(value: '2', label: 'Negotiating')),
                  SizedBox(width: 10),
                  Expanded(
                      child: _StatCard(value: '5', label: 'Upcoming events')),
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
                      style: AppTextStyles.titleSmall(color: colors.primaryInk),
                    ),
                  ),
                ],
              ),
              SizedBox(height: sh * 0.005),
              _RequestCard(
                initials: 'AR',
                name: 'Ali Raza',
                info: 'Sat 19 Dec · Dinner · 300 guests',
                status: 'Negotiating',
                statusColor: _accent,
                package: 'Gold · listed Rs 2,900',
                priceLabel: 'Offer ',
                price: 'Rs 2,500 / head',
                buttonText: 'Review offer',
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              _RequestCard(
                initials: 'HA',
                name: 'Hira Ahmed',
                info: 'Sun 27 Dec · Lunch · 180 guests',
                status: 'New',
                statusColor: colors.primaryInk,
                package: 'Silver · listed price',
                priceLabel: '',
                price: 'Rs 2,200 / head',
                buttonText: 'Accept',
                onPressed: () {},
              ),
            ],
          ),
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

TextStyle _sectionStyle() =>
    AppTextStyles.titleSmall().copyWith(fontSize: 17, fontWeight: FontWeight.w800);

// =====================================================================
// Header
// =====================================================================

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good evening, Imran',
                style: AppTextStyles.bodySmall(color: colors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                'Shaan Banquet Hall',
                style: AppTextStyles.h1().copyWith(fontSize: 24),
              ),
              const SizedBox(height: 3),
              Text(
                'Banquet · Gulshan-e-Iqbal',
                style: AppTextStyles.bodySmall(color: colors.textSecondary),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(radius: 3.5, backgroundColor: colors.primaryInk),
                    const SizedBox(width: 6),
                    Text(
                      'Live · visible in search',
                      style: AppTextStyles.bodySmall(color: colors.primaryInk),
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
                  color: colors.bgScreen,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.borderStrong),
                ),
                child: Icon(Icons.notifications_none,
                    size: 20, color: colors.textSecondary),
              ),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: _accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.bgSurface, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// Earnings card
// =====================================================================

class _EarningsCard extends StatelessWidget {
  const _EarningsCard();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final soft = colors.textOnPrimary.withOpacity(0.75);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Earnings in December',
                  style: AppTextStyles.bodySmall(color: soft)),
              GestureDetector(
                onTap: () {
                  // Get.to(EarningsScreen());
                },
                child: Text(
                  'Details',
                  style: AppTextStyles.titleSmall(color: _accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Rs 4,62,500',
            style: AppTextStyles.h1(color: colors.textOnPrimary)
                .copyWith(fontSize: 30),
          ),
          const SizedBox(height: 8),
          Text(
            'Advances Rs 3,75,000 · Balances Rs 87,500',
            style: AppTextStyles.bodySmall(color: soft),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Small cards
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
// Request card
// =====================================================================

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.initials,
    required this.name,
    required this.info,
    required this.status,
    required this.statusColor,
    required this.package,
    required this.priceLabel,
    required this.price,
    required this.buttonText,
    required this.onPressed,
  });

  final String initials;
  final String name;
  final String info;
  final String status;
  final Color statusColor;
  final String package;
  final String priceLabel;
  final String price;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final sh = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.bgScreen,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  initials,
                  style: AppTextStyles.titleSmall(color: _accent)
                      .copyWith(fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.titleSmall()),
                    const SizedBox(height: 2),
                    Text(
                      info,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall(
                          color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: AppTextStyles.bodySmall(color: statusColor)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colors.bgSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(package,
                    style:
                        AppTextStyles.bodySmall(color: colors.textSecondary)),
                Text.rich(
                  TextSpan(
                    style:
                        AppTextStyles.bodySmall(color: colors.textSecondary),
                    children: [
                      if (priceLabel.isNotEmpty) TextSpan(text: priceLabel),
                      TextSpan(
                        text: price,
                        style: const TextStyle(
                            color: _accent, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: (sh * 0.06).clamp(44.0, 54.0),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.textOnPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                buttonText,
                style: AppTextStyles.labelButton(color: colors.textOnPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}