import 'package:flutter/material.dart';
import '../AuthService.dart';
import '../admin/celebrityprofilemanagement.dart';
import '../homefeed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  Widget? _destinationScreen;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    try {
      final result = await AuthService.getCurrentUser();
      setState(() {
        _isLoading = false;
        if (result['success'] && result['data']?['role'] == 'CELEBRITY') {
          _destinationScreen = const CelebrityProfile(); // For celebrities
        } else {
          _destinationScreen = const HomeFeed(); // For regular users
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
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
                  await AuthService.logout();
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, '/login');
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
