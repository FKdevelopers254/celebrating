import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../admin/celebrityprofilemanagement.dart';
import '../celebrityfeed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  Widget? _destinationScreen;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    try {
      final userRole = await _authService.getCurrentUserRole();
      setState(() {
        _isLoading = false;
        if (userRole == UserRole.celebrity) {
          _destinationScreen = const CelebrityProfile(); // For celebrities
        } else {
          _destinationScreen = const CelebrityFeed(); // For regular users
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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

    if (_destinationScreen == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Error loading user data'),
              ElevatedButton(
                onPressed: () async {
                  await _authService.logout();
                  // Navigate to login screen
                  // You'll need to implement this navigation
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      );
    }

    return _destinationScreen!;
  }
}
