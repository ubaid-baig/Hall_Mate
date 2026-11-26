import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/packages_controller.dart';
import 'package:hall_mate/widgets/manager/manager_widget.dart';
import 'package:hall_mate/widgets/manager/venue_setup.dart';

class PackagesPricingScreen extends StatelessWidget {
  const PackagesPricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final PackagesController c = Get.put(PackagesController());

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            ManagerTopBar(
              title: 'Packages & pricing',
              subtitle: 'Shaan Banquet Hall',
              trailing: ManagerIconButton(icon: Icons.add, onTap: c.addPackage),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(sw * 0.05, sh * 0.02, sw * 0.05, sh * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VenueInfoBanner(
                      text: 'Customers see three per-head prices. They can '
                          'still send you their own offer.',
                    ),
                    SizedBox(height: sh * 0.018),

                    // ---------- Package cards ----------
                    Obx(
                      () => Column(
                        children: [
                          for (final p in c.packages)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _PackageCard(package: p, controller: c),
                            ),
                        ],
                      ),
                    ),

                    // ---------- Add package ----------
                    GestureDetector(
                      onTap: c.addPackage,
                      child: DashedBox(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: 18, color: colors.primaryInk),
                              const SizedBox(width: 6),
                              Text('Add package',
                                  style: AppTextStyles.titleSmall(
                                      color: colors.primaryInk)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: sh * 0.02),

                    // ---------- Peak-day pricing ----------
                    VenueCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Peak-day pricing',
                                        style: venueCardTitle()),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Fridays, Saturdays and Sundays',
                                      style: AppTextStyles.bodySmall(
                                          color: colors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              Obx(
                                () => Switch(
                                  value: c.peakEnabled.value,
                                  onChanged: (v) => c.peakEnabled.value = v,
                                  activeColor: Colors.white,
                                  activeTrackColor: colors.primary,
                                  inactiveTrackColor: colors.borderStrong,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const VenueRowDivider(),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Extra on peak days',
                                  style: AppTextStyles.bodyMedium(
                                      color: colors.textSecondary)),
                              Obx(
                                () => Text(
                                  '+${c.peakPercent.value}%',
                                  style: AppTextStyles.titleSmall(
                                      color: colors.primaryInk),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// One package (Silver / Gold / ...)
// =====================================================================

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package, required this.controller});

  final PackageModel package;
  final PackagesController controller;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return VenueCard(
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(package.name, style: venueCardTitle()),
                          if (package.popular) ...[
                            const SizedBox(width: 8),
                            const ManagerBadge(
                                text: 'Popular', color: venueAmber, small: true),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Min. ${package.minGuests} guests · visible to customers',
                        style:
                            AppTextStyles.bodySmall(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: package.visible.value,
                  onChanged: (v) => package.visible.value = v,
                  activeColor: Colors.white,
                  activeTrackColor: colors.primary,
                  inactiveTrackColor: colors.borderStrong,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Rs ${formatRs(package.price.value)}',
                    style: AppTextStyles.h1(color: colors.primaryInk)
                        .copyWith(fontSize: 22),
                  ),
                  TextSpan(
                    text: ' / head',
                    style: AppTextStyles.bodySmall(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            for (final f in package.features)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(Icons.check, size: 16, color: colors.primaryInk),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(f, style: AppTextStyles.bodyMedium()),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ManagerButton(
                    text: 'Edit',
                    icon: Icons.edit_outlined,
                    onPressed: () => controller.editPrice(package),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ManagerButton(
                    text: 'Duplicate',
                    icon: Icons.copy_outlined,
                    onPressed: () => controller.duplicate(package),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}