import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/super_admin_provider.dart';
import '../../../ai/providers/ai_provider.dart';
import 'sa_activity_tab.dart';
import 'sa_companies_tab.dart';
import 'sa_onboard_tab.dart';
import 'sa_overview_tab.dart';
// import 'sa_overview_tab.dart';
// import 'sa_companies_tab.dart';
// import 'sa_onboard_tab.dart';
// import 'sa_activity_tab.dart';

class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  State<SuperAdminDashboard> createState() =>
      _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SuperAdminProvider>().load();
      context.read<AiProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final tabs = [
      const SaOverviewTab(),
      const SaCompaniesTab(),
      const SaOnboardTab(),
      const SaActivityTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: tabs[_tab],
      bottomNavigationBar: _BottomNav(
        selected: _tab,
        onTap: (i) => setState(() => _tab = i),
        onLogout: () => auth.logout(),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  final VoidCallback onLogout;

  const _BottomNav({
    required this.selected,
    required this.onTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  label: 'Overview',
                  index: 0, selected: selected, onTap: onTap),
              _NavItem(icon: Icons.business_outlined,
                  activeIcon: Icons.business,
                  label: 'Companies',
                  index: 1, selected: selected, onTap: onTap),
              _NavItem(icon: Icons.add_business_outlined,
                  activeIcon: Icons.add_business,
                  label: 'Onboard',
                  index: 2, selected: selected, onTap: onTap),
              _NavItem(icon: Icons.history_outlined,
                  activeIcon: Icons.history,
                  label: 'Activity',
                  index: 3, selected: selected, onTap: onTap),
              // Logout
              Expanded(
                child: GestureDetector(
                  onTap: onLogout,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.logout, size: 22,
                          color: AppColors.textTertiary),
                      SizedBox(height: 3),
                      Text('Logout',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textTertiary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int selected;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon, required this.activeIcon,
    required this.label, required this.index,
    required this.selected, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = selected == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (active)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(activeIcon,
                      size: 20, color: AppColors.primaryAccent),
                )
              else
                Icon(icon, size: 22, color: AppColors.textTertiary),
              const SizedBox(height: 3),
              Text(label,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: active
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: active
                          ? AppColors.primaryAccent
                          : AppColors.textTertiary)),
            ],
          ),
        ),
      ),
    );
  }
}