import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../auth/data/models/user_model.dart';
import '../../auth/data/mock_auth_data.dart';
import '../data/models/platform_stats_model.dart';
import '../mock_superadmin_data.dart';
// import '../data/mock_superadmin_data.dart';

class SuperAdminProvider extends ChangeNotifier {
  List<CompanyModel> _companies = [];
  PlatformStats?     _stats;
  List<ActivityLog>  _activityLog = [];
  bool   _isLoading = false;
  String _searchQuery = '';
  CompanyStatus? _statusFilter;

  final _uuid = const Uuid();

  // ── Getters
  List<CompanyModel> get companies => _filtered;
  PlatformStats?     get stats     => _stats;
  List<ActivityLog>  get activity  => _activityLog;
  bool   get isLoading    => _isLoading;
  String get searchQuery  => _searchQuery;
  CompanyStatus? get statusFilter => _statusFilter;

  List<CompanyModel> get _filtered {
    var list = [..._companies];
    if (_searchQuery.isNotEmpty) {
      list = list.where((c) =>
        c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        c.industry.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        c.address.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    if (_statusFilter != null) {
      list = list.where((c) => c.status == _statusFilter).toList();
    }
    return list;
  }

  void load() {
    _companies   = List.from(MockAuthData.companies);
    _stats       = MockSuperAdminData.platformStats;
    _activityLog = List.from(MockSuperAdminData.recentActivity);
    notifyListeners();
  }

  void setSearch(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void setStatusFilter(CompanyStatus? s) {
    _statusFilter = s;
    notifyListeners();
  }

  // ── Onboard new company
  Future<void> onboardCompany({
    required String name,
    required String address,
    required String industry,
    required String contactEmail,
    required String contactPhone,
    required String registrationNumber,
    required String plan,
    required String workStart,
    required String workEnd,
    required int breakMinutes,
    required double geofenceRadius,
    // Employer details
    required String employerName,
    required String employerEmail,
    required String employerPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    final companyId = _uuid.v4();
    final newCompany = CompanyModel(
      id: companyId,
      name: name,
      address: address,
      latitude: 6.5244,
      longitude: 3.3792,
      geofenceRadius: geofenceRadius,
      workStartTime: workStart,
      workEndTime: workEnd,
      breakDurationMinutes: breakMinutes,
      industry: industry,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      registrationNumber: registrationNumber,
      status: CompanyStatus.active,
      registeredAt: DateTime.now(),
      staffCount: 0,
      plan: plan,
    );

    _companies.insert(0, newCompany);
    _activityLog.insert(0, ActivityLog(
      id: _uuid.v4(),
      action: 'New company onboarded',
      actor: 'Super Admin',
      target: name,
      timestamp: DateTime.now(),
      type: 'company',
    ));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCompanyStatus(
      String companyId, CompanyStatus status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _companies.indexWhere((c) => c.id == companyId);
    if (idx != -1) {
      _companies[idx] = _companies[idx].copyWith(status: status);
      _activityLog.insert(0, ActivityLog(
        id: _uuid.v4(),
        action: 'Company status → ${status.name}',
        actor: 'Super Admin',
        target: _companies[idx].name,
        timestamp: DateTime.now(),
        type: 'company',
      ));
      notifyListeners();
    }
  }

  Future<void> updateCompanyPlan(
      String companyId, String plan) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _companies.indexWhere((c) => c.id == companyId);
    if (idx != -1) {
      _companies[idx] = _companies[idx].copyWith(plan: plan);
      notifyListeners();
    }
  }
}