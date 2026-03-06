import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? change;
  final bool changePositive;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.change,
    this.changePositive = true,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 17),
                ),
                if (change != null)
                  _ChangePill(
                      text: change!, positive: changePositive),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 2),
            Text(title,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _ChangePill extends StatelessWidget {
  final String text;
  final bool positive;
  const _ChangePill({required this.text, required this.positive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: positive
            ? AppColors.successLight
            : AppColors.errorLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            positive
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
            size: 10,
            color: positive
                ? AppColors.success
                : AppColors.error,
          ),
          const SizedBox(width: 2),
          Text(text,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: positive
                      ? AppColors.success
                      : AppColors.error)),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import '../constants/app_colors.dart';

// class StatCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final String? subtitle;
//   final IconData icon;
//   final Color color;
//   final Color? bgColor;
//   final VoidCallback? onTap;

//   const StatCard({
//     super.key,
//     required this.title,
//     required this.value,
//     this.subtitle,
//     required this.icon,
//     required this.color,
//     this.bgColor,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColors.surface,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: AppColors.outline.withOpacity(0.5)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: bgColor ?? color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: color, size: 20),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.onSurface,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 12,
//                 color: AppColors.textSecondary,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             if (subtitle != null) ...[
//               const SizedBox(height: 4),
//               Text(
//                 subtitle!,
//                 style: TextStyle(fontSize: 11, color: color),
//               ),
//             ],
//           ],
//         ),
//       ),
//     ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0);
//   }
// }