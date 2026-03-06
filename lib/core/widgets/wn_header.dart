import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Reusable professional page‑header widget used across dashboards.
class WnPageHeader extends StatelessWidget {
  final String greeting;
  final String name;
  final String subtitle;
  final String avatarInitials;
  final List<Widget>? actions;
  final Widget? bottom;

  const WnPageHeader({
    super.key,
    required this.greeting,
    required this.name,
    required this.subtitle,
    required this.avatarInitials,
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Avatar(initials: avatarInitials),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(greeting,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textOnDarkMuted,
                                fontWeight: FontWeight.w400)),
                        Text(name,
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                color: AppColors.textOnDark,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  if (actions != null) ...actions!,
                ],
              ),
              const SizedBox(height: 14),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textOnDarkMuted,
                    fontWeight: FontWeight.w400),
              ),
              if (bottom != null) ...[
                const SizedBox(height: 14),
                bottom!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: Colors.white.withOpacity(0.2), width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// A slim inline status badge.
class WnBadge extends StatelessWidget {
  final String label;
  final Color fg;
  final Color bg;
  final double fontSize;

  const WnBadge({
    super.key,
    required this.label,
    required this.fg,
    required this.bg,
    this.fontSize = 11,
  });

  factory WnBadge.present() => const WnBadge(
      label: 'Present',
      fg: AppColors.presentFg,
      bg: AppColors.presentBg);

  factory WnBadge.late() => const WnBadge(
      label: 'Late',
      fg: AppColors.lateFg,
      bg: AppColors.lateBg);

  factory WnBadge.absent() => const WnBadge(
      label: 'Absent',
      fg: AppColors.absentFg,
      bg: AppColors.absentBg);

  factory WnBadge.onLeave() => const WnBadge(
      label: 'On Leave',
      fg: AppColors.onLeaveFg,
      bg: AppColors.onLeaveBg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: fg)),
    );
  }
}

/// Clean section heading used inside scrollable pages.
class WnSectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const WnSectionTitle({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Metric tile used in summary rows.
class WnMetricTile extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const WnMetricTile({
    super.key,
    required this.value,
    required this.label,
    this.valueColor,
    this.icon,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: AppColors.divider, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 18,
                  color: iconColor ?? AppColors.textSecondary),
              const SizedBox(height: 10),
            ],
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}