import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../AuthService.dart'; // Import your AuthService
import 'package:celebrate/providers/AuthProvider.dart'; // Import AuthProvider
import 'homefeed.dart';
import 'celebrity_home.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isCelebrity = false; // Track selected role
  final AuthProvider _authProvider = AuthProvider();

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    await _authProvider.loadToken();
    setState(() {
      _isCelebrity = _authProvider.role == 'CELEBRITY';
      print('InitState: Set _isCelebrity to $_isCelebrity based on role ${_authProvider.role}');
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        print('Starting login process...');
        print('Logging in with: username=${_usernameController.text}, role=${_isCelebrity ? "CELEBRITY" : "USER"}');
        final result = await AuthService.loginUser(
          _usernameController.text,
          _passwordController.text,
          role: _isCelebrity ? "CELEBRITY" : "USER",
        );
        print('Login result: $result');

        if (result['success']) {
          if (!mounted) return;
          await _authProvider.login(
            _usernameController.text,
            _passwordController.text,
            selectedRole: _isCelebrity ? "CELEBRITY" : "USER",
          );
          print('Post-login: AuthProvider role is ${_authProvider.role}, UI role is ${_isCelebrity ? "CELEBRITY" : "USER"}');
          if (_authProvider.role != null && _authProvider.role != (_isCelebrity ? 'CELEBRITY' : 'USER')) {
            Fluttertoast.showToast(
              msg: 'Role mismatch. Please select the correct role: ${_authProvider.role}.',
              backgroundColor: Colors.red,
              toastLength: Toast.LENGTH_LONG,
            );
            return;
          }
          final destination = _isCelebrity ? const CelebrityHomePage() : const HomeFeed();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        } else {
          if (!mounted) return;
          String errorMsg = result['message'] ?? "Login failed.";
          if (result['details'] != null) {
            print('Login error details: ${result['details']}');
            errorMsg += '\nDetails: ${result['details']}';
          }
          Fluttertoast.showToast(
            msg: errorMsg,
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } catch (e) {
        print('Login error in UI: $e');
        if (!mounted) return;
        Fluttertoast.showToast(
          msg: "An error occurred: $e. Please try again later.",
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[600], // Gold background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber[600], // Gold background
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildHeader(),
                            _buildSignInText(),
                            _buildForm(),
                            _buildSignInButton(),
                            _buildSocialButtons(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('lib/images/img.png'),
        ),
        SizedBox(width: 10),
        Text(
          'CELEBRATING',
          style: GoogleFonts.lato(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSignInText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sign in',
          style: GoogleFonts.andika(
              fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Row(
          children: [
            Text(
              'Don\'t have an account? ',
              style: GoogleFonts.andika(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ),
                );
              },
              child: Text(
                'Sign Up',
                style: GoogleFonts.andika(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: TextStyle(color: Colors.white),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your username';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.white),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account Type',
                style: GoogleFonts.andika(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text(
                        'Regular User',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: false,
                      groupValue: _isCelebrity,
                      activeColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          _isCelebrity = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text(
                        'Celebrity',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: true,
                      groupValue: _isCelebrity,
                      activeColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          _isCelebrity = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ' ',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            Text(
              'Forgot Password?',
              style: GoogleFonts.andika(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _login,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.white),
            color: Colors.transparent.withOpacity(0.2),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Sign in',
                      style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        _buildSocialButton(
            Icons.g_mobiledata, 'Continue with Google', Colors.red),
        _buildSocialButton(
            Icons.facebook, 'Continue with Facebook', Colors.blue),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.white),
          color: Colors.white.withOpacity(0.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 30),
              Text(
                text,
                style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}