  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/manager/booking_requests_controller.dart';
import 'package:hall_mate/widgets/manager/manager_widget.dart';
import 'package:hall_mate/widgets/manager/venue_setup.dart';

class BookingRequestsScreen extends StatelessWidget {
  const BookingRequestsScreen({super.key});

  static const List<(RequestStatus, String)> _tabs = [
    (RequestStatus.newRequest, 'New'),
    (RequestStatus.negotiating, 'Negotiating'),
    (RequestStatus.accepted, 'Accepted'),
    (RequestStatus.archived, 'Archived'),
  ];

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final BookingRequestsController c = Get.put(BookingRequestsController());

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            const ManagerTabHeader(
              title: 'Booking requests',
              subtitle: "Offers expire if you don't reply within 24 hours.",
            ),
            SizedBox(height: sh * 0.018),

            // ---------- Filter chips (scroll sideways) ----------
            Obx(
              () => SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                  children: [
                    for (final t in _tabs)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ManagerFilterChip(
                          label: t.$2,
                          selected: c.filter.value == t.$1,
                          count: c.count(t.$1) > 0 ? c.count(t.$1) : null,
                          onTap: () => c.filter.value = t.$1,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: sh * 0.012),

            // ---------- Request cards ----------
            Expanded(
              child: Obx(() {
                final list = c.visible;

                if (list.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: DashedBox(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          child: Text(
                            'No requests here yet.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodySmall(
                                color: colors.textSecondary),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(sw * 0.05, 0, sw * 0.05, sh * 0.03),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) =>
                      _RequestCard(request: list[i], controller: c),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// One booking request
// =====================================================================

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request, required this.controller});

  final BookingRequest request;
  final BookingRequestsController controller;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final avatarColors = [
      colors.primaryInk,
      const Color(0xFF5B9BD5),
      venueAmber,
    ];
    final avatarColor = avatarColors[request.initials.codeUnitAt(0) % 3];

    return VenueCard(
      child: Obx(() {
        final status = request.status.value;
        final open = status == RequestStatus.newRequest ||
            status == RequestStatus.negotiating;

        late final String badgeText;
        late final Color badgeColor;
        switch (status) {
          case RequestStatus.newRequest:
            badgeText = 'New';
            badgeColor = colors.primaryInk;
          case RequestStatus.negotiating:
            badgeText = 'Negotiating';
            badgeColor = venueAmber;
          case RequestStatus.accepted:
            badgeText = 'Accepted';
            badgeColor = colors.primaryInk;
          case RequestStatus.archived:
            badgeText = 'Declined';
            badgeColor = colors.textSecondary;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ManagerAvatar(initials: request.initials, color: avatarColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.name, style: AppTextStyles.titleSmall()),
                      const SizedBox(height: 2),
                      Text(
                        request.info,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            AppTextStyles.bodySmall(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
                ManagerBadge(text: badgeText, color: badgeColor),
              ],
            ),
            const SizedBox(height: 12),

            // ---------- Package line + total + time left ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.bgSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.packageLine,
                    style: AppTextStyles.bodySmall(color: colors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rs ${formatRs(request.total)} total',
                        style: AppTextStyles.titleSmall(),
                      ),
                      if (open && request.hoursLeft > 0)
                        Row(
                          children: [
                            const Icon(Icons.schedule,
                                size: 14, color: venueAmber),
                            const SizedBox(width: 4),
                            Text(
                              '${request.hoursLeft} h left',
                              style: AppTextStyles.bodySmall(color: venueAmber),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // ---------- Buttons (only for open requests) ----------
            if (open) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ManagerButton(
                      text: 'Decline',
                      height: 40,
                      onPressed: () => controller.decline(request),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ManagerButton(
                      text: 'Counter',
                      height: 40,
                      type: ManagerButtonType.outlinedPrimary,
                      onPressed: () => controller.counter(request),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ManagerButton(
                      text: 'Accept',
                      height: 40,
                      type: ManagerButtonType.filled,
                      onPressed: () => controller.accept(request),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      }),
    );
  }
}