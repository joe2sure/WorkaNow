// import 'models/platform_stats_model.dart';
// import '../../auth/data/models/user_model.dart';

import 'data/models/platform_stats_model.dart';

class MockSuperAdminData {
  static PlatformStats get platformStats => const PlatformStats(
    totalCompanies:     5,
    activeCompanies:    3,
    suspendedCompanies: 1,
    pendingCompanies:   1,
    totalStaff:         147,
    totalEmployers:     5,
    monthlyRevenue:     2_850_000,
    revenueGrowth:      18.4,
    revenueHistory: [
      MonthlyRevenue('Oct', 1_800_000),
      MonthlyRevenue('Nov', 2_100_000),
      MonthlyRevenue('Dec', 2_050_000),
      MonthlyRevenue('Jan', 2_400_000),
      MonthlyRevenue('Feb', 2_610_000),
      MonthlyRevenue('Mar', 2_850_000),
    ],
    companyGrowth: [
      CompanyGrowth('Oct', 2),
      CompanyGrowth('Nov', 2),
      CompanyGrowth('Dec', 3),
      CompanyGrowth('Jan', 3),
      CompanyGrowth('Feb', 4),
      CompanyGrowth('Mar', 5),
    ],
  );

  static List<ActivityLog> get recentActivity => [
    ActivityLog(
      id: 'log_001',
      action: 'Company approved',
      actor: 'Super Admin',
      target: 'MediCare Plus Hospital',
      timestamp: DateTime.now().subtract(const Duration(minutes: 14)),
      type: 'company',
    ),
    ActivityLog(
      id: 'log_002',
      action: 'New company registration',
      actor: 'System',
      target: 'Sunrise Academy',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'company',
    ),
    ActivityLog(
      id: 'log_003',
      action: 'Plan upgraded',
      actor: 'Babatunde Adekoya',
      target: 'Zenith Finance Group → Enterprise',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: 'billing',
    ),
    ActivityLog(
      id: 'log_004',
      action: 'Company suspended',
      actor: 'Super Admin',
      target: 'Sunrise Academy',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: 'company',
    ),
    ActivityLog(
      id: 'log_005',
      action: 'Employer account created',
      actor: 'Super Admin',
      target: 'Sarah Johnson — TechVentures Ltd.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: 'user',
    ),
    ActivityLog(
      id: 'log_006',
      action: 'Geofence radius updated',
      actor: 'Sarah Johnson',
      target: 'TechVentures Ltd. — 200m → 250m',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      type: 'system',
    ),
  ];

  static Map<String, List<int>> get planDistribution => {
    'starter':    [1],
    'growth':     [2],
    'enterprise': [2],
  };
}