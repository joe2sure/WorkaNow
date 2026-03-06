import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../providers/super_admin_provider.dart';
import '../../data/models/platform_stats_model.dart';

class SaActivityTab extends StatelessWidget {
  const SaActivityTab({super.key});

  @override
  Widget build(BuildContext context) {
    final sa = context.watch<SuperAdminProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Activity Log')),
      body: sa.activity.isEmpty
          ? const Center(
              child: Text('No activity recorded.',
                  style: TextStyle(color: AppColors.textSecondary)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sa.activity.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
              itemBuilder: (_, i) =>
                  _LogCard(log: sa.activity[i]),
            ),
    );
  }
}

class _LogCard extends StatelessWidget {
  final ActivityLog log;
  const _LogCard({required this.log});

  Color get _color => switch (log.type) {
    'billing' => AppColors.success,
    'company' => AppColors.primaryAccent,
    'user'    => AppColors.secondary,
    _         => AppColors.textTertiary,
  };

  IconData get _icon => switch (log.type) {
    'billing' => Icons.receipt_long_outlined,
    'company' => Icons.business_outlined,
    'user'    => Icons.person_outline,
    _         => Icons.settings_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: _color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_icon, size: 17, color: _color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(log.action,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(log.target,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Row(children: [
                const Icon(Icons.person_outline,
                    size: 11, color: AppColors.textTertiary),
                const SizedBox(width: 3),
                Text(log.actor,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary)),
              ]),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: _color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(log.type,
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: _color)),
            ),
            const SizedBox(height: 6),
            Text(AppDateUtils.timeAgo(log.timestamp),
                style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textTertiary)),
          ],
        ),
      ]),
    );
  }
}