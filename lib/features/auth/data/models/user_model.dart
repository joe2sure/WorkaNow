import 'package:equatable/equatable.dart';

enum UserRole { superAdmin, employer, staff }

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String? companyId;
  final String? avatar;
  final String? position;
  final String? department;
  final double? monthlySalary;
  final String? employeeId;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.companyId,
    this.avatar,
    this.position,
    this.department,
    this.monthlySalary,
    this.employeeId,
  });

  @override
  List<Object?> get props => [id, email, role];
}

class CompanyModel extends Equatable {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double geofenceRadius;
  final String workStartTime;
  final String workEndTime;
  final int breakDurationMinutes;
  final String industry;
  final String contactEmail;
  final String contactPhone;
  final String registrationNumber;
  final CompanyStatus status;
  final DateTime registeredAt;
  final int staffCount;
  final String plan; // 'starter' | 'growth' | 'enterprise'

  const CompanyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.geofenceRadius,
    required this.workStartTime,
    required this.workEndTime,
    required this.breakDurationMinutes,
    required this.industry,
    required this.contactEmail,
    required this.contactPhone,
    required this.registrationNumber,
    required this.status,
    required this.registeredAt,
    required this.staffCount,
    required this.plan,
  });

  CompanyModel copyWith({CompanyStatus? status, String? plan}) {
    return CompanyModel(
      id: id, name: name, address: address,
      latitude: latitude, longitude: longitude,
      geofenceRadius: geofenceRadius,
      workStartTime: workStartTime, workEndTime: workEndTime,
      breakDurationMinutes: breakDurationMinutes,
      industry: industry, contactEmail: contactEmail,
      contactPhone: contactPhone,
      registrationNumber: registrationNumber,
      status: status ?? this.status,
      registeredAt: registeredAt,
      staffCount: staffCount,
      plan: plan ?? this.plan,
    );
  }

  @override
  List<Object?> get props => [id];
}

enum CompanyStatus { active, suspended, pending, inactive }


// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

// enum UserRole { employer, staff }

// class UserModel extends Equatable {
//   final String id;
//   final String name;
//   final String email;
//   final String password;
//   final UserRole role;
//   final String companyId;
//   final String? avatar;
//   final String? position;
//   final String? department;
//   final double? hourlyRate;
//   final String? employeeId;

//   const UserModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.password,
//     required this.role,
//     required this.companyId,
//     this.avatar,
//     this.position,
//     this.department,
//     this.hourlyRate,
//     this.employeeId,
//   });

//   @override
//   List<Object?> get props => [id, email, role];
// }

// class CompanyModel extends Equatable {
//   final String id;
//   final String name;
//   final String address;
//   final double latitude;
//   final double longitude;
//   final double geofenceRadius; // in meters
//   final TimeOfDay workStartTime;
//   final TimeOfDay workEndTime;
//   final Duration breakDuration;
//   final String logoUrl;

//   const CompanyModel({
//     required this.id,
//     required this.name,
//     required this.address,
//     required this.latitude,
//     required this.longitude,
//     required this.geofenceRadius,
//     required this.workStartTime,
//     required this.workEndTime,
//     required this.breakDuration,
//     required this.logoUrl,
//   });

//   @override
//   List<Object?> get props => [id];
// }