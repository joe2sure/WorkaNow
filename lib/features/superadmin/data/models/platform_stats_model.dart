class PlatformStats {
  final int totalCompanies;
  final int activeCompanies;
  final int suspendedCompanies;
  final int pendingCompanies;
  final int totalStaff;
  final int totalEmployers;
  final double monthlyRevenue;
  final double revenueGrowth; // percentage
  final List<MonthlyRevenue> revenueHistory;
  final List<CompanyGrowth>  companyGrowth;

  const PlatformStats({
    required this.totalCompanies,
    required this.activeCompanies,
    required this.suspendedCompanies,
    required this.pendingCompanies,
    required this.totalStaff,
    required this.totalEmployers,
    required this.monthlyRevenue,
    required this.revenueGrowth,
    required this.revenueHistory,
    required this.companyGrowth,
  });
}

class MonthlyRevenue {
  final String month;
  final double amount;
  const MonthlyRevenue(this.month, this.amount);
}

class CompanyGrowth {
  final String month;
  final int count;
  const CompanyGrowth(this.month, this.count);
}

class ActivityLog {
  final String id;
  final String action;
  final String actor;
  final String target;
  final DateTime timestamp;
  final String type; // 'company' | 'user' | 'billing' | 'system'

  const ActivityLog({
    required this.id,
    required this.action,
    required this.actor,
    required this.target,
    required this.timestamp,
    required this.type,
  });
}