import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../../../core/widgets/wn_header.dart';
import '../../../auth/data/models/user_model.dart';
import '../../providers/super_admin_provider.dart';

class SaCompaniesTab extends StatefulWidget {
  const SaCompaniesTab({super.key});
  @override
  State<SaCompaniesTab> createState() => _SaCompaniesTabState();
}

class _SaCompaniesTabState extends State<SaCompaniesTab> {
  CompanyStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final sa = context.watch<SuperAdminProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Companies'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: TextField(
                  onChanged: sa.setSearch,
                  decoration: const InputDecoration(
                    hintText: 'Search companies…',
                    prefixIcon: Icon(Icons.search, size: 18),
                    isDense: true,
                  ),
                ),
              ),
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      selected: _filter == null,
                      onTap: () {
                        setState(() => _filter = null);
                        sa.setStatusFilter(null);
                      },
                    ),
                    const SizedBox(width: 8),
                    ...CompanyStatus.values.map((s) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FilterChip(
                        label: s.name[0].toUpperCase() +
                            s.name.substring(1),
                        selected: _filter == s,
                        color: _statusColor(s),
                        onTap: () {
                          setState(() => _filter = s);
                          sa.setStatusFilter(s);
                        },
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: sa.companies.isEmpty
          ? const Center(
              child: Text('No companies match your search.',
                  style: TextStyle(color: AppColors.textSecondary)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sa.companies.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
              itemBuilder: (_, i) => _CompanyCard(
                company: sa.companies[i],
                onTap: () =>
                    _showDetail(context, sa.companies[i]),
              ).animate().fadeIn(delay: (i * 40).ms),
            ),
    );
  }

  void _showDetail(BuildContext context, CompanyModel company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CompanyDetailSheet(company: company),
    );
  }

  Color _statusColor(CompanyStatus s) => switch (s) {
    CompanyStatus.active    => AppColors.success,
    CompanyStatus.pending   => AppColors.warning,
    CompanyStatus.suspended => AppColors.error,
    CompanyStatus.inactive  => AppColors.textTertiary,
  };
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primaryAccent;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c.withOpacity(0.12) : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? c : AppColors.outline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? c : AppColors.textSecondary)),
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final CompanyModel company;
  final VoidCallback onTap;

  const _CompanyCard({required this.company, required this.onTap});

  Color get _statusColor => switch (company.status) {
    CompanyStatus.active    => AppColors.success,
    CompanyStatus.pending   => AppColors.warning,
    CompanyStatus.suspended => AppColors.error,
    CompanyStatus.inactive  => AppColors.textTertiary,
  };

  Color get _planColor => switch (company.plan) {
    'enterprise' => AppColors.primaryAccent,
    'growth'     => AppColors.secondary,
    _            => AppColors.textTertiary,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.divider),
                ),
                alignment: Alignment.center,
                child: Text(
                  company.name.substring(0, 2).toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.primaryAccent),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textPrimary)),
                    Text(company.industry,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StatusBadge(
                      label: company.status.name,
                      color: _statusColor),
                  const SizedBox(height: 4),
                  _PlanBadge(
                      plan: company.plan, color: _planColor),
                ],
              ),
            ]),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(children: [
              _InfoChip(Icons.people_outline,
                  '${company.staffCount} staff'),
              const SizedBox(width: 12),
              _InfoChip(Icons.location_on_outlined,
                  company.address.split(',').first),
              const Spacer(),
              Text(
                AppDateUtils.formatShortDate(company.registeredAt),
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textTertiary),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label[0].toUpperCase() + label.substring(1),
        style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color),
      ),
    );
  }
}

class _PlanBadge extends StatelessWidget {
  final String plan;
  final Color color;
  const _PlanBadge({required this.plan, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      plan[0].toUpperCase() + plan.substring(1),
      style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 13, color: AppColors.textTertiary),
      const SizedBox(width: 3),
      Text(label,
          style: const TextStyle(
              fontSize: 11, color: AppColors.textSecondary),
          overflow: TextOverflow.ellipsis),
    ]);
  }
}

// ── Detail Sheet
class _CompanyDetailSheet extends StatelessWidget {
  final CompanyModel company;
  const _CompanyDetailSheet({required this.company});

  @override
  Widget build(BuildContext context) {
    final sa = context.read<SuperAdminProvider>();

    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, ctrl) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20)),
          ),
          child: ListView(
            controller: ctrl,
            padding: const EdgeInsets.all(24),
            children: [
              // Handle
              Center(
                child: Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Company header
              Row(children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    company.name.substring(0, 2).toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: AppColors.primaryAccent),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(company.name,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700)),
                      Text(company.industry,
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13)),
                      Text('Reg: ${company.registrationNumber}',
                          style: const TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 11)),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 20),

              // Info grid
              _InfoGrid(company: company),
              const SizedBox(height: 20),

              // Work schedule
              _Section(title: 'Work Schedule', children: [
                _DetailRow('Start Time', company.workStartTime),
                _DetailRow('End Time', company.workEndTime),
                _DetailRow('Break Duration',
                    '${company.breakDurationMinutes} minutes'),
                _DetailRow('Geofence Radius',
                    '${company.geofenceRadius.toInt()} metres'),
              ]),
              const SizedBox(height: 16),

              // Contact
              _Section(title: 'Contact', children: [
                _DetailRow('Email', company.contactEmail),
                _DetailRow('Phone', company.contactPhone),
                _DetailRow('Address', company.address),
              ]),
              const SizedBox(height: 20),

              // Actions
              const Text('Manage',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 12),

              // Plan selector
              Row(children: [
                const Text('Plan:',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                ...['starter', 'growth', 'enterprise'].map((p) =>
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _PlanButton(
                      plan: p,
                      selected: company.plan == p,
                      onTap: () =>
                          sa.updateCompanyPlan(company.id, p),
                    ),
                  )),
              ]),
              const SizedBox(height: 16),

              // Status actions
              Row(children: [
                if (company.status != CompanyStatus.active)
                  Expanded(
                    child: _ActionButton(
                      label: 'Activate',
                      color: AppColors.success,
                      onTap: () {
                        sa.updateCompanyStatus(
                            company.id, CompanyStatus.active);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                if (company.status == CompanyStatus.active) ...[
                  Expanded(
                    child: _ActionButton(
                      label: 'Suspend',
                      color: AppColors.error,
                      onTap: () {
                        sa.updateCompanyStatus(
                            company.id, CompanyStatus.suspended);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionButton(
                    label: 'Delete',
                    color: AppColors.textSecondary,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final CompanyModel company;
  const _InfoGrid({required this.company});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _GridTile('Staff', '${company.staffCount}',
          AppColors.primaryAccent),
      const SizedBox(width: 10),
      _GridTile('Status',
          company.status.name[0].toUpperCase() +
              company.status.name.substring(1),
          _statusColor(company.status)),
      const SizedBox(width: 10),
      _GridTile('Plan',
          company.plan[0].toUpperCase() +
              company.plan.substring(1),
          AppColors.secondary),
    ]);
  }

  Color _statusColor(CompanyStatus s) => switch (s) {
    CompanyStatus.active    => AppColors.success,
    CompanyStatus.pending   => AppColors.warning,
    CompanyStatus.suspended => AppColors.error,
    CompanyStatus.inactive  => AppColors.textTertiary,
  };
}

class _GridTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _GridTile(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color)),
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondary)),
        ]),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _PlanButton extends StatelessWidget {
  final String plan;
  final bool selected;
  final VoidCallback onTap;
  const _PlanButton(
      {required this.plan, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryAccent
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? AppColors.primaryAccent
                : AppColors.outline,
          ),
        ),
        child: Text(
          plan[0].toUpperCase() + plan.substring(1),
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected
                  ? Colors.white
                  : AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color)),
      ),
    );
  }
}