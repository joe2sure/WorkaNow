import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/data/models/user_model.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/employer/presentation/screens/employer_dashboard.dart';
import '../features/staff/presentation/screens/staff_dashboard.dart';

class AppRouter {
  static GoRouter router(AuthProvider auth) {
    return GoRouter(
      refreshListenable: auth,
      redirect: (context, state) {
        if (!auth.isAuthenticated) return '/login';
        if (auth.isEmployer && state.fullPath == '/login') return '/employer';
        if (auth.isStaff && state.fullPath == '/login') return '/staff';
        return null;
      },
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/employer', builder: (_, __) => const EmployerDashboard()),
        GoRoute(path: '/staff', builder: (_, __) => const StaffDashboard()),
      ],
      initialLocation: '/login',
    );
  }
}