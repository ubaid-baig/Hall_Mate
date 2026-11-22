import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// One customer review, with the manager's reply under it (if there is one).
///
/// API: every value comes from one review in the reviews list.
class ReviewCard extends StatelessWidget {
  final String initials; // API: first letters of the reviewer's name
  final String name; // API: reviewer's name
  final String subtitle; // API: event type and month, e.g. 'Walima · Nov 2026'
  final int rating; // API: 1 to 5 stars
  final String text; // API: the review text
  final String? managerReply; // API: the manager's reply, or null

  const ReviewCard({
    super.key,
    required this.initials,
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.text,
    this.managerReply,
  });

  // One star. It is orange if the rating reaches this position, grey if not.
  Widget _star(AppColors colors, int position) {
    return Icon(
      Icons.star_rounded,
      size: 18,
      color: rating >= position ? colors.iconStar : colors.border,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.photoMarigold,
                child: Text(
                  initials,
                  style: AppTextStyles.labelSmall(color: colors.photoMarigoldInk),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.titleSmall()),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption(color: colors.textMuted),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _star(colors, 1),
                  _star(colors, 2),
                  _star(colors, 3),
                  _star(colors, 4),
                  _star(colors, 5),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(text, style: AppTextStyles.bodyMedium()),

          // The manager's reply box. It only shows when there is a reply.
          if (managerReply != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.bgSubtle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.reply, size: 18, color: colors.primaryInk),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Manager: $managerReply',
                      style: AppTextStyles.bodySmall(color: colors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
