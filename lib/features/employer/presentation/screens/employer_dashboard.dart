import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../staff/data/models/attendance_model.dart';
import '../../providers/employer_provider.dart';
import '../../../ai/providers/ai_provider.dart';
import '../../../ai/presentation/screens/ai_assistant_screen.dart';
import 'payroll_screen.dart';
import 'staff_management_screen.dart';
import 'leave_management_screen.dart';

class EmployerDashboard extends StatefulWidget {
  const EmployerDashboard({super.key});

  @override
  State<EmployerDashboard> createState() => _EmployerDashboardState();
}

class _EmployerDashboardState extends State<EmployerDashboard> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployerProvider>().loadEmployerData();
      context.read<AiProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final employer = context.watch<EmployerProvider>();

    final pages = [
      _DashboardHome(employer: employer, auth: auth),
      const StaffManagementScreen(),
      const PayrollScreen(),
      const LeaveManagementScreen(),
      const AiAssistantScreen(isEmployer: true),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryLight,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people, color: AppColors.primary),
            label: 'Staff',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments, color: AppColors.primary),
            label: 'Payroll',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note, color: AppColors.primary),
            label: 'Leave',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome, color: AppColors.primary),
            label: 'AI',
          ),
        ],
      ),
    );
  }
}

class _DashboardHome extends StatelessWidget {
  final EmployerProvider employer;
  final AuthProvider auth;

  const _DashboardHome({required this.employer, required this.auth});

  @override
  Widget build(BuildContext context) {
    final analytics = employer.getCompanyAnalytics();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.gradientPrimary,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white24,
                              child: Text(
                                auth.currentUser?.avatar ?? 'HR',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Good Morning,',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 13),
                                ),
                                Text(
                                  auth.currentUser?.name ?? 'Manager',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.notifications_outlined,
                                  color: Colors.white),
                            ),
                            IconButton(
                              onPressed: () => context.read<AuthProvider>().logout(),
                              icon: const Icon(Icons.logout, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppDateUtils.formatDate(DateTime.now()),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                        Text(
                          auth.currentCompany?.name ?? 'Company',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick Stats
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    StatCard(
                      title: 'Total Staff',
                      value: '${employer.totalStaff}',
                      subtitle: 'Active employees',
                      icon: Icons.people_rounded,
                      color: AppColors.primary,
                    ),
                    StatCard(
                      title: 'Present Today',
                      value: '${employer.presentToday}',
                      subtitle: '${employer.totalStaff - employer.presentToday} absent',
                      icon: Icons.check_circle_rounded,
                      color: AppColors.success,
                    ),
                    StatCard(
                      title: 'Pending Leaves',
                      value: '${employer.pendingLeaves}',
                      subtitle: 'Awaiting review',
                      icon: Icons.event_busy_rounded,
                      color: AppColors.warning,
                    ),
                    StatCard(
                      title: 'Monthly Payroll',
                      value: '₦4.2M',
                      subtitle: 'Projected',
                      icon: Icons.account_balance_wallet_rounded,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // AI Insights
                _AiInsightsCard(),
                const SizedBox(height: 20),

                // Today's Attendance
                _TodayAttendanceCard(employer: employer),
                const SizedBox(height: 20),

                // Weekly Chart
                _WeeklyAttendanceChart(analytics: analytics),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiInsightsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ai = context.watch<AiProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B48FF), Color(0xFF9C27B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'AI Insights',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('See all',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (ai.insights.isNotEmpty)
            _InsightChip(insight: ai.insights.first)
          else
            const Text('No insights yet',
                style: TextStyle(color: Colors.white70)),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
}

class _InsightChip extends StatelessWidget {
  final insight;
  const _InsightChip({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            insight.title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            insight.summary,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _TodayAttendanceCard extends StatelessWidget {
  final EmployerProvider employer;
  const _TodayAttendanceCard({required this.employer});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Attendance",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ...employer.staffList.take(5).map((staff) {
            final record = employer.getTodayAttendance(staff.id);
            return _StaffAttendanceRow(
              name: staff.name,
              avatar: staff.avatar ?? staff.name[0],
              position: staff.position ?? '',
              status: record?.status ?? AttendanceStatus.absent,
              clockInTime: record?.clockInTime,
            );
          }),
        ],
      ),
    );
  }
}

class _StaffAttendanceRow extends StatelessWidget {
  final String name;
  final String avatar;
  final String position;
  final AttendanceStatus status;
  final DateTime? clockInTime;

  const _StaffAttendanceRow({
    required this.name,
    required this.avatar,
    required this.position,
    required this.status,
    this.clockInTime,
  });

  Color get _statusColor {
    return switch (status) {
      AttendanceStatus.present => AppColors.success,
      AttendanceStatus.late => AppColors.warning,
      AttendanceStatus.absent => AppColors.error,
      _ => AppColors.textSecondary,
    };
  }

  String get _statusLabel {
    return switch (status) {
      AttendanceStatus.present => 'Present',
      AttendanceStatus.late => 'Late',
      AttendanceStatus.absent => 'Absent',
      AttendanceStatus.onLeave => 'On Leave',
      _ => 'Unknown',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              avatar,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(position,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                      color: _statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
              if (clockInTime != null) ...[
                const SizedBox(height: 2),
                Text(
                  AppDateUtils.formatTime(clockInTime!),
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyAttendanceChart extends StatelessWidget {
  final Map<String, dynamic> analytics;
  const _WeeklyAttendanceChart({required this.analytics});

  @override
  Widget build(BuildContext context) {
    final data = analytics['weeklyPresent'] as List<dynamic>;
    return Container(
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
            'Weekly Attendance',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                        return Text(days[v.toInt()],
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textSecondary));
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
                  return BarChartGroupData(x: i, barRods: [
                    BarChartRodData(
                      toY: (data[i] as num).toDouble(),
                      color: AppColors.primary,
                      width: 28,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6)),
                    ),
                  ]);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}