import 'package:flutter/material.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _notFreshInstall();
  }



  void _notFreshInstall() async {
    // Show the splash screen for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // Remove all previous routes
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Center the logo image
          Center(
            child: Image.asset(
              'assets/images/logo_no_bg.png', // Ensure the path is correct
              width: 150, // Adjust the size as needed
              height: 150,
            ),
          ),
          // Bottom center circular progress indicator
          const Positioned(
            bottom: 50, // Position above the bottom edge
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
