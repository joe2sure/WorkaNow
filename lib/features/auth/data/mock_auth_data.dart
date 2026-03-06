import 'models/user_model.dart';

class MockAuthData {
  // ── Super Admin
  static final superAdmin = UserModel(
    id: 'superadmin_001',
    name: 'Chukwuemeka Okafor',
    email: 'admin@workanow.com',
    password: 'admin123',
    role: UserRole.superAdmin,
    avatar: 'CO',
    position: 'Platform Administrator',
  );

  // ── Companies
  static final List<CompanyModel> companies = [
    CompanyModel(
      id: 'company_001',
      name: 'TechVentures Ltd.',
      address: '15 Marina Road, Victoria Island, Lagos',
      latitude: 6.4281, longitude: 3.4219,
      geofenceRadius: 200,
      workStartTime: '08:00', workEndTime: '17:00',
      breakDurationMinutes: 60,
      industry: 'Technology',
      contactEmail: 'hr@techventures.com',
      contactPhone: '+234 801 234 5678',
      registrationNumber: 'RC-234789',
      status: CompanyStatus.active,
      registeredAt: DateTime(2024, 3, 12),
      staffCount: 5, plan: 'growth',
    ),
    CompanyModel(
      id: 'company_002',
      name: 'Zenith Finance Group',
      address: '42 Broad Street, Lagos Island, Lagos',
      latitude: 6.4531, longitude: 3.3958,
      geofenceRadius: 150,
      workStartTime: '08:30', workEndTime: '17:30',
      breakDurationMinutes: 45,
      industry: 'Financial Services',
      contactEmail: 'admin@zenithfg.com',
      contactPhone: '+234 802 345 6789',
      registrationNumber: 'RC-198234',
      status: CompanyStatus.active,
      registeredAt: DateTime(2024, 5, 20),
      staffCount: 18, plan: 'enterprise',
    ),
    CompanyModel(
      id: 'company_003',
      name: 'GreenLeaf Agro',
      address: 'Plot 7, Ring Road, Ibadan, Oyo State',
      latitude: 7.3775, longitude: 3.9470,
      geofenceRadius: 300,
      workStartTime: '07:00', workEndTime: '16:00',
      breakDurationMinutes: 60,
      industry: 'Agriculture',
      contactEmail: 'info@greenleafagro.com',
      contactPhone: '+234 803 456 7890',
      registrationNumber: 'RC-456102',
      status: CompanyStatus.pending,
      registeredAt: DateTime(2025, 1, 8),
      staffCount: 34, plan: 'growth',
    ),
    CompanyModel(
      id: 'company_004',
      name: 'MediCare Plus Hospital',
      address: '10 Hospital Road, Abuja, FCT',
      latitude: 9.0579, longitude: 7.4951,
      geofenceRadius: 250,
      workStartTime: '06:00', workEndTime: '18:00',
      breakDurationMinutes: 30,
      industry: 'Healthcare',
      contactEmail: 'admin@medicareplus.ng',
      contactPhone: '+234 804 567 8901',
      registrationNumber: 'RC-312890',
      status: CompanyStatus.active,
      registeredAt: DateTime(2023, 11, 3),
      staffCount: 62, plan: 'enterprise',
    ),
    CompanyModel(
      id: 'company_005',
      name: 'Sunrise Academy',
      address: '5 School Lane, Port Harcourt, Rivers State',
      latitude: 4.8156, longitude: 7.0498,
      geofenceRadius: 200,
      workStartTime: '07:30', workEndTime: '15:30',
      breakDurationMinutes: 60,
      industry: 'Education',
      contactEmail: 'admin@sunriseacademy.edu.ng',
      contactPhone: '+234 805 678 9012',
      registrationNumber: 'RC-567234',
      status: CompanyStatus.suspended,
      registeredAt: DateTime(2024, 8, 15),
      staffCount: 28, plan: 'starter',
    ),
  ];

  // ── Employer accounts (one per company)
  static final List<UserModel> employers = [
    UserModel(
      id: 'employer_001',
      name: 'Sarah Johnson',
      email: 'sarah@techventures.com',
      password: 'employer123',
      role: UserRole.employer,
      companyId: 'company_001',
      position: 'HR Manager',
      avatar: 'SJ',
    ),
    UserModel(
      id: 'employer_002',
      name: 'Babatunde Adekoya',
      email: 'baba@zenithfg.com',
      password: 'emp456',
      role: UserRole.employer,
      companyId: 'company_002',
      position: 'Operations Director',
      avatar: 'BA',
    ),
  ];

  // ── Staff accounts
  static final List<UserModel> staffList = [
    UserModel(
      id: 'staff_001', name: 'Emeka Obi',
      email: 'emeka@techventures.com', password: 'staff123',
      role: UserRole.staff, companyId: 'company_001',
      position: 'Senior Developer', department: 'Engineering',
      monthlySalary: 850000, employeeId: 'EMP-001', avatar: 'EO',
    ),
    UserModel(
      id: 'staff_002', name: 'Amara Nwosu',
      email: 'amara@techventures.com', password: 'staff456',
      role: UserRole.staff, companyId: 'company_001',
      position: 'UI/UX Designer', department: 'Design',
      monthlySalary: 720000, employeeId: 'EMP-002', avatar: 'AN',
    ),
    UserModel(
      id: 'staff_003', name: 'Chidi Eze',
      email: 'chidi@techventures.com', password: 'staff789',
      role: UserRole.staff, companyId: 'company_001',
      position: 'Product Manager', department: 'Product',
      monthlySalary: 950000, employeeId: 'EMP-003', avatar: 'CE',
    ),
    UserModel(
      id: 'staff_004', name: 'Fatima Bello',
      email: 'fatima@techventures.com', password: 'staffabc',
      role: UserRole.staff, companyId: 'company_001',
      position: 'Data Analyst', department: 'Analytics',
      monthlySalary: 780000, employeeId: 'EMP-004', avatar: 'FB',
    ),
    UserModel(
      id: 'staff_005', name: 'Tunde Adeyemi',
      email: 'tunde@techventures.com', password: 'staffdef',
      role: UserRole.staff, companyId: 'company_001',
      position: 'Backend Developer', department: 'Engineering',
      monthlySalary: 800000, employeeId: 'EMP-005', avatar: 'TA',
    ),
  ];

  static UserModel? authenticate(String email, String password) {
    final all = [superAdmin, ...employers, ...staffList];
    try {
      return all.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() &&
               u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  static CompanyModel? companyById(String id) {
    try {
      return companies.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}



// import 'package:flutter/material.dart';
// import './models/user_model.dart';

// class MockAuthData {
//   static const company = CompanyModel(
//     id: 'company_001',
//     name: 'TechVentures Ltd.',
//     address: '15 Marina Road, Victoria Island, Lagos',
//     latitude: 6.4281,
//     longitude: 3.4219,
//     geofenceRadius: 200,
//     workStartTime: TimeOfDay(hour: 8, minute: 0),
//     workEndTime: TimeOfDay(hour: 17, minute: 0),
//     breakDuration: Duration(hours: 1),
//     logoUrl: '',
//   );

//   static final employer = UserModel(
//     id: 'employer_001',
//     name: 'Sarah Johnson',
//     email: 'sarah@techventures.com',
//     password: 'employer123',
//     role: UserRole.employer,
//     companyId: 'company_001',
//     position: 'HR Manager',
//     avatar: 'SJ',
//   );

//   static final List<UserModel> staffList = [
//     UserModel(
//       id: 'staff_001',
//       name: 'Emeka Obi',
//       email: 'emeka@techventures.com',
//       password: 'staff123',
//       role: UserRole.staff,
//       companyId: 'company_001',
//       position: 'Senior Developer',
//       department: 'Engineering',
//       hourlyRate: 5000,
//       employeeId: 'EMP-001',
//       avatar: 'EO',
//     ),
//     UserModel(
//       id: 'staff_002',
//       name: 'Amara Nwosu',
//       email: 'amara@techventures.com',
//       password: 'staff456',
//       role: UserRole.staff,
//       companyId: 'company_001',
//       position: 'UI/UX Designer',
//       department: 'Design',
//       hourlyRate: 4500,
//       employeeId: 'EMP-002',
//       avatar: 'AN',
//     ),
//     UserModel(
//       id: 'staff_003',
//       name: 'Chidi Eze',
//       email: 'chidi@techventures.com',
//       password: 'staff789',
//       role: UserRole.staff,
//       companyId: 'company_001',
//       position: 'Product Manager',
//       department: 'Product',
//       hourlyRate: 5500,
//       employeeId: 'EMP-003',
//       avatar: 'CE',
//     ),
//     UserModel(
//       id: 'staff_004',
//       name: 'Fatima Bello',
//       email: 'fatima@techventures.com',
//       password: 'staffabc',
//       role: UserRole.staff,
//       companyId: 'company_001',
//       position: 'Data Analyst',
//       department: 'Analytics',
//       hourlyRate: 4800,
//       employeeId: 'EMP-004',
//       avatar: 'FB',
//     ),
//     UserModel(
//       id: 'staff_005',
//       name: 'Tunde Adeyemi',
//       email: 'tunde@techventures.com',
//       password: 'staffdef',
//       role: UserRole.staff,
//       companyId: 'company_001',
//       position: 'Backend Developer',
//       department: 'Engineering',
//       hourlyRate: 4800,
//       employeeId: 'EMP-005',
//       avatar: 'TA',
//     ),
//   ];

//   static UserModel? authenticate(String email, String password) {
//     final allUsers = [employer, ...staffList];
//     try {
//       return allUsers.firstWhere(
//         (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
//       );
//     } catch (_) {
//       return null;
//     }
//   }
// }