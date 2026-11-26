import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/widgets/manager/venue_setup.dart';

// Screens import only this file. It also hands them VenueCard,
// VenueInfoBanner, venueAmber, ... from venue_setup_widgets.dart.
export 'package:hall_mate/widgets/manager/venue_setup.dart';

/// 462500 -> "4,62,500" (lakh grouping used in Pakistan).
String formatRs(int n) {
  final negative = n < 0;
  String s = n.abs().toString();
  if (s.length > 3) {
    final last3 = s.substring(s.length - 3);
    String rest = s.substring(0, s.length - 3);
    final groups = <String>[];
    while (rest.length > 2) {
      groups.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) groups.insert(0, rest);
    s = '${groups.join(',')},$last3';
  }
  return negative ? '-$s' : s;
}

// =====================================================================
// Top bar for pushed screens: back arrow + title + subtitle (+ button)
// =====================================================================

class ManagerTopBar extends StatelessWidget {
  const ManagerTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      color: colors.bgScreen,
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.titleSmall().copyWith(fontSize: 18)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style:
                        AppTextStyles.bodySmall(color: colors.textSecondary)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// =====================================================================
// Big header for tab screens (Calendar, Booking requests): no back arrow
// =====================================================================

class ManagerTabHeader extends StatelessWidget {
  const ManagerTabHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final sw = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.fromLTRB(sw * 0.05, 16, sw * 0.05, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h1().copyWith(fontSize: 24)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style:
                        AppTextStyles.bodySmall(color: colors.textSecondary)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Small square button (the "+" in the headers).
class ManagerIconButton extends StatelessWidget {
  const ManagerIconButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: colors.bgScreen,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.borderStrong),
        ),
        child: Icon(icon, size: 20, color: colors.textPrimary),
      ),
    );
  }
}

// =====================================================================
// Badge, avatar, stars
// =====================================================================

/// Small rounded tag such as "New", "Popular", "Confirmed".
class ManagerBadge extends StatelessWidget {
  const ManagerBadge({
    super.key,
    required this.text,
    required this.color,
    this.small = false,
  });

  final String text;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 7 : 10,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall(color: color).copyWith(
          fontSize: small ? 10.0 : null,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Round avatar with initials.
class ManagerAvatar extends StatelessWidget {
  const ManagerAvatar({super.key, required this.initials, required this.color});

  final String initials;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: AppTextStyles.titleSmall(color: color).copyWith(fontSize: 12),
      ),
    );
  }
}

/// Five stars. Supports half stars (4.5).
class ManagerStars extends StatelessWidget {
  const ManagerStars({super.key, required this.rating, this.size = 14});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 1; i <= 5; i++)
          Icon(
            rating >= i
                ? Icons.star_rounded
                : (rating >= i - 0.5
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded),
            size: size,
            color: rating >= i - 0.5 ? venueAmber : colors.borderStrong,
          ),
      ],
    );
  }
}

// =====================================================================
// Buttons and filter chips
// =====================================================================

enum ManagerButtonType { filled, outlined, outlinedPrimary, danger }

class ManagerButton extends StatelessWidget {
  const ManagerButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.type = ManagerButtonType.outlined,
    this.height = 44,
  });

  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final ManagerButtonType type;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final Color fg = switch (type) {
      ManagerButtonType.filled => colors.textOnPrimary,
      ManagerButtonType.outlined => colors.textPrimary,
      ManagerButtonType.outlinedPrimary => colors.primaryInk,
      ManagerButtonType.danger => colors.danger,
    };
    final Color border = switch (type) {
      ManagerButtonType.filled => colors.primary,
      ManagerButtonType.outlined => colors.borderStrong,
      ManagerButtonType.outlinedPrimary => colors.primaryBorder,
      ManagerButtonType.danger => colors.danger,
    };

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelButton(color: fg).copyWith(fontSize: 13.5),
          ),
        ),
      ],
    );

    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
    const padding = EdgeInsets.symmetric(horizontal: 12);

    return SizedBox(
      height: height,
      child: type == ManagerButtonType.filled
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.textOnPrimary,
                elevation: 0,
                padding: padding,
                shape: shape,
              ),
              child: content,
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: border),
                padding: padding,
                shape: shape,
              ),
              child: content,
            ),
    );
  }
}

/// Pill used as a filter tab ("New 3", "Negotiating 2", ...).
class ManagerFilterChip extends StatelessWidget {
  const ManagerFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.count,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? colors.primary : colors.borderStrong,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium(
                color: selected ? colors.textOnPrimary : colors.textPrimary,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: selected ? venueAmber : colors.borderStrong,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.black87 : colors.textSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// Dashed border box (Flutter has no built-in dashed border)
// =====================================================================

class DashedBox extends StatelessWidget {
  const DashedBox({super.key, required this.child, this.radius = 16});

  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedPainter(
        color: AppColors.of(context).borderStrong,
        radius: radius,
      ),
      child: child,
    );
  }
}

class _DashedPainter extends CustomPainter {
  _DashedPainter({required this.color, required this.radius});

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
  bool shouldRepaint(covariant _DashedPainter old) =>
      old.color != color || old.radius != radius;
}