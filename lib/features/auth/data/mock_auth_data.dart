import 'package:flutter/material.dart';
import './models/user_model.dart';

class MockAuthData {
  static const company = CompanyModel(
    id: 'company_001',
    name: 'TechVentures Ltd.',
    address: '15 Marina Road, Victoria Island, Lagos',
    latitude: 6.4281,
    longitude: 3.4219,
    geofenceRadius: 200,
    workStartTime: TimeOfDay(hour: 8, minute: 0),
    workEndTime: TimeOfDay(hour: 17, minute: 0),
    breakDuration: Duration(hours: 1),
    logoUrl: '',
  );

  static final employer = UserModel(
    id: 'employer_001',
    name: 'Sarah Johnson',
    email: 'sarah@techventures.com',
    password: 'employer123',
    role: UserRole.employer,
    companyId: 'company_001',
    position: 'HR Manager',
    avatar: 'SJ',
  );

  static final List<UserModel> staffList = [
    UserModel(
      id: 'staff_001',
      name: 'Emeka Obi',
      email: 'emeka@techventures.com',
      password: 'staff123',
      role: UserRole.staff,
      companyId: 'company_001',
      position: 'Senior Developer',
      department: 'Engineering',
      hourlyRate: 5000,
      employeeId: 'EMP-001',
      avatar: 'EO',
    ),
    UserModel(
      id: 'staff_002',
      name: 'Amara Nwosu',
      email: 'amara@techventures.com',
      password: 'staff456',
      role: UserRole.staff,
      companyId: 'company_001',
      position: 'UI/UX Designer',
      department: 'Design',
      hourlyRate: 4500,
      employeeId: 'EMP-002',
      avatar: 'AN',
    ),
    UserModel(
      id: 'staff_003',
      name: 'Chidi Eze',
      email: 'chidi@techventures.com',
      password: 'staff789',
      role: UserRole.staff,
      companyId: 'company_001',
      position: 'Product Manager',
      department: 'Product',
      hourlyRate: 5500,
      employeeId: 'EMP-003',
      avatar: 'CE',
    ),
    UserModel(
      id: 'staff_004',
      name: 'Fatima Bello',
      email: 'fatima@techventures.com',
      password: 'staffabc',
      role: UserRole.staff,
      companyId: 'company_001',
      position: 'Data Analyst',
      department: 'Analytics',
      hourlyRate: 4800,
      employeeId: 'EMP-004',
      avatar: 'FB',
    ),
    UserModel(
      id: 'staff_005',
      name: 'Tunde Adeyemi',
      email: 'tunde@techventures.com',
      password: 'staffdef',
      role: UserRole.staff,
      companyId: 'company_001',
      position: 'Backend Developer',
      department: 'Engineering',
      hourlyRate: 4800,
      employeeId: 'EMP-005',
      avatar: 'TA',
    ),
  ];

  static UserModel? authenticate(String email, String password) {
    final allUsers = [employer, ...staffList];
    try {
      return allUsers.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }
}