import 'package:flutter/material.dart';
import 'package:local_event_finder_frontend/ui/sign_in/sign_in_page.dart';
import '../../services/auth_service.dart';
import '../../style_guide.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNumberController =
      TextEditingController(); // Added for phone number
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  String? _emailError;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _phoneNumberError;
  String? _firstNameError;
  String? _lastNameError;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose(); // Dispose the phone number controller
    super.dispose();
  }

  void _signUp() async {
    setState(() {
      _emailError = null;
      _usernameError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _phoneNumberError = null;
      _firstNameError = null;
      _lastNameError = null;
      _errorMessage = null;
      _isLoading = true;
    });

    // Validate email
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String phoneNumber = _phoneNumberController.text;
    String username = _usernameController.text;

    // Check if email is in correct format
    RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(email)) {
      _emailError = 'Please enter a valid email address';
    }

    // Check if first name and last name are not empty
    if (firstName.isEmpty) {
      _firstNameError = 'First Name cannot be empty';
    }

    if (lastName.isEmpty) {
      _lastNameError = 'Last Name cannot be empty';
    }

    if (username.isEmpty) {
      _usernameError = 'Username cannot be empty';
    }
    // Validate phone number
    if (phoneNumber.isNotEmpty &&
        (phoneNumber.length != 8 ||
            !RegExp(r'^\d{8}$').hasMatch(phoneNumber))) {
      _phoneNumberError = 'Phone number must be exactly 6 digits';
    }

    // Validate password
    RegExp passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (!passwordRegExp.hasMatch(password)) {
      _passwordError =
          'Password must be at least 8 characters long, with at least 1 letter and 1 number';
    }

    // Validate confirm password
    if (password != confirmPassword) {
      _confirmPasswordError = 'Passwords do not match';
    }

    // If there are errors, show snackbars and stop
    if (_emailError != null ||
        _firstNameError != null ||
        _lastNameError != null ||
        _usernameError != null ||
        _phoneNumberError != null ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      return;
    }

    final authService = AuthService();
    _errorMessage =await authService.register(
      username,password,email,firstName,lastName,phoneNumber
    );
    setState(() {
      _isLoading = false;
    });
    // Proceed with the API call for user registration (e.g., send the data to the backend)
    // Implement your registration logic here.
    //make sure username email and phone numbers are unique, phone number is not mandatory
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
                    'Sign Up',
                    style: whiteHeadingTextStyle,
                  ),
                  SizedBox(height: 50),

                  // First and Last Name Input Fields (side by side)
                  Row(
                    children: <Widget>[
                      // First Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _firstNameController,
                              style: fadedTextStyle,
                              decoration: InputDecoration(
                                labelText: 'First Name *',
                                labelStyle: fadedTextStyle,
                                hintText: 'Enter your first name',
                                hintStyle: fadedTextStyle.copyWith(
                                    color: Colors.white54),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            if (_firstNameError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _firstNameError!,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              )
                          ],
                        ),
                      ),
                      SizedBox(width: 10), // Space between fields

                      // Last Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _lastNameController,
                              style: fadedTextStyle,
                              decoration: InputDecoration(
                                labelText: 'Last Name *',
                                labelStyle: fadedTextStyle,
                                hintText: 'Enter your last name',
                                hintStyle: fadedTextStyle.copyWith(
                                    color: Colors.white54),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            if (_lastNameError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _lastNameError!,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Email Input Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _emailController,
                        style: fadedTextStyle,
                        decoration: InputDecoration(
                          labelText: 'Email *',
                          labelStyle: fadedTextStyle,
                          hintText: 'Enter your email',
                          hintStyle:
                              fadedTextStyle.copyWith(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      if (_emailError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _emailError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        )
                    ],
                  ),
                  SizedBox(height: 20),

                  // Username Input Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _usernameController,
                        style: fadedTextStyle,
                        decoration: InputDecoration(
                          labelText: 'Username *',
                          labelStyle: fadedTextStyle,
                          hintText: 'Enter your username',
                          hintStyle:
                              fadedTextStyle.copyWith(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      if (_usernameError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _usernameError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        )
                    ],
                  ),
                  SizedBox(height: 20),

                  // Phone Number Input Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _phoneNumberController,
                        style: fadedTextStyle,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: fadedTextStyle,
                          hintText: 'Enter your phone number',
                          hintStyle:
                              fadedTextStyle.copyWith(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.2),
                          prefixText: '+961 ',
                          // Lebanon country code
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      if (_phoneNumberError != null)
                        Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _phoneNumberError!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ))
                    ],
                  ),
                  SizedBox(height: 20),

                  // Password Input Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: fadedTextStyle,
                        decoration: InputDecoration(
                          labelText: 'Password *',
                          labelStyle: fadedTextStyle,
                          hintText: 'Enter your password',
                          hintStyle:
                              fadedTextStyle.copyWith(color: Colors.white54),
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
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (_passwordError != null)
                        Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _passwordError!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ))
                    ],
                  ),
                  SizedBox(height: 20),

                  // Confirm Password Input Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        style: fadedTextStyle,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password *',
                          labelStyle: fadedTextStyle,
                          hintText: 'Confirm your password',
                          hintStyle:
                              fadedTextStyle.copyWith(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                            child: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (_confirmPasswordError != null)
                        Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _confirmPasswordError!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ))
                    ],
                  ),
                  SizedBox(height: 30),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    ),
                  // Sign Up Button
                  ElevatedButton(
                    onPressed: () {
                      _isLoading ? null : _signUp();
                      // Handle Sign In logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF4700),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white):
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Already have an account? Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Already have an account? ',
                        style: fadedTextStyle,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to Sign In page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()),
                          );
                        },
                        child: Text(
                          'Sign In',
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
