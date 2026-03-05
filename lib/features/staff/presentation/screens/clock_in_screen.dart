import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/staff_provider.dart';

class ClockInScreen extends StatefulWidget {
  const ClockInScreen({super.key});

  @override
  State<ClockInScreen> createState() => _ClockInScreenState();
}

class _ClockInScreenState extends State<ClockInScreen> {
  bool _isVerifyingLocation = false;
  bool _locationVerified = false;
  String _selectedLocation = '15 Marina Road, Victoria Island, Lagos';
  final _locationController = TextEditingController();
  final _lateNoteController = TextEditingController();
  bool _isLate = false;
  bool _isClockinIn = false;

  // Map controller for OpenStreetMap
  final MapController _mapController = MapController();
  
  // Lagos coordinates (Victoria Island area)
  static const LatLng _lagosLocation = LatLng(6.4281, 3.4219);
  LatLng _currentMapCenter = _lagosLocation;

  final List<String> _recentLocations = [
    '15 Marina Road, Victoria Island, Lagos',
    'TechVentures HQ, Eko Atlantic, Lagos',
    '23 Broad Street, Lagos Island',
  ];

  @override
  void initState() {
    super.initState();
    _isLate = DateTime.now().hour > 8 ||
        (DateTime.now().hour == 8 && DateTime.now().minute > 10);
    _simulateLocationVerification();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _locationController.dispose();
    _lateNoteController.dispose();
    super.dispose();
  }

  Future<void> _simulateLocationVerification() async {
    setState(() => _isVerifyingLocation = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isVerifyingLocation = false;
      _locationVerified = true;
    });
    // Verify with provider
    await context.read<StaffProvider>().verifyLocation(
          _currentMapCenter.latitude,
          _currentMapCenter.longitude,
          _selectedLocation,
        );
  }

  Future<void> _clockIn() async {
    final auth = context.read<AuthProvider>();
    final staff = context.read<StaffProvider>();

    setState(() => _isClockinIn = true);
    await staff.clockIn(
      staffId: auth.currentUser!.id,
      location: _selectedLocation,
      lat: _currentMapCenter.latitude,
      lng: _currentMapCenter.longitude,
      lateNote: _isLate && _lateNoteController.text.isNotEmpty
          ? _lateNoteController.text
          : null,
    );
    setState(() => _isClockinIn = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Clock In'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live time display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.gradientPrimary,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    AppDateUtils.formatTime(DateTime.now()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 44,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    AppDateUtils.formatDate(DateTime.now()),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  if (_isLate) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_amber, color: Colors.orange, size: 16),
                          SizedBox(width: 6),
                          Text('Late Arrival',
                              style: TextStyle(color: Colors.orange)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.2),
            const SizedBox(height: 24),

            // Location Section
            const Text('Your Location',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),

            // OpenStreetMap Widget
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _locationVerified
                      ? AppColors.success
                      : AppColors.outline,
                  width: _locationVerified ? 2 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _currentMapCenter,
                        initialZoom: 16.0,
                        onTap: (tapPosition, point) {
                          setState(() {
                            _currentMapCenter = point;
                          });
                          _mapController.move(point, 16.0);
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                          tileBuilder: (context, child, tile) {
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F0FE),
                              ),
                              child: child,
                            );
                          },
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _currentMapCenter,
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.location_pin,
                                color: AppColors.primary,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Verification overlay
                    if (_isVerifyingLocation) ...[
                      Container(
                        color: Colors.white.withOpacity(0.8),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: AppColors.primary),
                                ),
                                SizedBox(width: 10),
                                Text('Verifying location...',
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    // Verified badge
                    if (_locationVerified && !_isVerifyingLocation)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check,
                              color: Colors.white, size: 14),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Location input
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Search or enter location...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    // Reset to default location
                    setState(() {
                      _currentMapCenter = _lagosLocation;
                    });
                    _mapController.move(_lagosLocation, 16.0);
                    _simulateLocationVerification();
                  },
                  icon: const Icon(Icons.my_location, color: AppColors.primary),
                ),
              ),
              onSubmitted: (v) {
                if (v.isNotEmpty) {
                  setState(() => _selectedLocation = v);
                  _simulateLocationVerification();
                }
              },
            ),
            const SizedBox(height: 8),

            // Recent locations
            const Text('Recent Locations',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            ..._recentLocations.map((loc) {
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedLocation = loc);
                  _simulateLocationVerification();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: _selectedLocation == loc
                        ? AppColors.primaryLight
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _selectedLocation == loc
                          ? AppColors.primary
                          : AppColors.outline,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        size: 16,
                        color: _selectedLocation == loc
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          loc,
                          style: TextStyle(
                            fontSize: 13,
                            color: _selectedLocation == loc
                                ? AppColors.primary
                                : AppColors.onSurface,
                          ),
                        ),
                      ),
                      if (_selectedLocation == loc)
                        const Icon(Icons.check_circle,
                            size: 16, color: AppColors.primary),
                    ],
                  ),
                ),
              );
            }),

            // Late note if applicable
            if (_isLate) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: AppColors.warning, size: 18),
                        SizedBox(width: 8),
                        Text('Late Arrival Note',
                            style: TextStyle(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'You are clocking in after the scheduled start time. Please provide a reason to notify your manager:',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _lateNoteController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText:
                            'e.g., Traffic congestion on Third Mainland Bridge...',
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 28),

            // Clock In Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: !_locationVerified || _isClockinIn ? null : _clockIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isClockinIn
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.fingerprint, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Confirm Clock In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/utils/app_date_utils.dart';
// import '../../../auth/providers/auth_provider.dart';
// import '../../providers/staff_provider.dart';

// class ClockInScreen extends StatefulWidget {
//   const ClockInScreen({super.key});

//   @override
//   State<ClockInScreen> createState() => _ClockInScreenState();
// }

// class _ClockInScreenState extends State<ClockInScreen> {
//   bool _isVerifyingLocation = false;
//   bool _locationVerified = false;
//   String _selectedLocation = '15 Marina Road, Victoria Island, Lagos';
//   final _locationController = TextEditingController();
//   final _lateNoteController = TextEditingController();
//   bool _isLate = false;
//   bool _isClockinIn = false;

//   final List<String> _recentLocations = [
//     '15 Marina Road, Victoria Island, Lagos',
//     'TechVentures HQ, Eko Atlantic, Lagos',
//     '23 Broad Street, Lagos Island',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _isLate = DateTime.now().hour > 8 ||
//         (DateTime.now().hour == 8 && DateTime.now().minute > 10);
//     _simulateLocationVerification();
//   }

//   Future<void> _simulateLocationVerification() async {
//     setState(() => _isVerifyingLocation = true);
//     await Future.delayed(const Duration(seconds: 2));
//     setState(() {
//       _isVerifyingLocation = false;
//       _locationVerified = true;
//     });
//     // Verify with provider
//     await context.read<StaffProvider>().verifyLocation(
//           6.4281,
//           3.4219,
//           _selectedLocation,
//         );
//   }

//   Future<void> _clockIn() async {
//     final auth = context.read<AuthProvider>();
//     final staff = context.read<StaffProvider>();

//     setState(() => _isClockinIn = true);
//     await staff.clockIn(
//       staffId: auth.currentUser!.id,
//       location: _selectedLocation,
//       lat: 6.4281,
//       lng: 3.4219,
//       lateNote: _isLate && _lateNoteController.text.isNotEmpty
//           ? _lateNoteController.text
//           : null,
//     );
//     setState(() => _isClockinIn = false);
//     if (mounted) Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: const Text('Clock In'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Live time display
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: AppColors.gradientPrimary,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     AppDateUtils.formatTime(DateTime.now()),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 44,
//                       fontWeight: FontWeight.w200,
//                       letterSpacing: 2,
//                     ),
//                   ),
//                   Text(
//                     AppDateUtils.formatDate(DateTime.now()),
//                     style: const TextStyle(color: Colors.white70, fontSize: 14),
//                   ),
//                   if (_isLate) ...[
//                     const SizedBox(height: 12),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.orange),
//                       ),
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.warning_amber, color: Colors.orange, size: 16),
//                           SizedBox(width: 6),
//                           Text('Late Arrival',
//                               style: TextStyle(color: Colors.orange)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ).animate().fadeIn().slideY(begin: -0.2),
//             const SizedBox(height: 24),

//             // Location Section
//             const Text('Your Location',
//                 style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
//             const SizedBox(height: 12),

//             // Map placeholder
//             Container(
//               height: 160,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFE8F0FE),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: _locationVerified
//                       ? AppColors.success
//                       : AppColors.outline,
//                   width: _locationVerified ? 2 : 1,
//                 ),
//               ),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   // Pseudo map
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: CustomPaint(
//                       painter: _SimpleMapPainter(),
//                       size: const Size(double.infinity, 160),
//                     ),
//                   ),
//                   if (_isVerifyingLocation) ...[
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.9),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                                 strokeWidth: 2, color: AppColors.primary),
//                           ),
//                           SizedBox(width: 10),
//                           Text('Verifying location...',
//                               style: TextStyle(fontWeight: FontWeight.w600)),
//                         ],
//                       ),
//                     ),
//                   ] else ...[
//                     const Icon(Icons.location_pin,
//                         color: AppColors.primary, size: 40),
//                   ],
//                   if (_locationVerified && !_isVerifyingLocation)
//                     Positioned(
//                       top: 10,
//                       right: 10,
//                       child: Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: const BoxDecoration(
//                           color: AppColors.success,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(Icons.check,
//                             color: Colors.white, size: 14),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Location input
//             TextField(
//               controller: _locationController,
//               decoration: InputDecoration(
//                 hintText: 'Search or enter location...',
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon: IconButton(
//                   onPressed: _simulateLocationVerification,
//                   icon: const Icon(Icons.my_location, color: AppColors.primary),
//                 ),
//               ),
//               onSubmitted: (v) {
//                 if (v.isNotEmpty) {
//                   setState(() => _selectedLocation = v);
//                   _simulateLocationVerification();
//                 }
//               },
//             ),
//             const SizedBox(height: 8),

//             // Recent locations
//             const Text('Recent Locations',
//                 style: TextStyle(
//                     color: AppColors.textSecondary,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500)),
//             const SizedBox(height: 8),
//             ..._recentLocations.map((loc) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() => _selectedLocation = loc);
//                   _simulateLocationVerification();
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 12, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: _selectedLocation == loc
//                         ? AppColors.primaryLight
//                         : Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: _selectedLocation == loc
//                           ? AppColors.primary
//                           : AppColors.outline,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.history,
//                         size: 16,
//                         color: _selectedLocation == loc
//                             ? AppColors.primary
//                             : AppColors.textSecondary,
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           loc,
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: _selectedLocation == loc
//                                 ? AppColors.primary
//                                 : AppColors.onSurface,
//                           ),
//                         ),
//                       ),
//                       if (_selectedLocation == loc)
//                         const Icon(Icons.check_circle,
//                             size: 16, color: AppColors.primary),
//                     ],
//                   ),
//                 ),
//               );
//             }),

//             // Late note if applicable
//             if (_isLate) ...[
//               const SizedBox(height: 20),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppColors.warningLight,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.warning.withOpacity(0.4)),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Row(
//                       children: [
//                         Icon(Icons.info_outline,
//                             color: AppColors.warning, size: 18),
//                         SizedBox(width: 8),
//                         Text('Late Arrival Note',
//                             style: TextStyle(
//                               color: AppColors.warning,
//                               fontWeight: FontWeight.w700,
//                             )),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       'You are clocking in after the scheduled start time. Please provide a reason to notify your manager:',
//                       style: TextStyle(
//                           color: AppColors.textSecondary, fontSize: 13),
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: _lateNoteController,
//                       maxLines: 3,
//                       decoration: const InputDecoration(
//                         hintText:
//                             'e.g., Traffic congestion on Third Mainland Bridge...',
//                         fillColor: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],

//             const SizedBox(height: 28),

//             // Clock In Button
//             SizedBox(
//               width: double.infinity,
//               height: 56,
//               child: ElevatedButton(
//                 onPressed: !_locationVerified || _isClockinIn ? null : _clockIn,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.success,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 child: _isClockinIn
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.fingerprint, color: Colors.white),
//                           SizedBox(width: 10),
//                           Text(
//                             'Confirm Clock In',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//               ),
//             ).animate().fadeIn(delay: 300.ms),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _SimpleMapPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final bg = Paint()..color = const Color(0xFFE8F0FE);
//     canvas.drawRect(Offset.zero & size, bg);

//     final road = Paint()
//       ..color = Colors.white
//       ..strokeWidth = 8
//       ..style = PaintingStyle.stroke;

//     canvas.drawLine(Offset(0, size.height * 0.4),
//         Offset(size.width, size.height * 0.4), road);
//     canvas.drawLine(Offset(size.width * 0.35, 0),
//         Offset(size.width * 0.35, size.height), road);
//     canvas.drawLine(Offset(size.width * 0.7, 0),
//         Offset(size.width * 0.7, size.height), road);

//     final block = Paint()
//       ..color = const Color(0xFFB8CEF9)
//       ..style = PaintingStyle.fill;

//     canvas.drawRRect(
//         RRect.fromRectAndRadius(const Rect.fromLTWH(10, 10, 80, 50),
//             const Radius.circular(4)),
//         block);
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.4, 10, 90, 50),
//             const Radius.circular(4)),
//         block);
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             Rect.fromLTWH(size.width * 0.75, 10, 60, 50),
//             const Radius.circular(4)),
//         block);
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             Rect.fromLTWH(10, size.height * 0.6, 80, 45),
//             const Radius.circular(4)),
//         block);
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             Rect.fromLTWH(size.width * 0.4, size.height * 0.6, 90, 45),
//             const Radius.circular(4)),
//         block);
//   }

//   @override
//   bool shouldRepaint(_) => false;
// }