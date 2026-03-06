import 'package:equatable/equatable.dart';

enum PaymentStatus { recorded, paid, pending }

class MonthlyPayment extends Equatable {
  final String id;
  final String staffId;
  final String staffName;
  final String staffPosition;
  final String staffDepartment;
  final String employeeId;
  final String companyId;
  final int payMonth;   // 1–12
  final int payYear;
  final double basicSalary;
  final List<PaymentBonus> bonuses;
  final List<PaymentDeduction> deductions;
  final double grossPay;
  final double totalDeductions;
  final double netPay;
  final PaymentStatus status;
  final DateTime recordedAt;
  final DateTime? paidAt;
  final String? notes;

  const MonthlyPayment({
    required this.id,
    required this.staffId,
    required this.staffName,
    required this.staffPosition,
    required this.staffDepartment,
    required this.employeeId,
    required this.companyId,
    required this.payMonth,
    required this.payYear,
    required this.basicSalary,
    required this.bonuses,
    required this.deductions,
    required this.grossPay,
    required this.totalDeductions,
    required this.netPay,
    required this.status,
    required this.recordedAt,
    this.paidAt,
    this.notes,
  });

  String get periodLabel {
    const months = [
      '', 'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August', 'September',
      'October', 'November', 'December',
    ];
    return '${months[payMonth]} $payYear';
  }

  MonthlyPayment copyWith({PaymentStatus? status, DateTime? paidAt}) {
    return MonthlyPayment(
      id: id, staffId: staffId, staffName: staffName,
      staffPosition: staffPosition, staffDepartment: staffDepartment,
      employeeId: employeeId, companyId: companyId,
      payMonth: payMonth, payYear: payYear,
      basicSalary: basicSalary, bonuses: bonuses,
      deductions: deductions, grossPay: grossPay,
      totalDeductions: totalDeductions, netPay: netPay,
      status: status ?? this.status,
      recordedAt: recordedAt,
      paidAt: paidAt ?? this.paidAt,
      notes: notes,
    );
  }

  @override
  List<Object?> get props => [id];
}

class PaymentBonus extends Equatable {
  final String label;
  final double amount;
  const PaymentBonus({required this.label, required this.amount});
  @override
  List<Object?> get props => [label, amount];
}

class PaymentDeduction extends Equatable {
  final String label;
  final double amount;
  final bool isPercentage;
  const PaymentDeduction({
    required this.label,
    required this.amount,
    this.isPercentage = false,
  });
  double computeFrom(double base) =>
      isPercentage ? base * (amount / 100) : amount;
  @override
  List<Object?> get props => [label, amount];
}