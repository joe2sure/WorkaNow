import 'package:equatable/equatable.dart';

enum AttendanceStatus { present, absent, late, halfDay, onLeave, holiday }
enum ClockStatus { notClockedIn, clockedIn, onBreak, clockedOut }

class AttendanceRecord extends Equatable {
  final String id;
  final String staffId;
  final DateTime date;
  final DateTime? clockInTime;
  final DateTime? clockOutTime;
  final List<BreakRecord> breaks;
  final AttendanceStatus status;
  final String? lateNote;
  final String? location;
  final double? latitude;
  final double? longitude;
  final bool isLocationVerified;

  const AttendanceRecord({
    required this.id,
    required this.staffId,
    required this.date,
    this.clockInTime,
    this.clockOutTime,
    this.breaks = const [],
    required this.status,
    this.lateNote,
    this.location,
    this.latitude,
    this.longitude,
    this.isLocationVerified = false,
  });

  Duration get totalWorkDuration {
    if (clockInTime == null || clockOutTime == null) return Duration.zero;
    final total = clockOutTime!.difference(clockInTime!);
    final breakTime = breaks.fold<Duration>(
      Duration.zero,
      (sum, b) => sum + b.duration,
    );
    return total - breakTime;
  }

  Duration get totalBreakDuration {
    return breaks.fold(Duration.zero, (sum, b) => sum + b.duration);
  }

  bool get isLate {
    if (clockInTime == null) return false;
    return clockInTime!.hour > 8 || (clockInTime!.hour == 8 && clockInTime!.minute > 10);
  }

  AttendanceRecord copyWith({
    DateTime? clockInTime,
    DateTime? clockOutTime,
    List<BreakRecord>? breaks,
    AttendanceStatus? status,
    String? lateNote,
    String? location,
    double? latitude,
    double? longitude,
    bool? isLocationVerified,
  }) {
    return AttendanceRecord(
      id: id,
      staffId: staffId,
      date: date,
      clockInTime: clockInTime ?? this.clockInTime,
      clockOutTime: clockOutTime ?? this.clockOutTime,
      breaks: breaks ?? this.breaks,
      status: status ?? this.status,
      lateNote: lateNote ?? this.lateNote,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isLocationVerified: isLocationVerified ?? this.isLocationVerified,
    );
  }

  @override
  List<Object?> get props => [id, staffId, date];
}

class BreakRecord extends Equatable {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final String? note;

  const BreakRecord({
    required this.id,
    required this.startTime,
    this.endTime,
    this.note,
  });

  Duration get duration {
    if (endTime == null) return Duration.zero;
    return endTime!.difference(startTime);
  }

  bool get isActive => endTime == null;

  BreakRecord copyWith({DateTime? endTime}) {
    return BreakRecord(
      id: id,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
      note: note,
    );
  }

  @override
  List<Object?> get props => [id];
}

class LeaveRequest extends Equatable {
  final String id;
  final String staffId;
  final String staffName;
  final String leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final LeaveStatus status;
  final DateTime requestedAt;
  final String? reviewerNote;

  const LeaveRequest({
    required this.id,
    required this.staffId,
    required this.staffName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.requestedAt,
    this.reviewerNote,
  });

  int get durationDays => endDate.difference(startDate).inDays + 1;

  LeaveRequest copyWith({LeaveStatus? status, String? reviewerNote}) {
    return LeaveRequest(
      id: id,
      staffId: staffId,
      staffName: staffName,
      leaveType: leaveType,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      status: status ?? this.status,
      requestedAt: requestedAt,
      reviewerNote: reviewerNote ?? this.reviewerNote,
    );
  }

  @override
  List<Object?> get props => [id];
}

enum LeaveStatus { pending, approved, rejected }