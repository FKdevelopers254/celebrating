import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../celebrityprofile.dart';
import '../userprofile.dart';
import '../login.dart';

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
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.loadToken();
      setState(() {
        _isLoading = false;
        _destinationScreen = auth.role == 'celebrity' ? CelebrityProfile() : UserProfile();
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
                  await Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
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