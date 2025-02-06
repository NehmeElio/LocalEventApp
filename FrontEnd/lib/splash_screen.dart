import 'package:flutter/material.dart';
import 'dart:async';
import 'package:local_event_finder_frontend/services/auth_service.dart';
import 'package:local_event_finder_frontend/ui/homepage/home_page.dart';
import 'package:local_event_finder_frontend/ui/sign_in/sign_in_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds before checking token and navigating
    Future.delayed(Duration(seconds: 3), () async {
      // Fetch token to decide the next page
      AuthService authService = AuthService();
      String? token = await authService.getToken();

      // Navigate based on the token's availability
      if (token != null) {
        // If token is available, navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // If no token, navigate to SignInPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF2A00), // Customize background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/event-seekers-2.png', width: 200), // Your logo image
            SizedBox(height: 20),
            CircularProgressIndicator(), // Optional: Show loading indicator
          ],
        ),
      ),
    );
  }
}
