import 'package:flutter/material.dart';
import 'package:local_event_finder_frontend/splash_screen.dart';
import 'package:local_event_finder_frontend/ui/homepage/home_page.dart';
import 'package:local_event_finder_frontend/ui/sign_in/sign_in_page.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'services/auth_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();

    return MaterialApp(
      title: 'AppTitle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFFFFF), // White
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFFFF4700), // Orange
      ),
      home: SplashScreen()
    );
  }
}
