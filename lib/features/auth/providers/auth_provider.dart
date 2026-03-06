import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/mock_auth_data.dart';

class AuthProvider extends ChangeNotifier {
  UserModel?    _currentUser;
  CompanyModel? _currentCompany;
  bool   _isLoading = false;
  String? _error;

  UserModel?    get currentUser    => _currentUser;
  CompanyModel? get currentCompany => _currentCompany;
  bool   get isLoading       => _isLoading;
  String? get error           => _error;
  bool   get isAuthenticated  => _currentUser != null;
  bool   get isSuperAdmin     => _currentUser?.role == UserRole.superAdmin;
  bool   get isEmployer       => _currentUser?.role == UserRole.employer;
  bool   get isStaff          => _currentUser?.role == UserRole.staff;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1100));

    final user = MockAuthData.authenticate(email, password);
    if (user != null) {
      _currentUser = user;
      if (user.companyId != null) {
        _currentCompany = MockAuthData.companyById(user.companyId!);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _error = 'Invalid credentials. Please check and try again.';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _currentUser    = null;
    _currentCompany = null;
    notifyListeners();
  }
}



// import 'package:flutter/foundation.dart';
// import '../data/models/user_model.dart';
// import '../data/mock_auth_data.dart';

// class AuthProvider extends ChangeNotifier {
//   UserModel? _currentUser;
//   CompanyModel? _currentCompany;
//   bool _isLoading = false;
//   String? _error;

//   UserModel? get currentUser => _currentUser;
//   CompanyModel? get currentCompany => _currentCompany;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get isAuthenticated => _currentUser != null;
//   bool get isEmployer => _currentUser?.role == UserRole.employer;
//   bool get isStaff => _currentUser?.role == UserRole.staff;

//   Future<bool> login(String email, String password) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     // Simulate network delay
//     await Future.delayed(const Duration(milliseconds: 1200));

//     final user = MockAuthData.authenticate(email, password);
//     if (user != null) {
//       _currentUser = user;
//       _currentCompany = MockAuthData.company;
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } else {
//       _error = 'Invalid email or password. Please try again.';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   void logout() {
//     _currentUser = null;
//     _currentCompany = null;
//     notifyListeners();
//   }
// }