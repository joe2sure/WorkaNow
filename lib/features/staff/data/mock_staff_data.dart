import 'models/attendance_model.dart';
import 'models/payroll_model.dart';

class MockStaffData {
  static List<AttendanceRecord> getAttendanceHistory(String staffId) {
    final now = DateTime.now();
    return List.generate(20, (i) {
      final date = now.subtract(Duration(days: i + 1));
      if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
        return AttendanceRecord(
          id: 'att_${staffId}_$i',
          staffId: staffId,
          date: date,
          status: AttendanceStatus.holiday,
        );
      }

      final isLate = i % 5 == 0;
      final clockIn = DateTime(
        date.year, date.month, date.day,
        isLate ? 9 : 8, isLate ? (i % 30) : (i % 15),
      );
      final clockOut = DateTime(date.year, date.month, date.day, 17, 30);
      
      return AttendanceRecord(
        id: 'att_${staffId}_$i',
        staffId: staffId,
        date: date,
        clockInTime: clockIn,
        clockOutTime: clockOut,
        status: isLate ? AttendanceStatus.late : AttendanceStatus.present,
        isLocationVerified: true,
        location: '15 Marina Road, Victoria Island, Lagos',
        latitude: 6.4281,
        longitude: 3.4219,
        lateNote: isLate ? 'Traffic congestion on Third Mainland Bridge' : null,
        breaks: [
          BreakRecord(
            id: 'break_${staffId}_$i',
            startTime: DateTime(date.year, date.month, date.day, 12, 0),
            endTime: DateTime(date.year, date.month, date.day, 13, 0),
          ),
        ],
      );
    });
  }

  static List<LeaveRequest> getLeaveRequests(String staffId) {
    return [
      LeaveRequest(
        id: 'leave_001',
        staffId: staffId,
        staffName: 'Emeka Obi',
        leaveType: 'Annual Leave',
        startDate: DateTime.now().add(const Duration(days: 14)),
        endDate: DateTime.now().add(const Duration(days: 21)),
        reason: 'Family vacation and personal recharge time.',
        status: LeaveStatus.pending,
        requestedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      LeaveRequest(
        id: 'leave_002',
        staffId: staffId,
        staffName: 'Emeka Obi',
        leaveType: 'Sick Leave',
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().subtract(const Duration(days: 28)),
        reason: 'Malaria treatment and recovery.',
        status: LeaveStatus.approved,
        requestedAt: DateTime.now().subtract(const Duration(days: 32)),
        reviewerNote: 'Get well soon. Approved.',
      ),
    ];
  }

  static List<PayrollRecord> getPayrollHistory(String staffId) {
    final now = DateTime.now();
    return List.generate(6, (i) {
      final month = DateTime(now.year, now.month - i, 1);
      final endOfMonth = DateTime(now.year, now.month - i + 1, 0);
      const hoursWorked = 168.5;
      const overtime = 8.0;
      const hourlyRate = 5000.0;
      final gross = (hoursWorked * hourlyRate) + (overtime * hourlyRate * 1.5);
      final deductions = gross * 0.15;
      return PayrollRecord(
        id: 'pay_${staffId}_$i',
        staffId: staffId,
        staffName: 'Emeka Obi',
        periodStart: month,
        periodEnd: endOfMonth,
        hourlyRate: hourlyRate,
        totalHoursWorked: hoursWorked,
        overtimeHours: overtime,
        grossPay: gross,
        deductions: deductions,
        netPay: gross - deductions,
        status: i == 0 ? PayrollStatus.pending : PayrollStatus.paid,
        deductionDetails: const [
          PayrollDeduction(name: 'Tax (PAYE)', amount: 10, isPercentage: true),
          PayrollDeduction(name: 'Pension', amount: 5, isPercentage: true),
        ],
        bonuses: i == 1
            ? const [PayrollBonus(reason: 'Performance Bonus', amount: 50000)]
            : [],
      );
    });
  }

  static Map<String, dynamic> getStaffAnalytics(String staffId) {
    return {
      'punctualityScore': 87,
      'attendanceRate': 94,
      'avgWorkHours': 8.6,
      'overtimeHours': 12.5,
      'lateCount': 2,
      'presentDays': 18,
      'absentDays': 1,
      'leaveDays': 2,
      'weeklyHours': [8.5, 9.0, 8.0, 9.5, 7.5],
    };
  }
}