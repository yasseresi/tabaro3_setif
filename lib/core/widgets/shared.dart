import 'package:flutter/material.dart';

import '../resources/app_colors.dart';

/// White rounded card with a navy header bar + optional trailing action.
class AppPanel extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final EdgeInsetsDirectional padding;
  const AppPanel({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.padding = const EdgeInsetsDirectional.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadiusDirectional.vertical(
                top: Radius.circular(13),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.primaryForeground,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
          Expanded(
            child: Padding(padding: padding, child: child),
          ),
        ],
      ),
    );
  }
}

/// Colored pill badge for eligibility statuses ('due'|'soon'|'wait'|'none').
class StatusBadge extends StatelessWidget {
  final String status;
  final String label;
  const StatusBadge({super.key, required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.statusColor(status);
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: status == 'none'
            ? AppColors.muted
            : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: status == 'none' ? AppColors.textSecondary : color,
        ),
      ),
    );
  }
}

/// Forces LTR for blood groups (`A+`) and phones (`0551...`) so signs never
/// flip at the wrong side in Arabic RTL mode.
class LtrText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool bold;
  const LtrText(this.text, {super.key, this.style, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        text,
        style: bold
            ? (style ?? const TextStyle()).copyWith(fontWeight: FontWeight.w700)
            : style,
      ),
    );
  }
}

/// Circular blood-group chip used in lists & alerts.
class BloodGroupCircle extends StatelessWidget {
  final String group;
  final double size;
  const BloodGroupCircle({super.key, required this.group, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.bloodSoft,
        border: Border.all(color: AppColors.blood.withValues(alpha: 0.5)),
      ),
      child: LtrText(
        group,
        bold: true,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: size * 0.32,
          fontWeight: FontWeight.w800,
          color: AppColors.blood,
        ),
      ),
    );
  }
}
