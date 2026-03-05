import 'package:flutter/foundation.dart';
import '../../auth/data/mock_auth_data.dart';
import '../../auth/data/models/user_model.dart';
import '../../staff/data/models/attendance_model.dart';
import '../../staff/data/models/payroll_model.dart';
import '../../staff/data/mock_staff_data.dart';

class EmployerProvider extends ChangeNotifier {
  List<UserModel> _staffList = [];
  Map<String, List<AttendanceRecord>> _staffAttendance = {};
  Map<String, List<PayrollRecord>> _staffPayroll = {};
  List<LeaveRequest> _allLeaveRequests = [];
  bool _isLoading = false;

  List<UserModel> get staffList => _staffList;
  Map<String, List<AttendanceRecord>> get staffAttendance => _staffAttendance;
  List<LeaveRequest> get allLeaveRequests => _allLeaveRequests;
  Map<String, List<PayrollRecord>> get staffPayroll => _staffPayroll;
  bool get isLoading => _isLoading;

  // Dashboard summary
  int get totalStaff => _staffList.length;
  int get presentToday => _staffAttendance.values
      .where((records) => records.isNotEmpty &&
          records.first.date.day == DateTime.now().day &&
          records.first.status == AttendanceStatus.present ||
          records.first.status == AttendanceStatus.late)
      .length;
  int get pendingLeaves => _allLeaveRequests
      .where((l) => l.status == LeaveStatus.pending).length;

  void loadEmployerData() {
    _staffList = MockAuthData.staffList;
    for (final staff in _staffList) {
      _staffAttendance[staff.id] = MockStaffData.getAttendanceHistory(staff.id);
      _staffPayroll[staff.id] = MockStaffData.getPayrollHistory(staff.id);
      _allLeaveRequests.addAll(
        MockStaffData.getLeaveRequests(staff.id).map(
          (l) => LeaveRequest(
            id: '${l.id}_${staff.id}',
            staffId: staff.id,
            staffName: staff.name,
            leaveType: l.leaveType,
            startDate: l.startDate,
            endDate: l.endDate,
            reason: l.reason,
            status: l.status,
            requestedAt: l.requestedAt,
          ),
        ),
      );
    }
    notifyListeners();
  }

  void reviewLeave(String leaveId, LeaveStatus status, {String? note}) {
    final index = _allLeaveRequests.indexWhere((l) => l.id == leaveId);
    if (index != -1) {
      _allLeaveRequests[index] = _allLeaveRequests[index].copyWith(
        status: status,
        reviewerNote: note,
      );
      notifyListeners();
    }
  }

  AttendanceRecord? getTodayAttendance(String staffId) {
    final records = _staffAttendance[staffId];
    if (records == null || records.isEmpty) return null;
    return records.first;
  }

  Map<String, dynamic> getCompanyAnalytics() {
    return {
      'avgAttendanceRate': 91.5,
      'avgPunctuality': 88.0,
      'totalOvertimeHours': 67.0,
      'monthlyPayroll': 4200000.0,
      'weeklyPresent': [18, 20, 17, 19, 16],
    };
  }
}