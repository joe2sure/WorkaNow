import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../../auth/data/models/user_model.dart';
import '../../providers/employer_provider.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final employer = context.watch<EmployerProvider>();
    final filtered = employer.staffList
        .where((s) =>
            s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (s.department?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Staff Management'),
        actions: [
          IconButton(
            onPressed: () => _showAddStaffSheet(context),
            icon: const Icon(Icons.person_add_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: const InputDecoration(
                hintText: 'Search staff...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _StaffCard(
                staff: filtered[i],
                employer: employer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddStaffSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _AddStaffSheet(),
    );
  }
}

class _StaffCard extends StatelessWidget {
  final UserModel staff;
  final EmployerProvider employer;

  const _StaffCard({required this.staff, required this.employer});

  @override
  Widget build(BuildContext context) {
    final todayRecord = employer.getTodayAttendance(staff.id);
    final isPresent = todayRecord?.clockInTime != null;

    return GestureDetector(
      onTap: () => _showStaffDetail(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    staff.avatar ?? staff.name[0],
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isPresent ? AppColors.success : AppColors.textSecondary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    staff.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  Text(
                    '${staff.position} • ${staff.department}',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
                  Text(
                    staff.employeeId ?? '',
                    style: const TextStyle(
                        color: AppColors.textTertiary, fontSize: 11),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isPresent)
                  Text(
                    AppDateUtils.formatTime(todayRecord!.clockInTime!),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                  )
                else
                  const Text('Not in',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  '₦${(staff.hourlyRate ?? 0).toStringAsFixed(0)}/hr',
                  style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showStaffDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _StaffDetailSheet(staff: staff, employer: employer),
    );
  }
}

class _StaffDetailSheet extends StatelessWidget {
  final UserModel staff;
  final EmployerProvider employer;

  const _StaffDetailSheet({required this.staff, required this.employer});

  @override
  Widget build(BuildContext context) {
    final history = employer.staffAttendance[staff.id] ?? [];
    final analytics = {
      'attendance': '94%',
      'punctuality': '87%',
      'avgHours': '8.6h',
      'overtime': '12.5h',
    };

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      staff.avatar ?? staff.name[0],
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(staff.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                      Text(staff.position ?? '',
                          style: const TextStyle(
                              color: AppColors.textSecondary)),
                      Text(staff.employeeId ?? '',
                          style: const TextStyle(
                              color: AppColors.textTertiary, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Stats Row
              Row(
                children: analytics.entries.map((e) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(e.value,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700,
                                  color: AppColors.primary)),
                          Text(e.key,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Recent Attendance',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 12),
              ...history.take(5).where((r) => r.clockInTime != null).map((r) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: r.isLate
                          ? AppColors.warningLight
                          : AppColors.successLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      r.isLate ? Icons.schedule : Icons.check_circle_outline,
                      color: r.isLate ? AppColors.warning : AppColors.success,
                      size: 20,
                    ),
                  ),
                  title: Text(AppDateUtils.formatDate(r.date),
                      style: const TextStyle(fontSize: 13)),
                  subtitle: Text(
                    'In: ${AppDateUtils.formatTime(r.clockInTime!)} | '
                    'Work: ${AppDateUtils.formatDuration(r.totalWorkDuration)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: r.isLate
                      ? const Chip(
                          label: Text('Late', style: TextStyle(fontSize: 11)),
                          backgroundColor: AppColors.warningLight,
                          padding: EdgeInsets.zero,
                        )
                      : null,
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _AddStaffSheet extends StatefulWidget {
  const _AddStaffSheet();

  @override
  State<_AddStaffSheet> createState() => _AddStaffSheetState();
}

class _AddStaffSheetState extends State<_AddStaffSheet> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _positionCtrl = TextEditingController();
  String _department = 'Engineering';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add New Staff',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Full Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'Email Address'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _positionCtrl,
            decoration: const InputDecoration(labelText: 'Position/Role'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _department,
            decoration: const InputDecoration(labelText: 'Department'),
            items: ['Engineering', 'Design', 'Product', 'Analytics', 'Marketing', 'HR']
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (v) => setState(() => _department = v!),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Staff member added successfully!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Add Staff Member'),
            ),
          ),
        ],
      ),
    );
  }
}