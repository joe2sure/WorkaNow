import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../data/models/attendance_model.dart';
import '../data/models/payroll_model.dart';
import '../data/mock_staff_data.dart';

class StaffProvider extends ChangeNotifier {
  AttendanceRecord? _todayRecord;
  ClockStatus _clockStatus = ClockStatus.notClockedIn;
  List<AttendanceRecord> _attendanceHistory = [];
  List<LeaveRequest> _leaveRequests = [];
  List<PayrollRecord> _payrollHistory = [];
  Map<String, dynamic> _analytics = {};
  bool _isLocationVerified = false;
  String? _currentLocation;
  double? _currentLatitude;
  double? _currentLongitude;
  BreakRecord? _activeBreak;
  final _uuid = const Uuid();

  // Getters
  AttendanceRecord? get todayRecord => _todayRecord;
  ClockStatus get clockStatus => _clockStatus;
  List<AttendanceRecord> get attendanceHistory => _attendanceHistory;
  List<LeaveRequest> get leaveRequests => _leaveRequests;
  List<PayrollRecord> get payrollHistory => _payrollHistory;
  Map<String, dynamic> get analytics => _analytics;
  bool get isLocationVerified => _isLocationVerified;
  bool get isClockedIn => _clockStatus == ClockStatus.clockedIn;
  bool get isOnBreak => _clockStatus == ClockStatus.onBreak;
  bool get isClockedOut => _clockStatus == ClockStatus.clockedOut;
  String? get currentLocation => _currentLocation;
  BreakRecord? get activeBreak => _activeBreak;

  void loadStaffData(String staffId) {
    _attendanceHistory = MockStaffData.getAttendanceHistory(staffId);
    _leaveRequests = MockStaffData.getLeaveRequests(staffId);
    _payrollHistory = MockStaffData.getPayrollHistory(staffId);
    _analytics = MockStaffData.getStaffAnalytics(staffId);
    notifyListeners();
  }

  Future<void> verifyLocation(double lat, double lng, String address) async {
    await Future.delayed(const Duration(seconds: 1));
    // Check if within geofence of company (6.4281, 3.4219) within 200m
    // For demo, we simulate success
    _isLocationVerified = true;
    _currentLatitude = lat;
    _currentLongitude = lng;
    _currentLocation = address;
    notifyListeners();
  }

  Future<void> clockIn({
    required String staffId,
    required String location,
    required double lat,
    required double lng,
    String? lateNote,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final now = DateTime.now();
    _todayRecord = AttendanceRecord(
      id: _uuid.v4(),
      staffId: staffId,
      date: now,
      clockInTime: now,
      status: _isLate(now) ? AttendanceStatus.late : AttendanceStatus.present,
      location: location,
      latitude: lat,
      longitude: lng,
      isLocationVerified: true,
      lateNote: lateNote,
    );
    _clockStatus = ClockStatus.clockedIn;
    _currentLocation = location;
    notifyListeners();
  }

  Future<void> clockOut() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (_todayRecord == null) return;
    _todayRecord = _todayRecord!.copyWith(
      clockOutTime: DateTime.now(),
      status: _todayRecord!.status,
    );
    _clockStatus = ClockStatus.clockedOut;
    _attendanceHistory.insert(0, _todayRecord!);
    notifyListeners();
  }

  Future<void> startBreak({String? note}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _activeBreak = BreakRecord(
      id: _uuid.v4(),
      startTime: DateTime.now(),
      note: note,
    );
    _clockStatus = ClockStatus.onBreak;
    notifyListeners();
  }

  Future<void> endBreak() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_activeBreak == null || _todayRecord == null) return;
    final ended = _activeBreak!.copyWith(endTime: DateTime.now());
    final breaks = [..._todayRecord!.breaks, ended];
    _todayRecord = _todayRecord!.copyWith(breaks: breaks);
    _activeBreak = null;
    _clockStatus = ClockStatus.clockedIn;
    notifyListeners();
  }

  Future<void> submitLeaveRequest({
    required String staffId,
    required String staffName,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final request = LeaveRequest(
      id: _uuid.v4(),
      staffId: staffId,
      staffName: staffName,
      leaveType: leaveType,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      status: LeaveStatus.pending,
      requestedAt: DateTime.now(),
    );
    _leaveRequests.insert(0, request);
    notifyListeners();
  }

  bool _isLate(DateTime time) =>
      time.hour > 8 || (time.hour == 8 && time.minute > 10);
}