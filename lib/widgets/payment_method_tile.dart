import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// One row of the payment methods list (card, JazzCash ...).
/// The selected row has a light green background, a green icon box
/// and a filled round radio button.
///
/// isFirst / isLast round the row's corners, so the green background
/// follows the rounded corners of the card around the list.
///
/// API: iconType, title and subtitle come from the payment methods list.
class PaymentMethodTile extends StatelessWidget {
  final String iconType; // 'card', 'wallet' or 'bank'
  final String title; // for example 'JazzCash'
  final String subtitle; // for example 'Mobile wallet'
  final bool isSelected; // true for the method the user picked
  final bool isFirst; // true for the first row of the list
  final bool isLast; // true for the last row (it has no line under it)

  const PaymentMethodTile({
    super.key,
    required this.iconType,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Pick the icon from the type name
    IconData icon = Icons.credit_card_outlined;
    if (iconType == 'wallet') {
      icon = Icons.account_balance_wallet_outlined;
    } else if (iconType == 'bank') {
      icon = Icons.receipt_long_outlined;
    }

    // Only the first row has round top corners, only the last has round bottom corners
    final BorderRadius rowRadius = BorderRadius.only(
      topLeft: isFirst ? const Radius.circular(17) : Radius.zero,
      topRight: isFirst ? const Radius.circular(17) : Radius.zero,
      bottomLeft: isLast ? const Radius.circular(17) : Radius.zero,
      bottomRight: isLast ? const Radius.circular(17) : Radius.zero,
    );

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colors.primaryTint : Colors.transparent,
            borderRadius: rowRadius,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : colors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected ? colors.textOnPrimary : colors.primaryInk,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleMedium()),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall(color: colors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // The round radio button
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : colors.bgSurface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? colors.primary : colors.borderStrong,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colors.textOnPrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
        if (!isLast) Divider(color: colors.border, height: 1),
      ],
    );
  }
}
