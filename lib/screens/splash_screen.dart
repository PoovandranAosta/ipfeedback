import 'package:flutter/material.dart';
import '../services/app_utils.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key}) {
    AppUtils.splashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1a4fa8),
      body: Center(
        child: Text(
          'IP Feedback Form',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
