import 'package:flutter/material.dart';
import 'package:local_event_finder_frontend/style_guide.dart';
import 'package:local_event_finder_frontend/ui/homepage/home_page.dart';
import 'package:local_event_finder_frontend/ui/sign_in/sign_in_page.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  //categories needs to be pulled from the database by calling an API
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppTitle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFFFFF),//white
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFFFF4700),//orange
      ),
      home:HomePage()//SignInPage()//HomePage(),
    );
  }
}

