import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../data/models/attendance_model.dart';
import '../../providers/staff_provider.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final staff = context.watch<StaffProvider>();
    final history = staff.attendanceHistory;
    final analytics = staff.analytics;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Attendance History')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Monthly Summary Chart
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.outline.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('This Month',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _AttendanceStat(
                              label: 'Present',
                              value: '${analytics['presentDays'] ?? 18}',
                              color: AppColors.success,
                            ),
                            _AttendanceStat(
                              label: 'Late',
                              value: '${analytics['lateCount'] ?? 2}',
                              color: AppColors.warning,
                            ),
                            _AttendanceStat(
                              label: 'Absent',
                              value: '${analytics['absentDays'] ?? 1}',
                              color: AppColors.error,
                            ),
                            _AttendanceStat(
                              label: 'Leave',
                              value: '${analytics['leaveDays'] ?? 2}',
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Weekly hours bar chart
                        SizedBox(
                          height: 100,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 12,
                              barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (v, _) {
                                      const d = ['M', 'T', 'W', 'T', 'F'];
                                      return Text(d[v.toInt()],
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color:
                                                  AppColors.textSecondary));
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: const FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              barGroups: List.generate(5, (i) {
                                final hours =
                                    (analytics['weeklyHours'] as List?)
                                            ?[i] ??
                                        8.0;
                                return BarChartGroupData(x: i, barRods: [
                                  BarChartRodData(
                                    toY: (hours as num).toDouble(),
                                    color: hours >= 8
                                        ? AppColors.primary
                                        : AppColors.warning,
                                    width: 20,
                                    borderRadius:
                                        const BorderRadius.vertical(
                                            top: Radius.circular(4)),
                                  ),
                                ]);
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Recent Records',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final record = history[i];
                  if (record.status == AttendanceStatus.holiday) {
                    return _HolidayTile(record: record);
                  }
                  return _AttendanceTile(record: record);
                },
                childCount: history.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _AttendanceStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 22, color: color)),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _AttendanceTile extends StatelessWidget {
  final AttendanceRecord record;
  const _AttendanceTile({required this.record});

  @override
  Widget build(BuildContext context) {
    final isLate = record.status == AttendanceStatus.late;
    final color = isLate ? AppColors.warning : AppColors.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isLate ? Icons.schedule : Icons.check_circle_outline,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppDateUtils.formatDate(record.date),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    if (record.isLocationVerified)
                      const Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 12, color: AppColors.success),
                          SizedBox(width: 2),
                          Text('Location verified',
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.success)),
                        ],
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  record.status == AttendanceStatus.late ? 'Late' : 'Present',
                  style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _TimeInfo(
                label: 'In',
                value: record.clockInTime != null
                    ? AppDateUtils.formatTime(record.clockInTime!)
                    : '--',
              ),
              _TimeInfo(
                label: 'Out',
                value: record.clockOutTime != null
                    ? AppDateUtils.formatTime(record.clockOutTime!)
                    : '--',
              ),
              _TimeInfo(
                label: 'Break',
                value: AppDateUtils.formatDuration(record.totalBreakDuration),
              ),
              _TimeInfo(
                label: 'Work',
                value: AppDateUtils.formatDuration(record.totalWorkDuration),
              ),
            ],
          ),
          if (record.lateNote != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.comment_outlined,
                      size: 14, color: AppColors.warning),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      record.lateNote!,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic),
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

class _HolidayTile extends StatelessWidget {
  final AttendanceRecord record;
  const _HolidayTile({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.weekend_outlined,
                size: 20, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Text(
            AppDateUtils.formatDate(record.date),
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14),
          ),
          const Spacer(),
          const Text('Weekend',
              style:
                  TextStyle(color: AppColors.textTertiary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _TimeInfo extends StatelessWidget {
  final String label;
  final String value;

  const _TimeInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.onSurface)),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }
}