import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../../staff/data/models/attendance_model.dart';
import '../../providers/employer_provider.dart';

class LeaveManagementScreen extends StatefulWidget {
  const LeaveManagementScreen({super.key});

  @override
  State<LeaveManagementScreen> createState() => _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends State<LeaveManagementScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final employer = context.watch<EmployerProvider>();
    final filtered = employer.allLeaveRequests.where((l) {
      if (_filter == 'All') return true;
      if (_filter == 'Pending') return l.status == LeaveStatus.pending;
      if (_filter == 'Approved') return l.status == LeaveStatus.approved;
      if (_filter == 'Rejected') return l.status == LeaveStatus.rejected;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Leave Management')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ['All', 'Pending', 'Approved', 'Rejected'].map((f) {
                final isSelected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _filter = f),
                    selectedColor: AppColors.primaryLight,
                    checkmarkColor: AppColors.primary,
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No leave requests',
                        style: TextStyle(color: AppColors.textSecondary)))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _LeaveCard(
                      leave: filtered[i],
                      onApprove: () => employer.reviewLeave(
                          filtered[i].id, LeaveStatus.approved,
                          note: 'Approved by HR'),
                      onReject: () => employer.reviewLeave(
                          filtered[i].id, LeaveStatus.rejected,
                          note: 'Request declined. Please reapply.'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _LeaveCard extends StatelessWidget {
  final LeaveRequest leave;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _LeaveCard({
    required this.leave,
    required this.onApprove,
    required this.onReject,
  });

  Color get _statusColor => switch (leave.status) {
        LeaveStatus.pending => AppColors.warning,
        LeaveStatus.approved => AppColors.success,
        LeaveStatus.rejected => AppColors.error,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  leave.staffName.split(' ').map((w) => w[0]).take(2).join(),
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(leave.staffName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    Text(leave.leaveType,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  leave.status.name.toUpperCase(),
                  style: TextStyle(
                      color: _statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${AppDateUtils.formatShortDate(leave.startDate)} – '
                '${AppDateUtils.formatShortDate(leave.endDate)} '
                '(${leave.durationDays} days)',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            leave.reason,
            style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (leave.status == LeaveStatus.pending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ] else if (leave.reviewerNote != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '💬 ${leave.reviewerNote}',
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ],
      ),
    );
  }
}