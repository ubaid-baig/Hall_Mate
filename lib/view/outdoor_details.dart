import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import '../controller/outdoor_details_controller.dart';
import 'package:hall_mate/widgets/venue_setup.dart';

class OutdoorDetailsScreen extends StatelessWidget {
  const OutdoorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final OutdoorDetailsController c = Get.put(OutdoorDetailsController());

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            const VenueTopBar(subtitle: 'Step 1 of 3 · Outdoor form'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: sh * 0.02),
                    const VenueStepProgress(current: 0),
                    SizedBox(height: sh * 0.02),
                    const VenueInfoBanner(
                      text: 'Outdoor managers fill in these fields. The basic '
                          'info and About sections stay the same for every '
                          'venue type.',
                    ),
                    SizedBox(height: sh * 0.018),

                    VenueCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const VenueCardHeader(
                            title: 'Outdoor details',
                            badge: 'Outdoor only',
                          ),
                          SizedBox(height: sh * 0.018),

                          const VenueLabel('Space type'),
                          VenueChipGroup(
                            options: const ['Lawn', 'Marquee', 'Farmhouse'],
                            selected: c.spaceType,
                          ),
                          SizedBox(height: sh * 0.02),

                          const VenueLabel('Lawn size'),
                          VenueField(
                            controller: c.lawnSizeController,
                            icon: Icons.map_outlined,
                            hint: 'e.g. 40,000 sq ft',
                          ),
                          SizedBox(height: sh * 0.012),

                          VenueSwitchRow(
                            title: 'Tents / marquee',
                            subtitle: 'Can be set up on request',
                            value: c.tentsMarquee,
                          ),
                          const VenueRowDivider(),
                          VenueSwitchRow(
                            title: 'Backup generator',
                            subtitle: 'Covers lights and sound',
                            value: c.backupGenerator,
                          ),
                          const VenueRowDivider(),
                          VenueSwitchRow(
                            title: 'Outdoor lighting',
                            subtitle: 'Fairy lights and floodlights',
                            value: c.outdoorLighting,
                          ),
                          SizedBox(height: sh * 0.014),

                          const VenueLabel('Rain backup plan'),
                          VenueField(
                            controller: c.rainPlanController,
                            hint: 'What happens if it rains?',
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: sh * 0.03),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: VenueBottomBar(
        text: 'Save & continue',
        onPressed: c.saveAndContinue,
      ),
    );
  }
}