import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../../staff/data/models/payroll_model.dart';
import '../../providers/employer_provider.dart';
import '../../../auth/data/models/user_model.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employer = context.watch<EmployerProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payroll Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Staff Payroll'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PayrollOverview(employer: employer),
          _StaffPayrollList(employer: employer),
        ],
      ),
    );
  }
}

class _PayrollOverview extends StatelessWidget {
  final EmployerProvider employer;
  const _PayrollOverview({required this.employer});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Summary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.gradientSecondary,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  'Monthly Payroll',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  '₦4,200,000',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  AppDateUtils.formatMonth == null ? 'March 2026' : 'March 2026',
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _PayrollStat(label: 'Gross', value: '₦4.9M'),
                    _PayrollStat(label: 'Deductions', value: '₦700K'),
                    _PayrollStat(label: 'Net', value: '₦4.2M'),
                    _PayrollStat(label: 'Overtime', value: '₦234K'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Payroll breakdown chart
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outline.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '6-Month Payroll Trend',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (_) => const FlLine(
                          color: AppColors.outline,
                          strokeWidth: 0.5,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, _) {
                              const months = ['Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'];
                              return Text(months[v.toInt()],
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary));
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
                          spots: const [
                            FlSpot(0, 3.8),
                            FlSpot(1, 3.9),
                            FlSpot(2, 4.1),
                            FlSpot(3, 3.95),
                            FlSpot(4, 4.05),
                            FlSpot(5, 4.2),
                          ],
                          isCurved: true,
                          color: AppColors.secondary,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.secondary.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Department breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outline.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Department Breakdown',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ...['Engineering', 'Design', 'Product', 'Analytics'].map((dept) {
                  final values = {
                    'Engineering': (0.42, '₦1.76M'),
                    'Design': (0.22, '₦924K'),
                    'Product': (0.22, '₦924K'),
                    'Analytics': (0.14, '₦588K'),
                  };
                  final (pct, amount) = values[dept] ?? (0.0, '₦0');
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(dept,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                            const Spacer(),
                            Text(amount,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: pct,
                          backgroundColor: AppColors.primaryLight,
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PayrollStat extends StatelessWidget {
  final String label;
  final String value;
  const _PayrollStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          Text(label,
              style:
                  const TextStyle(color: Colors.white60, fontSize: 11)),
        ],
      ),
    );
  }
}

class _StaffPayrollList extends StatelessWidget {
  final EmployerProvider employer;
  const _StaffPayrollList({required this.employer});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: employer.staffList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final staff = employer.staffList[i];
        final payroll = employer.staffPayroll[staff.id];
        final latest = payroll?.isNotEmpty == true ? payroll!.first : null;
        return _StaffPayrollCard(staff: staff, payroll: latest);
      },
    );
  }
}

class _StaffPayrollCard extends StatelessWidget {
  final UserModel staff;
  final PayrollRecord? payroll;

  const _StaffPayrollCard({required this.staff, this.payroll});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  staff.avatar ?? staff.name[0],
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(staff.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    Text(staff.position ?? '',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              if (payroll != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: payroll!.status == PayrollStatus.paid
                        ? AppColors.successLight
                        : AppColors.warningLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    payroll!.status.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: payroll!.status == PayrollStatus.paid
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (payroll != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                _PayrollDetail(
                    label: 'Hours Worked',
                    value: '${payroll!.totalHoursWorked}h'),
                _PayrollDetail(
                    label: 'Gross Pay',
                    value: '₦${(payroll!.grossPay / 1000).toStringAsFixed(0)}K'),
                _PayrollDetail(
                    label: 'Net Pay',
                    value: '₦${(payroll!.netPay / 1000).toStringAsFixed(0)}K'),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PayrollDetail extends StatelessWidget {
  final String label;
  final String value;
  const _PayrollDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                  fontSize: 15)),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}