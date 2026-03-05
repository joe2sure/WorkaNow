import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum UserRole { employer, staff }

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String companyId;
  final String? avatar;
  final String? position;
  final String? department;
  final double? hourlyRate;
  final String? employeeId;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.companyId,
    this.avatar,
    this.position,
    this.department,
    this.hourlyRate,
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
  final double geofenceRadius; // in meters
  final TimeOfDay workStartTime;
  final TimeOfDay workEndTime;
  final Duration breakDuration;
  final String logoUrl;

  const CompanyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.geofenceRadius,
    required this.workStartTime,
    required this.workEndTime,
    required this.breakDuration,
    required this.logoUrl,
  });

  @override
  List<Object?> get props => [id];
}