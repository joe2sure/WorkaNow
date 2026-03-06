import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../../../core/widgets/wn_header.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/super_admin_provider.dart';
import '../../data/models/platform_stats_model.dart';

class SaOverviewTab extends StatelessWidget {
  const SaOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth  = context.watch<AuthProvider>();
    final sa    = context.watch<SuperAdminProvider>();
    final stats = sa.stats;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header
          SliverToBoxAdapter(
            child: WnPageHeader(
              greeting: 'Super Administrator',
              name: auth.currentUser?.name ?? 'Admin',
              subtitle: 'Platform overview • ${AppDateUtils.formatDate(DateTime.now())}',
              avatarInitials: auth.currentUser?.avatar ?? 'SA',
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined,
                      color: Colors.white, size: 22),
                ),
              ],
              bottom: _StatusRow(stats: stats),
            ),
          ),

          if (stats == null)
            const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()))
          else ...[
            // ── KPI cards
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.45,
                ),
                delegate: SliverChildListDelegate([
                  _KpiCard(
                    label: 'Total Companies',
                    value: '${stats.totalCompanies}',
                    icon: Icons.business_rounded,
                    iconColor: AppColors.primaryAccent,
                    sub: '${stats.activeCompanies} active',
                  ),
                  _KpiCard(
                    label: 'Total Staff',
                    value: '${stats.totalStaff}',
                    icon: Icons.people_rounded,
                    iconColor: AppColors.secondary,
                    sub: 'Across all companies',
                  ),
                  _KpiCard(
                    label: 'Monthly Revenue',
                    value: '₦${_fmt(stats.monthlyRevenue)}',
                    icon: Icons.account_balance_outlined,
                    iconColor: AppColors.success,
                    sub: '+${stats.revenueGrowth}% vs last month',
                    subColor: AppColors.success,
                  ),
                  _KpiCard(
                    label: 'Pending Approvals',
                    value: '${stats.pendingCompanies}',
                    icon: Icons.pending_actions_outlined,
                    iconColor: AppColors.warning,
                    sub: 'Awaiting review',
                    subColor: AppColors.warning,
                  ),
                ]),
              ),
            ),

            // ── Revenue chart
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _RevenueChart(history: stats.revenueHistory),
              ),
            ),

            // ── Company growth + plan split
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: _CompanyGrowthChart(
                            data: stats.companyGrowth)),
                    const SizedBox(width: 12),
                    const Expanded(child: _PlanDonut()),
                  ],
                ),
              ),
            ),

            // ── Recent activity preview
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _RecentActivityCard(),
              ),
            ),

            const SliverToBoxAdapter(
                child: SizedBox(height: 32)),
          ],
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1_000_000) return '${(v / 1_000_000).toStringAsFixed(2)}M';
    if (v >= 1_000)     return '${(v / 1_000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

// ── Status strip shown in header
class _StatusRow extends StatelessWidget {
  final PlatformStats? stats;
  const _StatusRow({this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats == null) return const SizedBox.shrink();
    return Row(
      children: [
        _Pill('${stats!.activeCompanies} Active',
            AppColors.success),
        const SizedBox(width: 8),
        _Pill('${stats!.pendingCompanies} Pending',
            AppColors.warning),
        const SizedBox(width: 8),
        _Pill('${stats!.suspendedCompanies} Suspended',
            AppColors.error),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  const _Pill(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color)),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final IconData icon;
  final Color iconColor;
  final Color? subColor;

  const _KpiCard({
    required this.label, required this.value,
    required this.sub, required this.icon,
    required this.iconColor, this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(sub,
              style: TextStyle(
                  fontSize: 10,
                  color: subColor ?? AppColors.textTertiary)),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.06);
  }
}

class _RevenueChart extends StatelessWidget {
  final List<MonthlyRevenue> history;
  const _RevenueChart({required this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Revenue Trend',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary)),
                  SizedBox(height: 2),
                  Text('Last 6 months',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('+18.4%',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success)),
            ),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: LineChart(LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppColors.divider, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    getTitlesWidget: (v, _) {
                      final idx = v.toInt();
                      if (idx < 0 || idx >= history.length) {
                        return const SizedBox.shrink();
                      }
                      return Text(history[idx].month,
                          style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textTertiary));
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
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(history.length, (i) =>
                    FlSpot(i.toDouble(),
                        history[i].amount / 1_000_000)),
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: AppColors.primaryAccent,
                  barWidth: 2.5,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (_, __, ___, ____) =>
                      FlDotCirclePainter(
                        radius: 3,
                        color: AppColors.primaryAccent,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryAccent.withOpacity(0.15),
                        AppColors.primaryAccent.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}

class _CompanyGrowthChart extends StatelessWidget {
  final List<CompanyGrowth> data;
  const _CompanyGrowthChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Company Growth',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          SizedBox(
            height: 100,
            child: BarChart(BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 8,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, _) {
                      final i = v.toInt();
                      if (i < 0 || i >= data.length) {
                        return const SizedBox.shrink();
                      }
                      return Text(data[i].month,
                          style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.textTertiary));
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
              barGroups: List.generate(data.length, (i) =>
                BarChartGroupData(x: i, barRods: [
                  BarChartRodData(
                    toY: data[i].count.toDouble(),
                    color: AppColors.primaryAccent
                        .withOpacity(0.3 + (i / data.length) * 0.7),
                    width: 18,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4)),
                  ),
                ])),
            )),
          ),
        ],
      ),
    );
  }
}

class _PlanDonut extends StatelessWidget {
  const _PlanDonut();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Plan Split',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          SizedBox(
            height: 100,
            child: PieChart(PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 28,
              sections: [
                PieChartSectionData(
                    value: 1, color: AppColors.textTertiary,
                    title: '', radius: 18),
                PieChartSectionData(
                    value: 2, color: AppColors.primaryMid,
                    title: '', radius: 18),
                PieChartSectionData(
                    value: 2, color: AppColors.primaryAccent,
                    title: '', radius: 18),
              ],
            )),
          ),
          const SizedBox(height: 10),
          ...[
            _Legend(AppColors.textTertiary, 'Starter — 1'),
            _Legend(AppColors.primaryMid,   'Growth — 2'),
            _Legend(AppColors.primaryAccent,'Enterprise — 2'),
          ],
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(children: [
        Container(width: 8, height: 8,
            decoration: BoxDecoration(
                color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 10, color: AppColors.textSecondary)),
      ]),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sa = context.watch<SuperAdminProvider>();
    final logs = sa.activity.take(4).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WnSectionTitle(
            title: 'Recent Activity',
            trailing: TextButton(
              onPressed: () {},
              child: const Text('View all',
                  style: TextStyle(fontSize: 12)),
            ),
          ),
          const SizedBox(height: 12),
          ...logs.map((l) => _ActivityRow(log: l)),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final ActivityLog log;
  const _ActivityRow({required this.log});

  Color get _dotColor {
    return switch (log.type) {
      'billing' => AppColors.success,
      'company' => AppColors.primaryAccent,
      'user'    => AppColors.secondary,
      _         => AppColors.textTertiary,
    };
  }

  IconData get _icon {
    return switch (log.type) {
      'billing' => Icons.payments_outlined,
      'company' => Icons.business_outlined,
      'user'    => Icons.person_outline,
      _         => Icons.settings_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: _dotColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_icon, size: 15, color: _dotColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(log.action,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              Text(log.target,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary)),
            ],
          ),
        ),
        Text(AppDateUtils.timeAgo(log.timestamp),
            style: const TextStyle(
                fontSize: 10, color: AppColors.textTertiary)),
      ]),
    );
  }
}