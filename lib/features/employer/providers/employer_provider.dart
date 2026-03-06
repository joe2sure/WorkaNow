import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../auth/data/mock_auth_data.dart';
import '../../auth/data/models/user_model.dart';
import '../../staff/data/models/attendance_model.dart';
import '../../staff/data/mock_staff_data.dart';
import '../data/models/department_model.dart';
import '../data/models/query_message_model.dart';
import '../data/models/payment_model.dart';
import '../data/mock_employer_data.dart';

class EmployerProvider extends ChangeNotifier {
  // ── State
  List<UserModel>           _staffList       = [];
  List<DepartmentModel>     _departments     = [];
  List<QueryMessage>        _queryMessages   = [];
  List<MonthlyPayment>      _payments        = [];
  Map<String, List<AttendanceRecord>> _staffAttendance = {};
  Map<String, List<LeaveRequest>>     _staffLeave      = {};
  bool   _isLoading = false;
  String _companyId = 'company_001';

  final _uuid = const Uuid();

  // ── Getters
  List<UserModel>       get staffList     => _staffList;
  List<DepartmentModel> get departments   => _departments;
  List<QueryMessage>    get queryMessages => _queryMessages;
  List<MonthlyPayment>  get payments      => _payments;
  bool get isLoading => _isLoading;

  Map<String, List<AttendanceRecord>> get staffAttendance =>
      _staffAttendance;

  List<LeaveRequest> get allLeaveRequests {
    final all = <LeaveRequest>[];
    for (final list in _staffLeave.values) all.addAll(list);
    return all;
  }

  int get totalStaff    => _staffList.length;
  int get pendingLeaves => allLeaveRequests
      .where((l) => l.status == LeaveStatus.pending).length;
  int get unreadQueries => _queryMessages
      .where((q) => q.status == QueryStatus.sent).length;

  int get presentToday {
    final today = DateTime.now();
    return _staffAttendance.values.where((records) {
      if (records.isEmpty) return false;
      final r = records.first;
      return r.date.day == today.day &&
             r.date.month == today.month &&
             r.date.year == today.year &&
             r.clockInTime != null;
    }).length;
  }

  // ── Load data
  void loadEmployerData(String companyId) {
    _companyId   = companyId;
    _staffList   = MockAuthData.staffList
        .where((s) => s.companyId == companyId)
        .toList();
    _departments = MockEmployerData.getDepartments(companyId);
    _queryMessages = MockEmployerData.getQueryMessages(companyId);
    _payments    = MockEmployerData.getPaymentHistory(companyId);

    for (final s in _staffList) {
      _staffAttendance[s.id] =
          MockStaffData.getAttendanceHistory(s.id);
      _staffLeave[s.id] =
          MockStaffData.getLeaveRequests(s.id);
    }
    notifyListeners();
  }

  // ── Department management
  Future<void> addDepartment({
    required String name,
    String? description,
  }) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    _departments.add(DepartmentModel(
      id: _uuid.v4(),
      name: name,
      description: description,
      companyId: _companyId,
      createdAt: DateTime.now(),
    ));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteDepartment(String id) async {
    _departments.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  // ── Query messaging
  Future<void> sendQueryMessage({
    required String staffId,
    required String staffName,
    required QueryType type,
    required String subject,
    required String body,
    DateTime? relatedDate,
  }) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    _queryMessages.insert(0, QueryMessage(
      id: _uuid.v4(),
      staffId: staffId,
      staffName: staffName,
      employerId: 'employer_001',
      type: type,
      subject: subject,
      body: body,
      sentAt: DateTime.now(),
      status: QueryStatus.sent,
      relatedDate: relatedDate,
    ));
    _isLoading = false;
    notifyListeners();
  }

  // ── Payment management
  Future<void> recordPayment({
    required String staffId,
    required int payMonth,
    required int payYear,
    required List<PaymentBonus> bonuses,
    String? notes,
  }) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));

    final staff = _staffList.firstWhere((s) => s.id == staffId);
    final salary = staff.monthlySalary ?? 0;

    final deductions = [
      const PaymentDeduction(
          label: 'PAYE Tax', amount: 10, isPercentage: true),
      const PaymentDeduction(
          label: 'Pension (8%)', amount: 8, isPercentage: true),
      const PaymentDeduction(
          label: 'NHF', amount: 2.5, isPercentage: true),
    ];

    final gross = salary +
        bonuses.fold(0.0, (s, b) => s + b.amount);
    final totalDed = deductions.fold(
        0.0, (s, d) => s + d.computeFrom(gross));

    // Remove existing record for same period if any
    _payments.removeWhere((p) =>
        p.staffId == staffId &&
        p.payMonth == payMonth &&
        p.payYear == payYear);

    _payments.insert(0, MonthlyPayment(
      id: _uuid.v4(),
      staffId: staffId,
      staffName: staff.name,
      staffPosition: staff.position ?? '',
      staffDepartment: staff.department ?? '',
      employeeId: staff.employeeId ?? '',
      companyId: _companyId,
      payMonth: payMonth,
      payYear: payYear,
      basicSalary: salary,
      bonuses: bonuses,
      deductions: deductions,
      grossPay: gross,
      totalDeductions: totalDed,
      netPay: gross - totalDed,
      status: PaymentStatus.recorded,
      recordedAt: DateTime.now(),
      notes: notes,
    ));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markPaymentAsPaid(String paymentId) async {
    final idx = _payments.indexWhere((p) => p.id == paymentId);
    if (idx != -1) {
      _payments[idx] = _payments[idx].copyWith(
        status: PaymentStatus.paid,
        paidAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // ── Leave management
  void reviewLeave(String leaveId, LeaveStatus status,
      {String? note}) {
    for (final list in _staffLeave.values) {
      final idx = list.indexWhere((l) => l.id == leaveId);
      if (idx != -1) {
        list[idx] = list[idx].copyWith(
            status: status, reviewerNote: note);
        notifyListeners();
        return;
      }
    }
  }

  // ── Helpers
  AttendanceRecord? getTodayAttendance(String staffId) {
    final records = _staffAttendance[staffId];
    if (records == null || records.isEmpty) return null;
    final today = DateTime.now();
    try {
      return records.firstWhere((r) =>
          r.date.day == today.day &&
          r.date.month == today.month &&
          r.date.year == today.year);
    } catch (_) {
      return records.first;
    }
  }

  List<MonthlyPayment> getPaymentsForStaff(String staffId) =>
      _payments.where((p) => p.staffId == staffId).toList();

  List<MonthlyPayment> getPaymentsForMonth(
      int month, int year) =>
      _payments
          .where((p) => p.payMonth == month && p.payYear == year)
          .toList();

  /// Returns per-day attendance counts for the current month
  Map<String, Map<String, int>> getMonthlyAttendanceMatrix(
      int month, int year) {
    final Map<String, Map<String, int>> result = {};
    for (final staff in _staffList) {
      final records = _staffAttendance[staff.id] ?? [];
      int present = 0, late = 0, absent = 0, onLeave = 0;
      for (final r in records) {
        if (r.date.month != month || r.date.year != year) continue;
        if (r.date.weekday == DateTime.saturday ||
            r.date.weekday == DateTime.sunday) continue;
        switch (r.status) {
          case AttendanceStatus.present:
            present++;
            break;
          case AttendanceStatus.late:
            late++;
            break;
          case AttendanceStatus.absent:
            absent++;
            break;
          case AttendanceStatus.onLeave:
            onLeave++;
            break;
          default:
            break;
        }
      }
      result[staff.id] = {
        'present': present,
        'late': late,
        'absent': absent,
        'onLeave': onLeave,
      };
    }
    return result;
  }

  /// Returns hourly clock-in distribution across the week
  Map<String, List<double>> getWeeklyAttendanceDetail() {
    final now = DateTime.now();
    final weekStart =
        now.subtract(Duration(days: now.weekday - 1));
    final Map<String, List<double>> result = {};
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    for (int d = 0; d < 5; d++) {
      final day = weekStart.add(Duration(days: d));
      double presentCount   = 0;
      double lateCount      = 0;
      double absentCount    = 0;
      double avgClockInMins = 0;
      int    clockedInCount = 0;

      for (final staff in _staffList) {
        final records = _staffAttendance[staff.id] ?? [];
        try {
          final r = records.firstWhere((r) =>
              r.date.day == day.day &&
              r.date.month == day.month);
          if (r.clockInTime != null) {
            presentCount++;
            avgClockInMins += r.clockInTime!.hour * 60 +
                r.clockInTime!.minute;
            clockedInCount++;
            if (r.isLate) lateCount++;
          } else {
            absentCount++;
          }
        } catch (_) {
          absentCount++;
        }
      }

      result[days[d]] = [
        presentCount,
        lateCount,
        absentCount,
        clockedInCount > 0
            ? (avgClockInMins / clockedInCount)
            : 0,
      ];
    }
    return result;
  }

  double get totalMonthlyPayroll {
    final now = DateTime.now();
    return _payments
        .where((p) =>
            p.payMonth == now.month && p.payYear == now.year)
        .fold(0.0, (s, p) => s + p.netPay);
  }
}



// import 'package:flutter/foundation.dart';
// import '../../auth/data/mock_auth_data.dart';
// import '../../auth/data/models/user_model.dart';
// import '../../staff/data/models/attendance_model.dart';
// import '../../staff/data/models/payroll_model.dart';
// import '../../staff/data/mock_staff_data.dart';

// class EmployerProvider extends ChangeNotifier {
//   List<UserModel> _staffList = [];
//   Map<String, List<AttendanceRecord>> _staffAttendance = {};
//   Map<String, List<PayrollRecord>> _staffPayroll = {};
//   List<LeaveRequest> _allLeaveRequests = [];
//   bool _isLoading = false;

//   List<UserModel> get staffList => _staffList;
//   Map<String, List<AttendanceRecord>> get staffAttendance => _staffAttendance;
//   List<LeaveRequest> get allLeaveRequests => _allLeaveRequests;
//   Map<String, List<PayrollRecord>> get staffPayroll => _staffPayroll;
//   bool get isLoading => _isLoading;

//   // Dashboard summary
//   int get totalStaff => _staffList.length;
//   int get presentToday => _staffAttendance.values
//       .where((records) => records.isNotEmpty &&
//           records.first.date.day == DateTime.now().day &&
//           records.first.status == AttendanceStatus.present ||
//           records.first.status == AttendanceStatus.late)
//       .length;
//   int get pendingLeaves => _allLeaveRequests
//       .where((l) => l.status == LeaveStatus.pending).length;

//   void loadEmployerData() {
//     _staffList = MockAuthData.staffList;
//     for (final staff in _staffList) {
//       _staffAttendance[staff.id] = MockStaffData.getAttendanceHistory(staff.id);
//       _staffPayroll[staff.id] = MockStaffData.getPayrollHistory(staff.id);
//       _allLeaveRequests.addAll(
//         MockStaffData.getLeaveRequests(staff.id).map(
//           (l) => LeaveRequest(
//             id: '${l.id}_${staff.id}',
//             staffId: staff.id,
//             staffName: staff.name,
//             leaveType: l.leaveType,
//             startDate: l.startDate,
//             endDate: l.endDate,
//             reason: l.reason,
//             status: l.status,
//             requestedAt: l.requestedAt,
//           ),
//         ),
//       );
//     }
//     notifyListeners();
//   }

//   void reviewLeave(String leaveId, LeaveStatus status, {String? note}) {
//     final index = _allLeaveRequests.indexWhere((l) => l.id == leaveId);
//     if (index != -1) {
//       _allLeaveRequests[index] = _allLeaveRequests[index].copyWith(
//         status: status,
//         reviewerNote: note,
//       );
//       notifyListeners();
//     }
//   }

//   AttendanceRecord? getTodayAttendance(String staffId) {
//     final records = _staffAttendance[staffId];
//     if (records == null || records.isEmpty) return null;
//     return records.first;
//   }

//   Map<String, dynamic> getCompanyAnalytics() {
//     return {
//       'avgAttendanceRate': 91.5,
//       'avgPunctuality': 88.0,
//       'totalOvertimeHours': 67.0,
//       'monthlyPayroll': 4200000.0,
//       'weeklyPresent': [18, 20, 17, 19, 16],
//     };
//   }
// }