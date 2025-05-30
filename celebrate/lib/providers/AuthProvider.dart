import 'package:flutter/material.dart';
   import 'package:shared_preferences/shared_preferences.dart';
   import '../AuthService.dart'; // Adjust path
   import 'package:celebrate/models/user.dart'; // Import if exists
   import 'package:celebrate/models/celebrity.dart'; // Import if exists

   class AuthProvider with ChangeNotifier {
     String? _token;
     String? _role;
     dynamic _userData;

     String? get token => _token;
     String? get role => _role;
     dynamic get userData => _userData;

     Future<void> login(String username, String password) async {
       final result = await AuthService.loginUser(username, password);
       if (result['success']) {
         _token = await AuthService.getToken();
         if (_token == null) {
           print('Warning: No token received after login');
         }
         // Load the persisted role if not already set
         if (_role == null) {
           _role = await _loadRole();
         }
         // Update role from backend response if available, otherwise use persisted role
         _role = (result['data']?['role'] as String?)?.toUpperCase() ?? _role ?? 'USER';
         print('Login: Updated role to $_role');
         _userData = User(id: result['data']?['id'] ?? 0, username: username, email: '');
         notifyListeners();
       } else {
         throw Exception(result['message'] ?? 'Login failed');
       }
     }

     Future<void> register(String username, String email, String password, String role) async {
       final result = await AuthService.registerUser(username, email, password, role: role);
       if (result['success']) {
         _token = await AuthService.getToken();
         if (_token == null) {
           print('Warning: No token received after registration');
         }
         _role = role.toUpperCase();
         print('Register: Setting role to $_role');
         await _saveRole(_role!);
         _userData = _role == 'USER' ? User(id: result['data']?['id'] ?? 0, username: username, email: email) : Celebrity(stageName: username, fullName: username, dateOfBirth: '', placeOfBirth: '', nationality: '', ethnicity: '', netWorth: '', professions: [], debutWorks: [], majorAchievements: [], notableProjects: [], collaborations: [], agenciesOrLabels: []);
         notifyListeners();
       } else {
         throw Exception(result['message'] ?? 'Registration failed');
       }
     }

     Future<void> loadToken() async {
       _token = await AuthService.getToken();
       if (_token != null) {
         _role = await _loadRole() ?? 'USER';
         print('LoadToken: Loaded role as $_role');
         _userData = User(id: 0, username: '', email: '');
       }
       notifyListeners();
     }

     Future<void> logout() async {
       await AuthService.logout();
       _token = null;
       _role = null;
       _userData = null;
       await _saveRole('');
       notifyListeners();
     }

     Future<void> _saveRole(String role) async {
       final prefs = await SharedPreferences.getInstance();
       await prefs.setString('auth_role', role);
       print('SaveRole: Saved role as $role');

       final savedRole = prefs.getString('auth_role');
  if (savedRole != role) {
    print('Error: Role save failed. Expected $role, but got $savedRole');
  }
     }
     

     Future<String?> _loadRole() async {
       final prefs = await SharedPreferences.getInstance();
       final role = prefs.getString('auth_role');
       print('LoadRole: Loaded role as $role');
       return role;
     }
   }