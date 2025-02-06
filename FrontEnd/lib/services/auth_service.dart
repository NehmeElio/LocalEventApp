import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_event_finder_frontend/config.dart';

// Define the backend URL for login, registration, and uploading profile picture
const String loginUrl = '${Config.baseUrl}/api/Account/Login';
const String registerUrl = '${Config.baseUrl}/api/Account/Register';
const String profilePictureUrl = '${Config.baseUrl}/api/Account/UploadProfilePicture'; // Add this endpoint
const String uploadUrl = '${Config.baseUrl}/api/Account/UploadProfilePicture';
const String retrieveUrl = '${Config.baseUrl}/api/Account/GetProfilePicture';
const String _tokenKey = 'jwt_token';
const String _userKey = 'user_info';

// Create a storage instance to store the JWT token securely
final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

class AuthService {
  // Login method to authenticate user and get the JWT token
  Future<String?> login(String username, String password) async {
    try {
      print('[AuthService] Attempting to log in user: $username');

      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'Username': username,
          'Password': password,
        }),
      );

      print('[AuthService] Login response status: ${response.statusCode}');
      print('[AuthService] Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        final user = responseData['user'];

        if (token != null) {
          print('[AuthService] Token received successfully. Storing token...');
          await _secureStorage.write(key: _tokenKey, value: token);
          await _secureStorage.write(key: _userKey, value: jsonEncode(user));
          return token;
        } else {
          print('[AuthService] Error: Token is null');
          return null;
        }
      } else {
        print('[AuthService] Login failed: ${response.body}');
        return null;
      }
    } catch (error) {
      print('[AuthService] Login error: $error');
      return null;
    }
  }

  // Register method to create a new user account
  Future<String?> register(
      String username,
      String password,
      String email,
      String firstName,
      String lastName,
      String phoneNumber,
      ) async {
    try {
      print('[AuthService] Attempting to register user: $username');

      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'Username': username,
          'Password': password,
          'Email': email,
          'FirstName': firstName,
          'LastName': lastName,
          'PhoneNumber': phoneNumber,
        }),
      );

      print('[AuthService] Register response status: ${response.statusCode}');
      print('[AuthService] Register response body: ${response.body}');

      if (response.statusCode == 200) {
        print('[AuthService] User registered successfully.');
        return null; // No error, registration successful
      } else if (response.statusCode == 409) {
        final responseData = jsonDecode(response.body);
        return responseData['message'] ?? 'An unknown error occurred.';
      } else {
        return 'Registration failed. Please try again later.';
      }
    } catch (error) {
      print('[AuthService] Registration error: $error');
      return 'An error occurred. Please check your connection.';
    }
  }

  // Method to retrieve the stored JWT token
  Future<String?> getToken() async {
    try {
      print('[AuthService] Retrieving stored token...');
      String? token = await _secureStorage.read(key: _tokenKey);

      if (token != null) {
        print('[AuthService] Token retrieved successfully.');
      } else {
        print('[AuthService] No token found.');
      }

      return token;
    } catch (error) {
      print('[AuthService] Error retrieving token: $error');
      return null;
    }
  }


  // Retrieve the stored user information
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      print('[AuthService] Retrieving stored user info...');
      String? userJson = await _secureStorage.read(key: _userKey);

      if (userJson != null) {
        print('[AuthService] User info retrieved successfully.');
        return jsonDecode(userJson); // Convert JSON string to Map
      } else {
        print('[AuthService] No user info found.');
        return null;
      }
    } catch (error) {
      print('[AuthService] Error retrieving user info: $error');
      return null;
    }
  }

  // Method to log out and delete the token from secure storage
  Future<void> logout() async {
    try {
      print('[AuthService] Logging out... Deleting stored data.');
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _userKey);
      print('[AuthService] Token and user data deleted successfully.');
    } catch (error) {
      print('[AuthService] Error during logout: $error');
    }
  }

  Future<Uint8List?> getProfilePicture() async {
    try {
      final token = await getToken();
      final userInfo = await getUserInfo();
      final userId = userInfo?['accountId'];  // Assuming userId is already an int
      final userIdString = userId.toString();

      // Using http.get() instead of MultipartRequest for GET requests
      final response = await http.get(
        Uri.parse('$retrieveUrl?accountId=$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // Return the profile picture as bytes
      } else {
        print('Failed to retrieve profile picture. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error retrieving profile picture: $e');
      return null;
    }
  }

// Add other methods like getToken() if needed...


  // Function to upload the profile picture
  Future<void> uploadProfilePicture(File image) async {
    try {
      final token=await getToken();
      final userInfo=await getUserInfo();
      print("user info is $userInfo");
      final userId = userInfo?['accountId'];  // userId should already be int
      print("user Id is $userId, type is ${userId.runtimeType}");

      // Convert userId to String
      final userIdString = userId.toString();
      print("userId as string: $userIdString");

      print('Uploading profile picture...');
      print("token is $token");
        // Adjust the endpoint URL as needed
      // Create a multipart request to upload the image
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['userId'] = userIdString // Pass the user ID to the backend if needed
        ..files.add(await http.MultipartFile.fromPath('profilePicture', image.path));

      // Send the request and await the response
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Profile picture uploaded successfully');
      } else {
        print('Failed to upload profile picture. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
  }
}


