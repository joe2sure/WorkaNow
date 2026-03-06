import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/employer/providers/employer_provider.dart';
import 'features/staff/providers/staff_provider.dart';
import 'features/ai/providers/ai_provider.dart';
import 'features/superadmin/providers/super_admin_provider.dart';
import 'navigation/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WorkaNowApp());
}

class WorkaNowApp extends StatelessWidget {
  const WorkaNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EmployerProvider()),
        ChangeNotifierProvider(create: (_) => StaffProvider()),
        ChangeNotifierProvider(create: (_) => AiProvider()),
        ChangeNotifierProvider(create: (_) => SuperAdminProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp.router(
            title: 'WorkaNow',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.router(auth),
          );
        },
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'core/theme/app_theme.dart';
// import 'features/auth/providers/auth_provider.dart';
// import 'features/employer/providers/employer_provider.dart';
// import 'features/staff/providers/staff_provider.dart';
// import 'features/ai/providers/ai_provider.dart';
// import 'navigation/app_router.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const WorkaNowApp());
// }

// class WorkaNowApp extends StatelessWidget {
//   const WorkaNowApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => EmployerProvider()),
//         ChangeNotifierProvider(create: (_) => StaffProvider()),
//         ChangeNotifierProvider(create: (_) => AiProvider()),
//       ],
//       child: Consumer<AuthProvider>(
//         builder: (context, auth, _) {
//           return MaterialApp.router(
//             title: 'WorkaNow',
//             debugShowCheckedModeBanner: false,
//             theme: AppTheme.lightTheme,
//             routerConfig: AppRouter.router(auth),
//           );
//         },
//       ),
//     );
//   }
// }