import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../data/models/payroll_model.dart';
import '../../providers/staff_provider.dart';
import '../../data/models/attendance_model.dart';
import '../../../ai/providers/ai_provider.dart';
import '../../../ai/presentation/screens/ai_assistant_screen.dart';
import 'clock_in_screen.dart';
import 'attendance_history_screen.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  int _selectedIndex = 0;
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      context.read<StaffProvider>().loadStaffData(auth.currentUser!.id);
      context.read<AiProvider>().init();
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _currentTime = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _StaffHome(currentTime: _currentTime),
      const AttendanceHistoryScreen(),
      const _LeaveRequestPage(),
      const _PayslipPage(),
      const AiAssistantScreen(isEmployer: false),
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
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month, color: AppColors.primary),
            label: 'Attendance',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_available_outlined),
            selectedIcon: Icon(Icons.event_available, color: AppColors.primary),
            label: 'Leave',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: AppColors.primary),
            label: 'Payslip',
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

class _StaffHome extends StatelessWidget {
  final DateTime currentTime;
  const _StaffHome({required this.currentTime});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final staff = context.watch<StaffProvider>();
    final analytics = staff.analytics;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF1A73E8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white24,
                            child: Text(
                              auth.currentUser?.avatar ?? 'ME',
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
                              const Text('Welcome back 👋',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 13)),
                              Text(
                                auth.currentUser?.name ?? 'Employee',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => context.read<AuthProvider>().logout(),
                            icon: const Icon(Icons.logout, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Live Clock
                      Text(
                        AppDateUtils.formatTime(currentTime),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w200,
                          letterSpacing: 2,
                        ),
                      ).animate(onPlay: (c) => c.repeat()).shimmer(
                            duration: 3.seconds,
                            color: Colors.white38,
                          ),
                      Text(
                        AppDateUtils.formatDate(currentTime),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 20),

                      // Clock Status
                      _ClockStatusBanner(staff: staff),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                // Clock In/Out Controls
                _ClockControls(staff: staff),
                const SizedBox(height: 20),

                // Stats
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    _StatsCard(
                      title: 'Attendance',
                      value: '${analytics['attendanceRate'] ?? 94}%',
                      icon: Icons.check_circle_outline,
                      color: AppColors.success,
                    ),
                    _StatsCard(
                      title: 'Punctuality',
                      value: '${analytics['punctualityScore'] ?? 87}%',
                      icon: Icons.schedule,
                      color: AppColors.primary,
                    ),
                    _StatsCard(
                      title: 'Avg Work Hours',
                      value: '${analytics['avgWorkHours'] ?? 8.6}h',
                      icon: Icons.access_time_filled,
                      color: AppColors.secondary,
                    ),
                    _StatsCard(
                      title: 'Overtime',
                      value: '${analytics['overtimeHours'] ?? 12.5}h',
                      icon: Icons.trending_up,
                      color: AppColors.accent,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Today's Summary
                _TodaySummary(staff: staff),
                const SizedBox(height: 20),

                // Map Placeholder
                _LocationCard(staff: staff),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClockStatusBanner extends StatelessWidget {
  final StaffProvider staff;
  const _ClockStatusBanner({required this.staff});

  @override
  Widget build(BuildContext context) {
    final status = staff.clockStatus;
    String label;
    IconData icon;
    Color color;

    switch (status) {
      case ClockStatus.notClockedIn:
        label = 'Not Clocked In';
        icon = Icons.timer_off_outlined;
        color = Colors.white38;
        break;
      case ClockStatus.clockedIn:
        final clockIn = staff.todayRecord?.clockInTime;
        label = clockIn != null
            ? 'Clocked in at ${AppDateUtils.formatTime(clockIn)}'
            : 'Clocked In';
        icon = Icons.timer_outlined;
        color = AppColors.success;
        break;
      case ClockStatus.onBreak:
        final breakStart = staff.activeBreak?.startTime;
        label = breakStart != null
            ? 'On break since ${AppDateUtils.formatTime(breakStart)}'
            : 'On Break';
        icon = Icons.coffee_outlined;
        color = AppColors.warning;
        break;
      case ClockStatus.clockedOut:
        label = 'Clocked Out';
        icon = Icons.logout;
        color = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ClockControls extends StatelessWidget {
  final StaffProvider staff;
  const _ClockControls({required this.staff});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final status = staff.clockStatus;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          if (status == ClockStatus.notClockedIn) ...[
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ClockInScreen()),
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00C853), Color(0xFF00897B)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fingerprint, color: Colors.white, size: 36),
                    SizedBox(height: 4),
                    Text('Clock In',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.03, 1.03),
                    duration: 1500.ms, curve: Curves.easeInOut),
            const SizedBox(height: 12),
            const Text('Tap to clock in',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ] else if (status == ClockStatus.clockedIn) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  label: 'Start Break',
                  icon: Icons.coffee_rounded,
                  color: AppColors.warning,
                  onTap: () => _showBreakDialog(context),
                ),
                _ActionButton(
                  label: 'Clock Out',
                  icon: Icons.logout_rounded,
                  color: AppColors.error,
                  onTap: () => _confirmClockOut(context),
                ),
              ],
            ),
            if (staff.todayRecord?.clockInTime != null) ...[
              const SizedBox(height: 12),
              _WorkDurationTimer(clockIn: staff.todayRecord!.clockInTime!),
            ],
          ] else if (status == ClockStatus.onBreak) ...[
            _ActionButton(
              label: 'End Break',
              icon: Icons.play_arrow_rounded,
              color: AppColors.success,
              onTap: () async {
                await staff.endBreak();
              },
            ),
            if (staff.activeBreak != null) ...[
              const SizedBox(height: 12),
              Text(
                'Break started at ${AppDateUtils.formatTime(staff.activeBreak!.startTime)}',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ] else if (status == ClockStatus.clockedOut) ...[
            const Icon(Icons.check_circle, color: AppColors.success, size: 48),
            const SizedBox(height: 8),
            const Text(
              'You\'ve clocked out for today!',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            if (staff.todayRecord != null) ...[
              const SizedBox(height: 4),
              Text(
                'Total work: ${AppDateUtils.formatDuration(staff.todayRecord!.totalWorkDuration)}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ],
        ],
      ),
    );
  }

  void _showBreakDialog(BuildContext context) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Start Break'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add an optional note for your break:'),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                hintText: 'e.g. Lunch break',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<StaffProvider>().startBreak(
                    note: noteController.text.isEmpty
                        ? null
                        : noteController.text,
                  );
            },
            child: const Text('Start Break'),
          ),
        ],
      ),
    );
  }

  void _confirmClockOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clock Out'),
        content: const Text(
            'Are you sure you want to clock out for today? This will end your work session.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<StaffProvider>().clockOut();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Clock Out'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkDurationTimer extends StatefulWidget {
  final DateTime clockIn;
  const _WorkDurationTimer({required this.clockIn});

  @override
  State<_WorkDurationTimer> createState() => _WorkDurationTimerState();
}

class _WorkDurationTimerState extends State<_WorkDurationTimer> {
  late Timer _timer;
  late Duration _elapsed;

  @override
  void initState() {
    super.initState();
    _elapsed = DateTime.now().difference(widget.clockIn);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed = DateTime.now().difference(widget.clockIn));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = _elapsed.inHours.toString().padLeft(2, '0');
    final m = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Text(
            '$h:$m:$s',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 24,
              letterSpacing: 2,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700),
          ),
          Text(
            title,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TodaySummary extends StatelessWidget {
  final StaffProvider staff;
  const _TodaySummary({required this.staff});

  @override
  Widget build(BuildContext context) {
    final record = staff.todayRecord;
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
          const Text("Today's Summary",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            children: [
              _SummaryItem(
                label: 'Clock In',
                value: record?.clockInTime != null
                    ? AppDateUtils.formatTime(record!.clockInTime!)
                    : '--:--',
                icon: Icons.login,
                color: AppColors.success,
              ),
              _SummaryItem(
                label: 'Break',
                value: record != null
                    ? AppDateUtils.formatDuration(record.totalBreakDuration)
                    : '--',
                icon: Icons.coffee_outlined,
                color: AppColors.warning,
              ),
              _SummaryItem(
                label: 'Work Time',
                value: record != null
                    ? AppDateUtils.formatDuration(
                        record.clockOutTime != null
                            ? record.totalWorkDuration
                            : DateTime.now().difference(record.clockInTime!) -
                                record.totalBreakDuration)
                    : '--',
                icon: Icons.access_time,
                color: AppColors.primary,
              ),
              _SummaryItem(
                label: 'Clock Out',
                value: record?.clockOutTime != null
                    ? AppDateUtils.formatTime(record!.clockOutTime!)
                    : '--:--',
                icon: Icons.logout,
                color: AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
                fontWeight: FontWeight.w700, color: color, fontSize: 13),
          ),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 10),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final StaffProvider staff;
  const _LocationCard({required this.staff});

  @override
  Widget build(BuildContext context) {
    // Lagos coordinates (Victoria Island area)
    const LatLng lagosLocation = LatLng(6.4281, 3.4219);
    
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // OpenStreetMap
            FlutterMap(
              options: const MapOptions(
                initialCenter: lagosLocation,
                initialZoom: 15.0,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.none, // Read-only map for dashboard
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                const MarkerLayer(
                  markers: [
                    Marker(
                      point: lagosLocation,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_pin,
                        color: AppColors.primary,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Location overlay
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: staff.isLocationVerified
                            ? AppColors.successLight
                            : AppColors.warningLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        staff.isLocationVerified
                            ? Icons.location_on
                            : Icons.location_searching,
                        color: staff.isLocationVerified
                            ? AppColors.success
                            : AppColors.warning,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            staff.isLocationVerified
                                ? 'Location Verified ✓'
                                : 'Location Not Verified',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: staff.isLocationVerified
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                          Text(
                            staff.currentLocation ??
                                '15 Marina Road, Victoria Island, Lagos',
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class _LocationCard extends StatelessWidget {
//   final StaffProvider staff;
//   const _LocationCard({required this.staff});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 180,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.outline.withOpacity(0.5)),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Stack(
//           children: [
//             // Map placeholder (replace with GoogleMap widget in production)
//             Container(
//               color: const Color(0xFFE8F0FE),
//               child: CustomPaint(
//                 painter: _MapPainter(),
//                 size: Size.infinite,
//               ),
//             ),
//             // Location overlay
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: staff.isLocationVerified
//                             ? AppColors.successLight
//                             : AppColors.warningLight,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         staff.isLocationVerified
//                             ? Icons.location_on
//                             : Icons.location_searching,
//                         color: staff.isLocationVerified
//                             ? AppColors.success
//                             : AppColors.warning,
//                         size: 18,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             staff.isLocationVerified
//                                 ? 'Location Verified ✓'
//                                 : 'Location Not Verified',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 13,
//                               color: staff.isLocationVerified
//                                   ? AppColors.success
//                                   : AppColors.warning,
//                             ),
//                           ),
//                           Text(
//                             staff.currentLocation ??
//                                 '15 Marina Road, Victoria Island, Lagos',
//                             style: const TextStyle(
//                                 color: AppColors.textSecondary, fontSize: 11),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Map marker
//             const Positioned(
//               top: 55,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: Icon(
//                   Icons.location_pin,
//                   color: AppColors.primary,
//                   size: 36,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _MapPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFFD4E3FC)
//       ..style = PaintingStyle.fill;
    
//     // Roads
//     final roadPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 6;

//     // Draw simple map grid
//     for (double x = 0; x < size.width; x += 40) {
//       canvas.drawLine(Offset(x, 0), Offset(x, size.height), roadPaint);
//     }
//     for (double y = 0; y < size.height; y += 40) {
//       canvas.drawLine(Offset(0, y), Offset(size.width, y), roadPaint);
//     }

//     // Draw some "buildings"
//     final buildingPaint = Paint()
//       ..color = const Color(0xFFB8CEF9)
//       ..style = PaintingStyle.fill;

//     canvas.drawRect(const Rect.fromLTWH(10, 10, 28, 28), buildingPaint);
//     canvas.drawRect(const Rect.fromLTWH(52, 10, 36, 28), buildingPaint);
//     canvas.drawRect(const Rect.fromLTWH(10, 50, 20, 36), buildingPaint);
//     canvas.drawRect(const Rect.fromLTWH(92, 50, 28, 20), buildingPaint);
//     canvas.drawRect(const Rect.fromLTWH(130, 10, 24, 36), buildingPaint);
//     canvas.drawRect(const Rect.fromLTWH(170, 30, 20, 28), buildingPaint);
//     canvas.drawRect(const Rect.fromLTWH(200, 10, 32, 20), buildingPaint);
//     canvas.drawRect(const Rect.fromLTWH(52, 90, 28, 24), buildingPaint);
//     canvas.drawRect(const Rect.fromLTWH(130, 90, 36, 28), buildingPaint);
//   }

//   @override
//   bool shouldRepaint(_) => false;
// }

// Staff Leave Request Page (simplified)
class _LeaveRequestPage extends StatefulWidget {
  const _LeaveRequestPage();

  @override
  State<_LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<_LeaveRequestPage> {
  String _selectedLeaveType = 'Annual Leave';
  DateTime _startDate = DateTime.now().add(const Duration(days: 7));
  DateTime _endDate = DateTime.now().add(const Duration(days: 14));
  final _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final staffProvider = context.watch<StaffProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Leave Requests')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Leave balance card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: AppColors.gradientSecondary),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.beach_access,
                          color: Colors.white, size: 32),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Leave Balance',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                          Text('12 days remaining',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // New leave request
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
                      const Text('New Leave Request',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedLeaveType,
                        decoration:
                            const InputDecoration(labelText: 'Leave Type'),
                        items: [
                          'Annual Leave',
                          'Sick Leave',
                          'Maternity Leave',
                          'Paternity Leave',
                          'Emergency Leave',
                          'Study Leave',
                        ]
                            .map((t) =>
                                DropdownMenuItem(value: t, child: Text(t)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedLeaveType = v!),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _DatePicker(
                              label: 'Start Date',
                              date: _startDate,
                              onTap: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  initialDate: _startDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)),
                                );
                                if (d != null)
                                  setState(() => _startDate = d);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DatePicker(
                              label: 'End Date',
                              date: _endDate,
                              onTap: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  initialDate: _endDate,
                                  firstDate: _startDate,
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)),
                                );
                                if (d != null) setState(() => _endDate = d);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _reasonController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Reason for Leave',
                          hintText: 'Please provide a reason...',
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          staffProvider.submitLeaveRequest(
                            staffId: auth.currentUser!.id,
                            staffName: auth.currentUser!.name,
                            leaveType: _selectedLeaveType,
                            startDate: _startDate,
                            endDate: _endDate,
                            reason: _reasonController.text.isEmpty
                                ? 'No reason provided'
                                : _reasonController.text,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Leave request submitted for approval!'),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          _reasonController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48)),
                        child: const Text('Submit Request'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Leave history
                const Text('My Leave History',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),
                ...staffProvider.leaveRequests.map((l) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.outline.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.event_note,
                              color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.leaveType,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                              Text(
                                '${AppDateUtils.formatShortDate(l.startDate)} – ${AppDateUtils.formatShortDate(l.endDate)}',
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        _StatusBadge(status: l.status),
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

class _DatePicker extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DatePicker(
      {required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
            const SizedBox(height: 4),
            Text(AppDateUtils.formatShortDate(date),
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final LeaveStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case LeaveStatus.pending:
        color = AppColors.warning;
        label = 'Pending';
        break;
      case LeaveStatus.approved:
        color = AppColors.success;
        label = 'Approved';
        break;
      case LeaveStatus.rejected:
        color = AppColors.error;
        label = 'Declined';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

// Payslip Page
class _PayslipPage extends StatelessWidget {
  const _PayslipPage();

  @override
  Widget build(BuildContext context) {
    final staff = context.watch<StaffProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Payslips')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: staff.payrollHistory.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final pay = staff.payrollHistory[i];
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
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.receipt_long,
                          color: AppColors.primary),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppDateUtils.formatMonth(pay.periodStart),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15)),
                        Text(
                          '${AppDateUtils.formatShortDate(pay.periodStart)} – ${AppDateUtils.formatShortDate(pay.periodEnd)}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: pay.status == PayrollStatus.paid
                            ? AppColors.successLight
                            : AppColors.warningLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        pay.status.name.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          color: pay.status == PayrollStatus.paid
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _PayItem(
                        label: 'Hours Worked',
                        value: '${pay.totalHoursWorked}h'),
                    _PayItem(
                        label: 'Overtime',
                        value: '${pay.overtimeHours}h'),
                    _PayItem(
                        label: 'Gross',
                        value:
                            '₦${(pay.grossPay / 1000).toStringAsFixed(0)}K'),
                    _PayItem(
                        label: 'Net Pay',
                        value:
                            '₦${(pay.netPay / 1000).toStringAsFixed(0)}K',
                        color: AppColors.primary),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PayItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _PayItem({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: color ?? AppColors.onSurface,
              )),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 10),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}