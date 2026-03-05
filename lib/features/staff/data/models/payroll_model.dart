import 'package:equatable/equatable.dart';

class PayrollRecord extends Equatable {
  final String id;
  final String staffId;
  final String staffName;
  final DateTime periodStart;
  final DateTime periodEnd;
  final double hourlyRate;
  final double totalHoursWorked;
  final double overtimeHours;
  final double grossPay;
  final double deductions;
  final double netPay;
  final PayrollStatus status;
  final List<PayrollDeduction> deductionDetails;
  final List<PayrollBonus> bonuses;

  const PayrollRecord({
    required this.id,
    required this.staffId,
    required this.staffName,
    required this.periodStart,
    required this.periodEnd,
    required this.hourlyRate,
    required this.totalHoursWorked,
    required this.overtimeHours,
    required this.grossPay,
    required this.deductions,
    required this.netPay,
    required this.status,
    required this.deductionDetails,
    this.bonuses = const [],
  });

  @override
  List<Object?> get props => [id];
}

class PayrollDeduction extends Equatable {
  final String name;
  final double amount;
  final bool isPercentage;

  const PayrollDeduction({
    required this.name,
    required this.amount,
    this.isPercentage = false,
  });

  @override
  List<Object?> get props => [name];
}

class PayrollBonus extends Equatable {
  final String reason;
  final double amount;

  const PayrollBonus({required this.reason, required this.amount});

  @override
  List<Object?> get props => [reason];
}

enum PayrollStatus { pending, processed, paid }