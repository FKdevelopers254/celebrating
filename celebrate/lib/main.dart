import 'package:flutter/material.dart';
import 'AuthService.dart';
import 'services/navigation_service.dart';
import 'models/user.dart';
import 'postcreation.dart';
import 'register.dart';
import 'userprofile.dart';
import 'admin/celebrityprofilemanagement.dart';
import 'homefeed.dart';
import 'login.dart';
import 'notifications.dart';
import 'compare.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Celebrate',
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: Colors.orange,
          secondary: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const AuthenticationWrapper(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomeFeed(),
        '/postcreation': (context) => const Postcreation(),
        '/userprofile': (context) => const Userprofile(),
        '/celebrityprofilemanagement': (context) =>
            const CelebrityProfileManagement(),
        '/compare': (context) => const CompareScreen(),
        '/notifications': (context) => const Notifications(),
      },
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;
  String _userRole = 'user';

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final result = await AuthService.getCurrentUser();
      setState(() {
        _isLoading = false;
        _isAuthenticated = result['success'];
        _userRole = result['data']?['role'] ?? 'user';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isAuthenticated = false;
        _userRole = 'user';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isAuthenticated) {
      if (_userRole.toLowerCase() == 'celebrity') {
        return const CelebrityProfileManagement();
      } else {
        return const HomeFeed();
      }
    } else {
      return const LoginPage();
    }
  }
}
