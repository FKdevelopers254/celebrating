import 'package:flutter/material.dart';

class CelebrityHomePage extends StatelessWidget {
  const CelebrityHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Celebrity Home')),
      body: Center(
        child: Text('Welcome, Celebrity!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}