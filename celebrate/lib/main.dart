import 'package:celebrate/postcreation.dart';
import 'package:celebrate/register.dart';
import 'package:celebrate/userprofile.dart';
import 'package:flutter/material.dart';
import 'AuthService.dart';

import 'admin/celebrityprofilemanagement.dart';
import 'celebrityfeed.dart';
import 'compare.dart';
import 'homefeed.dart';
import 'intropage.dart';
import 'login.dart';
import 'notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Celebrate',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            primary: Colors.orange,
            secondary: Colors.black),
        useMaterial3: true,
      ),
      home: const AuthenticationWrapper(),
      debugShowCheckedModeBanner: false,
      routes: {
        // Define routes for other screens
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomeFeed(),
        '/celebrityfeed': (context) => const CelebrityFeed(),
        '/postcreation': (context) => const Postcreation(),
        '/userprofile': (context) => const Userprofile(),
        '/celebrityprofilemanagement': (context) => const CelebrityFeed(),
        '/compare': (context) => const CompareScreen(),
        '/notifications': (context) => const Notifications(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final isAuthenticated = snapshot.data ?? false;
        if (isAuthenticated) {
          return const HomeFeed();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
