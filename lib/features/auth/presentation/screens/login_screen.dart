import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure       = true;
  String _demoFill    = '';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _fill(String role) {
    setState(() => _demoFill = role);
    if (role == 'employer') {
      _emailCtrl.text    = 'sarah@techventures.com';
      _passwordCtrl.text = 'employer123';
    } else if (role == 'staff') {
      _emailCtrl.text    = 'emeka@techventures.com';
      _passwordCtrl.text = 'staff123';
    } else {
      _emailCtrl.text    = 'admin@workanow.com';
      _passwordCtrl.text = 'admin123';
    }
  }

  Future<void> _login() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(
        _emailCtrl.text.trim(), _passwordCtrl.text.trim());
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Top brand panel
              Container(
                width: double.infinity,
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(32, 48, 32, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.25)),
                          ),
                          child: const Icon(
                              Icons.access_time_filled_rounded,
                              color: Colors.white,
                              size: 24),
                        ),
                        const SizedBox(width: 12),
                        Text('WorkaNow',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            )),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text('Welcome back',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                    const SizedBox(height: 4),
                    Text('Sign in to your workspace',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textOnDarkMuted,
                        )),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              // ── Form card
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email
                    const Text('Email address',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'you@company.com',
                        prefixIcon:
                            Icon(Icons.mail_outline, size: 18),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Password
                    const Text('Password',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        prefixIcon: const Icon(
                            Icons.lock_outline, size: 18),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 18,
                            color: AppColors.textTertiary,
                          ),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Forgot password?'),
                      ),
                    ),

                    if (auth.error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.error.withOpacity(0.3)),
                        ),
                        child: Row(children: [
                          const Icon(Icons.error_outline,
                              color: AppColors.error, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(auth.error!,
                                  style: const TextStyle(
                                      color: AppColors.error,
                                      fontSize: 12))),
                        ]),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Sign in button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: auth.isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: auth.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2))
                            : const Text('Sign In',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                      ),
                    ),

                    const SizedBox(height: 32),
                    const _Divider(label: 'Quick demo access'),
                    const SizedBox(height: 16),

                    // Demo tiles
                    Row(children: [
                      _DemoTile(
                        label: 'Super Admin',
                        icon: Icons.admin_panel_settings_outlined,
                        selected: _demoFill == 'admin',
                        onTap: () => _fill('admin'),
                      ),
                      const SizedBox(width: 8),
                      _DemoTile(
                        label: 'Employer',
                        icon: Icons.business_outlined,
                        selected: _demoFill == 'employer',
                        onTap: () => _fill('employer'),
                      ),
                      const SizedBox(width: 8),
                      _DemoTile(
                        label: 'Staff',
                        icon: Icons.person_outline,
                        selected: _demoFill == 'staff',
                        onTap: () => _fill('staff'),
                      ),
                    ]),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final String label;
  const _Divider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Expanded(child: Divider(color: AppColors.divider)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textTertiary)),
      ),
      const Expanded(child: Divider(color: AppColors.divider)),
    ]);
  }
}

class _DemoTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _DemoTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryLight
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? AppColors.primaryAccent
                  : AppColors.outline,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(children: [
            Icon(icon,
                size: 20,
                color: selected
                    ? AppColors.primaryAccent
                    : AppColors.textSecondary),
            const SizedBox(height: 5),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? AppColors.primaryAccent
                        : AppColors.textSecondary)),
          ]),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/widgets/custom_button.dart';
// import '../../providers/auth_provider.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _rememberMe = false;
//   String _selectedDemo = '';

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _fillDemo(String type) {
//     setState(() => _selectedDemo = type);
//     if (type == 'employer') {
//       _emailController.text = 'sarah@techventures.com';
//       _passwordController.text = 'employer123';
//     } else {
//       _emailController.text = 'emeka@techventures.com';
//       _passwordController.text = 'staff123';
//     }
//   }

//   Future<void> _login() async {
//     final auth = context.read<AuthProvider>();
//     final success = await auth.login(
//       _emailController.text.trim(),
//       _passwordController.text.trim(),
//     );
//     if (!success && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(auth.error ?? 'Login failed'),
//           backgroundColor: AppColors.error,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF0D47A1), Color(0xFF1A73E8), Color(0xFF42A5F5)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 40),
//                 // Logo & Brand
//                 Center(
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 80,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               blurRadius: 20,
//                               offset: const Offset(0, 8),
//                             ),
//                           ],
//                         ),
//                         child: const Icon(
//                           Icons.access_time_rounded,
//                           size: 44,
//                           color: AppColors.primary,
//                         ),
//                       ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'WorkaNow',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 32,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 1.2,
//                         ),
//                       ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
//                       const Text(
//                         'Smart Workforce Management',
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ).animate().fadeIn(delay: 300.ms),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 40),

//                 // Login Card
//                 Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 30,
//                         offset: const Offset(0, 10),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Welcome back 👋',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.onSurface,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       const Text(
//                         'Sign in to your account',
//                         style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
//                       ),
//                       const SizedBox(height: 24),

//                       // Email
//                       TextField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: const InputDecoration(
//                           labelText: 'Email Address',
//                           prefixIcon: Icon(Icons.email_outlined),
//                           hintText: 'Enter your email',
//                         ),
//                       ),
//                       const SizedBox(height: 16),

//                       // Password
//                       TextField(
//                         controller: _passwordController,
//                         obscureText: _obscurePassword,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           prefixIcon: const Icon(Icons.lock_outlined),
//                           hintText: 'Enter your password',
//                           suffixIcon: IconButton(
//                             onPressed: () =>
//                                 setState(() => _obscurePassword = !_obscurePassword),
//                             icon: Icon(
//                               _obscurePassword
//                                   ? Icons.visibility_outlined
//                                   : Icons.visibility_off_outlined,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       // Remember me
//                       Row(
//                         children: [
//                           Checkbox(
//                             value: _rememberMe,
//                             onChanged: (v) => setState(() => _rememberMe = v ?? false),
//                             activeColor: AppColors.primary,
//                           ),
//                           const Text('Remember me', style: TextStyle(fontSize: 14)),
//                           const Spacer(),
//                           TextButton(
//                             onPressed: () {},
//                             child: const Text('Forgot Password?'),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),

//                       if (auth.error != null) ...[
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: AppColors.errorLight,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(Icons.error_outline,
//                                   color: AppColors.error, size: 18),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   auth.error!,
//                                   style: const TextStyle(
//                                       color: AppColors.error, fontSize: 13),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                       ],

//                       // Login Button
//                       GradientButton(
//                         label: 'Sign In',
//                         onPressed: _login,
//                         icon: auth.isLoading
//                             ? const SizedBox(
//                                 width: 18,
//                                 height: 18,
//                                 child: CircularProgressIndicator(
//                                     color: Colors.white, strokeWidth: 2))
//                             : const Icon(Icons.arrow_forward, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),

//                 const SizedBox(height: 24),

//                 // Demo Access
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Colors.white30),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         '🎯 Quick Demo Access',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _DemoChip(
//                               label: '👔 Employer',
//                               subtitle: 'sarah@techventures.com',
//                               isSelected: _selectedDemo == 'employer',
//                               onTap: () => _fillDemo('employer'),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: _DemoChip(
//                               label: '👤 Staff',
//                               subtitle: 'emeka@techventures.com',
//                               isSelected: _selectedDemo == 'staff',
//                               onTap: () => _fillDemo('staff'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ).animate().fadeIn(delay: 600.ms),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _DemoChip extends StatelessWidget {
//   final String label;
//   final String subtitle;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const _DemoChip({
//     required this.label,
//     required this.subtitle,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//               color: isSelected ? AppColors.primary : Colors.white30),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: isSelected ? AppColors.primary : Colors.white,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               subtitle,
//               style: TextStyle(
//                 fontSize: 10,
//                 color: isSelected ? AppColors.textSecondary : Colors.white60,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }