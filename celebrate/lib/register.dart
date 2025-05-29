import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../AuthService.dart'; // Import your AuthService
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isCelebrity = false; // Track selected role

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        Fluttertoast.showToast(
          msg: "Passwords don't match",
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        print('Starting registration process...');
        print('Registering with: username=${_usernameController.text}, email=${_emailController.text}, role=${_isCelebrity ? "CELEBRITY" : "USER"}');
        final result = await AuthService.registerUser(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
          role: _isCelebrity ? "CELEBRITY" : "USER",
        );
        print('Registration result: $result');

        if (result['success']) {
          if (!mounted) return;
          Fluttertoast.showToast(
            msg: result['message'] ?? "Registration successful! Please login.",
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else {
          if (!mounted) return;
          String errorMsg = result['message'] ?? "Registration failed.";
          if (result['details'] != null) {
            print('Registration error details: ${result['details']}');
            errorMsg += '\nDetails: ${result['details']}';
          }
          Fluttertoast.showToast(
            msg: errorMsg,
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } catch (e) {
        print('Registration error in UI: $e');
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
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: 400,
                minHeight: MediaQuery.of(context).size.height - 40,
              ),
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 50),
                    _buildSignUpText(),
                    const SizedBox(height: 30),
                    _buildForm(),
                    const SizedBox(height: 30),
                    _buildRegisterButton(),
                    const SizedBox(height: 20),
                    _buildLoginLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('lib/images/img.png'),
          ),
          SizedBox(width: 10),
          Text(
            'CELEBRATING',
            style: GoogleFonts.lato(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpText() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign up',
            style: GoogleFonts.andika(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  'Already have an account? ',
                  style: GoogleFonts.andika(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign In',
                    style: GoogleFonts.andika(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a username';
            }
            if (value.length < 3) {
              return 'Username must be at least 3 characters';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an email';
            }
            if (!value.contains('@') || !value.contains('.')) {
              return 'Please enter a valid email';
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
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        SizedBox(height: 24),
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
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.deepPurple)
            : Text(
                'Register',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: GoogleFonts.andika(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          child: Text(
            'Sign In',
            style: GoogleFonts.andika(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}