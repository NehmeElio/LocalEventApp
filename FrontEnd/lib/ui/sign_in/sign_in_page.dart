import 'package:flutter/material.dart';
import 'package:local_event_finder_frontend/ui/sign_in/sign_up_page.dart';

import '../../services/auth_service.dart';
import '../../style_guide.dart';
import '../homepage/home_page.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    // Call the login method from AuthService
    AuthService authService = AuthService();
    final token = await authService.login(email, password);

    setState(() {
      _isLoading = false;
    });

    if (token != null) {
      // If successful, navigate to the next screen (Home screen or dashboard)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Replace HomePage() with your actual home page widget
      ); // Example
    } else {
      // If login fails, show an error message
      setState(() {
        _errorMessage = 'Invalid email or password. Please try again.';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Heading
                  Text(
                    'Sign In',
                    style: whiteHeadingTextStyle,
                  ),
                  SizedBox(height: 50),

                  // Email Input Field
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: fadedTextStyle,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: fadedTextStyle,
                      hintText: 'Enter your email',
                      hintStyle: fadedTextStyle.copyWith(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Password Input Field
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible, // toggle password visibility
                    style: fadedTextStyle,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: fadedTextStyle,
                      hintText: 'Enter your password',
                      hintStyle: fadedTextStyle.copyWith(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Icon(
                          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  if(_errorMessage!=null)
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0,bottom: 10),
                          child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 15),
                            ),
                    ),
                  // Sign In Button
                  ElevatedButton(
                    onPressed: () {
                      _isLoading ? null : _signIn();
                      // Handle Sign In logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF4700), // Custom orange color
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                    :Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Forgot Password Text
                  GestureDetector(
                    onTap: () {
                      // Handle Forgot Password logic here
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFFFF4700),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Sign Up Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Don\'t have an account? ',
                        style: fadedTextStyle,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpPage()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFFFF4700),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
