import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// One row inside a Profile card: icon, title, optional small text,
/// and an arrow (or a Switch, or nothing for the danger row).
class ProfileRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle; // small grey text under the title
  final Widget? trailing; // for example a Switch. If null, an arrow shows.
  final bool isDanger; // true = red style, used for Log out
  final bool showDivider; // false for the last row of a card
  final VoidCallback? onTap; // Later: open that screen

  const ProfileRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.isDanger = false,
    this.showDivider = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDanger ? colors.dangerSoft : colors.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isDanger ? colors.danger : colors.primaryInk,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.titleMedium(
                          color: isDanger ? colors.danger : null,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: AppTextStyles.bodySmall(color: colors.textMuted),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!isDanger) ...[
                  const SizedBox(width: 8),
                  trailing ??
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: colors.textMuted,
                      ),
                ],
              ],
            ),
          ),
        ),
        if (showDivider) Divider(color: colors.border, height: 1),
      ],
    );
  }
}
