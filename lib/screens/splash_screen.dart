import 'package:flutter/material.dart';
import 'package:ipfeedback/config/config.dart';
import '../services/app_utils.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key}) {
    AppUtils.splashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A4FA8),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  'IP Feedback',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Version at Bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                Config.version,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
