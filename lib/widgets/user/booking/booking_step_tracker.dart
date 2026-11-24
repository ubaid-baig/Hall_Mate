import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// The 5-step line: Requested, Negotiating, Accepted, Confirmed, Completed.
///  - steps before the current one: green circle with a check
///  - the current step: orange circle
///  - steps after it: empty circle
///
/// API: only currentIndex changes (0 to 4), work it out from the booking status.
class BookingStepTracker extends StatelessWidget {
  final List<String> steps; // the 5 step names
  final int currentIndex; // which step the booking is on

  const BookingStepTracker({
    super.key,
    required this.steps,
    required this.currentIndex,
  });

  // Builds ONE step: the circle with a line on each side, and the name below.
  Widget _buildStep(AppColors colors, int index) {
    final bool isDone = index < currentIndex;
    final bool isCurrent = index == currentIndex;
    final bool isReached = index <= currentIndex;

    // Circle look: empty by default (a step that has not come yet)
    Color circleColor = colors.bgSurface;
    Color circleBorder = colors.borderStrong;
    Widget? circleIcon;
    if (isDone) {
      circleColor = colors.primary;
      circleBorder = colors.primary;
      circleIcon = Icon(Icons.check, size: 14, color: colors.textOnPrimary);
    } else if (isCurrent) {
      circleColor = colors.accent;
      circleBorder = colors.accent;
      circleIcon = Icon(Icons.swap_horiz, size: 14, color: colors.textOnAccent);
    }

    // The line on the left joins the step before. It is green if this step is reached.
    // The line on the right joins the next step. It is green if this step is done.
    // The first step has no left line and the last step has no right line.
    Color leftLine = isReached ? colors.primary : colors.border;
    Color rightLine = isDone ? colors.primary : colors.border;
    if (index == 0) {
      leftLine = Colors.transparent;
    }
    if (index == steps.length - 1) {
      rightLine = Colors.transparent;
    }

    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Container(height: 2, color: leftLine)),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: circleBorder, width: 2),
                ),
                child: circleIcon,
              ),
              Expanded(child: Container(height: 2, color: rightLine)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            steps[index],
            textAlign: TextAlign.center,
            style: AppTextStyles.labelTiny(
              color: isReached ? null : colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStep(colors, 0),
          _buildStep(colors, 1),
          _buildStep(colors, 2),
          _buildStep(colors, 3),
          _buildStep(colors, 4),
        ],
      ),
    );
  }
}
