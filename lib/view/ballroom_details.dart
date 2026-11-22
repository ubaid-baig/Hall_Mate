import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import '../controller/ballroom_details_controller.dart';
import 'package:hall_mate/widgets/venue_setup.dart';

class BallroomDetailsScreen extends StatelessWidget {
  const BallroomDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final BallroomDetailsController c = Get.put(BallroomDetailsController());

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            const VenueTopBar(subtitle: 'Step 1 of 3 · Ballroom form'),
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
                      text: 'Ballroom managers fill in these fields. The basic '
                          'info and About sections stay the same for every '
                          'venue type.',
                    ),
                    SizedBox(height: sh * 0.018),

                    VenueCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const VenueCardHeader(
                            title: 'Ballroom details',
                            badge: 'Ballroom only',
                          ),
                          SizedBox(height: sh * 0.018),

                          const VenueLabel('Stage'),
                          VenueChipGroup(
                            options: const [
                              'Fixed stage',
                              'Movable stage',
                              'No stage',
                            ],
                            selected: c.stageType,
                          ),
                          SizedBox(height: sh * 0.02),

                          const VenueLabel('Stage size'),
                          VenueField(
                            controller: c.stageSizeController,
                            icon: Icons.grid_view,
                            hint: 'e.g. 24 x 12 ft',
                          ),
                          SizedBox(height: sh * 0.012),

                          VenueSwitchRow(
                            title: 'Dance floor',
                            subtitle: 'Wooden floor in front of the stage',
                            value: c.danceFloor,
                          ),
                          const VenueRowDivider(),
                          VenueSwitchRow(
                            title: 'Sound system',
                            subtitle: 'Speakers and wireless mics',
                            value: c.soundSystem,
                          ),
                          const VenueRowDivider(),
                          VenueSwitchRow(
                            title: 'Stage lighting',
                            subtitle: 'Chandeliers, spotlights and uplights',
                            value: c.stageLighting,
                          ),
                          SizedBox(height: sh * 0.014),

                          const VenueLabel('Seating layout'),
                          VenueChipGroup(
                            options: const [
                              'Round tables',
                              'Theatre',
                              'Banquet rows',
                              'Mixed',
                            ],
                            selected: c.seatingLayout,
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