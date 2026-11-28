import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

// Small pieces of the manager's Venue details form.

// A white card with a title and, if given, a small green badge.
class FormSection extends StatelessWidget {
  final String title;
  final String? badge; // for example 'Banquet only'
  final Widget child;

  const FormSection({
    super.key,
    required this.title,
    required this.child,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.h3()),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge!,
                    style: AppTextStyles.labelSmall(color: colors.primaryInk),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// A label above a text field, like the fields on Login and Sign up.
class LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool isNumber; // true = number keyboard
  final int maxLines;
  final void Function(String)? onChanged;

  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.isNumber = false,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.titleSmall()),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: isNumber
                ? TextInputType.number
                : (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
            maxLines: maxLines,
            onChanged: onChanged,
            style: AppTextStyles.bodyLarge(),
            decoration: InputDecoration(
              filled: true,
              fillColor: colors.bgScreen,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              hintText: hint,
              hintStyle: AppTextStyles.bodyLarge(color: colors.textMuted),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.borderStrong),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.primaryBorder),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// A row with a title, a small text and a Switch on the right.
class SwitchRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final void Function(bool) onChanged;

  const SwitchRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleSmall()),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall(color: colors.textMuted),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
