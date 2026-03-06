import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../providers/super_admin_provider.dart';

class SaOnboardTab extends StatefulWidget {
  const SaOnboardTab({super.key});
  @override
  State<SaOnboardTab> createState() => _SaOnboardTabState();
}

class _SaOnboardTabState extends State<SaOnboardTab> {
  final _formKey = GlobalKey<FormState>();
  int _step = 0;

  // Company fields
  final _nameCtrl     = TextEditingController();
  final _addressCtrl  = TextEditingController();
  final _regCtrl      = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _phoneCtrl    = TextEditingController();
  String _industry    = 'Technology';
  String _plan        = 'growth';

  // Work schedule
  String _startTime   = '08:00';
  String _endTime     = '17:00';
  int    _breakMins   = 60;
  double _geofence    = 200;

  // Employer account
  final _empNameCtrl  = TextEditingController();
  final _empEmailCtrl = TextEditingController();
  final _empPassCtrl  = TextEditingController();

  static const _industries = [
    'Technology', 'Financial Services', 'Healthcare',
    'Education', 'Agriculture', 'Manufacturing',
    'Retail', 'Hospitality', 'Construction', 'Other',
  ];

  @override
  void dispose() {
    for (final c in [
      _nameCtrl, _addressCtrl, _regCtrl, _emailCtrl, _phoneCtrl,
      _empNameCtrl, _empEmailCtrl, _empPassCtrl,
    ]) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sa = context.watch<SuperAdminProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Onboard New Company')),
      body: Column(
        children: [
          // Step indicator
          _StepIndicator(current: _step),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: _stepContent(context, sa),
              ),
            ),
          ),
          // Navigation buttons
          _NavButtons(
            step: _step,
            isLoading: sa.isLoading,
            onBack:  () => setState(() => _step--),
            onNext:  _handleNext,
            onSubmit: () => _submit(context, sa),
          ),
        ],
      ),
    );
  }

  Widget _stepContent(
      BuildContext context, SuperAdminProvider sa) {
    return switch (_step) {
      0 => _CompanyInfoStep(
          nameCtrl: _nameCtrl, addressCtrl: _addressCtrl,
          regCtrl: _regCtrl, emailCtrl: _emailCtrl,
          phoneCtrl: _phoneCtrl,
          industry: _industry,
          onIndustry: (v) => setState(() => _industry = v!),
          plan: _plan,
          onPlan: (v) => setState(() => _plan = v),
        ),
      1 => _WorkScheduleStep(
          startTime: _startTime, endTime: _endTime,
          breakMins: _breakMins, geofence: _geofence,
          onStartTime: (v) => setState(() => _startTime = v),
          onEndTime:   (v) => setState(() => _endTime = v),
          onBreak:     (v) => setState(() => _breakMins = v),
          onGeofence:  (v) => setState(() => _geofence = v),
        ),
      _ => _EmployerAccountStep(
          nameCtrl: _empNameCtrl,
          emailCtrl: _empEmailCtrl,
          passCtrl: _empPassCtrl,
        ),
    };
  }

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _step++);
    }
  }

  Future<void> _submit(
      BuildContext context, SuperAdminProvider sa) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await sa.onboardCompany(
      name: _nameCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      industry: _industry,
      contactEmail: _emailCtrl.text.trim(),
      contactPhone: _phoneCtrl.text.trim(),
      registrationNumber: _regCtrl.text.trim(),
      plan: _plan,
      workStart: _startTime,
      workEnd: _endTime,
      breakMinutes: _breakMins,
      geofenceRadius: _geofence,
      employerName: _empNameCtrl.text.trim(),
      employerEmail: _empEmailCtrl.text.trim(),
      employerPassword: _empPassCtrl.text.trim(),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${_nameCtrl.text} onboarded successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      setState(() {
        _step = 0;
        for (final c in [
          _nameCtrl, _addressCtrl, _regCtrl,
          _emailCtrl, _phoneCtrl,
          _empNameCtrl, _empEmailCtrl, _empPassCtrl,
        ]) c.clear();
      });
    }
  }
}

class _StepIndicator extends StatelessWidget {
  final int current;
  const _StepIndicator({required this.current});

  static const _steps = [
    'Company Info', 'Work Schedule', 'Employer Account'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            // connector
            final stepIdx = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: stepIdx < current
                    ? AppColors.primaryAccent
                    : AppColors.divider,
              ),
            );
          }
          final idx = i ~/ 2;
          final done = idx < current;
          final active = idx == current;
          return Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: done
                      ? AppColors.primaryAccent
                      : active
                          ? AppColors.primaryAccent
                          : AppColors.divider,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  done ? Icons.check : Icons.circle,
                  size: done ? 14 : 8,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(_steps[idx],
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: active
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: active
                          ? AppColors.primaryAccent
                          : AppColors.textTertiary)),
            ],
          );
        }),
      ),
    );
  }
}

// ── Step 1: Company Info
class _CompanyInfoStep extends StatelessWidget {
  final TextEditingController nameCtrl, addressCtrl,
      regCtrl, emailCtrl, phoneCtrl;
  final String industry;
  final void Function(String?) onIndustry;
  final String plan;
  final void Function(String) onPlan;

  static const _industries = [
    'Technology', 'Financial Services', 'Healthcare',
    'Education', 'Agriculture', 'Manufacturing',
    'Retail', 'Hospitality', 'Construction', 'Other',
  ];

  const _CompanyInfoStep({
    required this.nameCtrl, required this.addressCtrl,
    required this.regCtrl, required this.emailCtrl,
    required this.phoneCtrl, required this.industry,
    required this.onIndustry, required this.plan,
    required this.onPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          title: 'Company Information',
          subtitle: 'Enter the company details to register them on WorkaNow.',
        ),
        const SizedBox(height: 20),
        _Field(ctrl: nameCtrl, label: 'Company Name',
            hint: 'e.g. TechVentures Ltd.',
            validator: _required),
        const SizedBox(height: 14),
        _Field(ctrl: addressCtrl, label: 'Office Address',
            hint: '15 Marina Road, Victoria Island, Lagos',
            validator: _required),
        const SizedBox(height: 14),
        _Field(ctrl: regCtrl, label: 'CAC Registration Number',
            hint: 'RC-123456', validator: _required),
        const SizedBox(height: 14),
        _Field(ctrl: emailCtrl, label: 'Contact Email',
            hint: 'hr@company.com',
            keyboard: TextInputType.emailAddress,
            validator: _required),
        const SizedBox(height: 14),
        _Field(ctrl: phoneCtrl, label: 'Contact Phone',
            hint: '+234 800 000 0000',
            keyboard: TextInputType.phone,
            validator: _required),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: industry,
          decoration: const InputDecoration(labelText: 'Industry'),
          items: _industries.map((i) =>
            DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: onIndustry,
        ),
        const SizedBox(height: 20),
        const Text('Subscription Plan',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13)),
        const SizedBox(height: 10),
        Row(children: [
          _PlanCard(
            plan: 'starter', price: '₦15,000/mo',
            features: ['Up to 20 staff', 'Basic reports'],
            selected: plan == 'starter',
            onTap: () => onPlan('starter'),
          ),
          const SizedBox(width: 10),
          _PlanCard(
            plan: 'growth', price: '₦35,000/mo',
            features: ['Up to 100 staff', 'Advanced analytics', 'AI insights'],
            selected: plan == 'growth',
            onTap: () => onPlan('growth'),
          ),
          const SizedBox(width: 10),
          _PlanCard(
            plan: 'enterprise', price: 'Custom',
            features: ['Unlimited staff', 'Priority support', 'Custom integrations'],
            selected: plan == 'enterprise',
            onTap: () => onPlan('enterprise'),
          ),
        ]),
      ],
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;
}

class _PlanCard extends StatelessWidget {
  final String plan, price;
  final List<String> features;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan, required this.price,
    required this.features, required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryLight
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? AppColors.primaryAccent
                  : AppColors.outline,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan[0].toUpperCase() + plan.substring(1),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: selected
                        ? AppColors.primaryAccent
                        : AppColors.textPrimary),
              ),
              Text(price,
                  style: TextStyle(
                      fontSize: 10,
                      color: selected
                          ? AppColors.primaryAccent
                          : AppColors.textTertiary)),
              const SizedBox(height: 6),
              ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(children: [
                  Icon(Icons.check,
                      size: 9,
                      color: selected
                          ? AppColors.primaryAccent
                          : AppColors.textTertiary),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(f,
                        style: const TextStyle(fontSize: 9),
                        overflow: TextOverflow.ellipsis),
                  ),
                ]),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Step 2: Work Schedule
class _WorkScheduleStep extends StatelessWidget {
  final String startTime, endTime;
  final int breakMins;
  final double geofence;
  final void Function(String) onStartTime, onEndTime;
  final void Function(int) onBreak;
  final void Function(double) onGeofence;

  const _WorkScheduleStep({
    required this.startTime, required this.endTime,
    required this.breakMins, required this.geofence,
    required this.onStartTime, required this.onEndTime,
    required this.onBreak, required this.onGeofence,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          title: 'Work Schedule',
          subtitle: 'Configure the company\'s daily working hours and location fence.',
        ),
        const SizedBox(height: 20),

        // Time pickers row
        Row(children: [
          Expanded(
            child: _TimeButton(
              label: 'Work Start',
              value: startTime,
              onTap: () async {
                final t = await _pickTime(
                    context, startTime);
                if (t != null) onStartTime(t);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TimeButton(
              label: 'Work End',
              value: endTime,
              onTap: () async {
                final t = await _pickTime(
                    context, endTime);
                if (t != null) onEndTime(t);
              },
            ),
          ),
        ]),
        const SizedBox(height: 20),

        // Break duration
        _SliderField(
          label: 'Break Duration',
          value: breakMins.toDouble(),
          min: 15, max: 120, divisions: 7,
          display: '$breakMins minutes',
          onChanged: (v) => onBreak(v.toInt()),
        ),
        const SizedBox(height: 20),

        // Geofence
        _SliderField(
          label: 'Geofence Radius',
          value: geofence,
          min: 50, max: 500, divisions: 9,
          display: '${geofence.toInt()} metres',
          onChanged: onGeofence,
        ),
        const SizedBox(height: 20),

        // Info card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: AppColors.primaryAccent.withOpacity(0.3)),
          ),
          child: const Row(children: [
            Icon(Icons.info_outline,
                color: AppColors.primaryAccent, size: 16),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Staff must be within the geofence radius to clock in. '
                'The system uses GPS to verify their location.',
                style: TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Future<String?> _pickTime(
      BuildContext context, String current) async {
    final parts = current.split(':');
    final initial = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
    final picked = await showTimePicker(
        context: context, initialTime: initial);
    if (picked == null) return null;
    return '${picked.hour.toString().padLeft(2, '0')}'
        ':${picked.minute.toString().padLeft(2, '0')}';
  }
}

class _TimeButton extends StatelessWidget {
  final String label, value;
  final VoidCallback onTap;
  const _TimeButton(
      {required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.outline),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.surfaceVariant,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textTertiary)),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.access_time,
                  size: 16, color: AppColors.primaryAccent),
              const SizedBox(width: 6),
              Text(value,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ]),
          ],
        ),
      ),
    );
  }
}

class _SliderField extends StatelessWidget {
  final String label, display;
  final double value, min, max;
  final int divisions;
  final void Function(double) onChanged;

  const _SliderField({
    required this.label, required this.value,
    required this.min, required this.max,
    required this.divisions, required this.display,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(display,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryAccent)),
          ),
        ]),
        Slider(
          value: value, min: min, max: max,
          divisions: divisions,
          activeColor: AppColors.primaryAccent,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ── Step 3: Employer Account
class _EmployerAccountStep extends StatelessWidget {
  final TextEditingController nameCtrl, emailCtrl, passCtrl;
  const _EmployerAccountStep({
    required this.nameCtrl, required this.emailCtrl,
    required this.passCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          title: 'Employer Account',
          subtitle: 'Create the primary administrator account for this company.',
        ),
        const SizedBox(height: 20),
        _Field(ctrl: nameCtrl, label: 'Full Name',
            hint: 'Sarah Johnson', validator: _req),
        const SizedBox(height: 14),
        _Field(ctrl: emailCtrl, label: 'Email Address',
            hint: 'hr@company.com',
            keyboard: TextInputType.emailAddress,
            validator: _req),
        const SizedBox(height: 14),
        _Field(ctrl: passCtrl, label: 'Temporary Password',
            hint: 'Min. 8 characters',
            obscure: true, validator: (v) {
          if (v == null || v.length < 6) {
            return 'Minimum 6 characters';
          }
          return null;
        }),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.successLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: AppColors.success.withOpacity(0.3)),
          ),
          child: const Row(children: [
            Icon(Icons.mark_email_read_outlined,
                color: AppColors.success, size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'A welcome email with login credentials will be sent '
                'to the employer upon successful onboarding.',
                style: TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  String? _req(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;
}

// ── Shared widgets
class _StepHeader extends StatelessWidget {
  final String title, subtitle;
  const _StepHeader(
      {required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text(subtitle,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label, hint;
  final TextInputType? keyboard;
  final bool obscure;
  final String? Function(String?)? validator;

  const _Field({
    required this.ctrl, required this.label,
    required this.hint, this.keyboard,
    this.obscure = false, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
          labelText: label, hintText: hint),
    );
  }
}

class _NavButtons extends StatelessWidget {
  final int step;
  final bool isLoading;
  final VoidCallback onBack, onNext, onSubmit;

  const _NavButtons({
    required this.step, required this.isLoading,
    required this.onBack, required this.onNext,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(children: [
        if (step > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: onBack,
              child: const Text('Back'),
            ),
          ),
        if (step > 0) const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : step < 2 ? onNext : onSubmit,
            child: isLoading
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : Text(step < 2 ? 'Continue' : 'Onboard Company'),
          ),
        ),
      ]),
    );
  }
}