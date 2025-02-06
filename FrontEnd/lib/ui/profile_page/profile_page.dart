import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_event_finder_frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../sign_in/sign_in_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();
  File? _profileImage;
  Uint8List? _profileImageBytes;

  @override
  void initState() {
    super.initState();
    _loadProfilePicture(); // Fetch the profile picture on page load
  }

  Future<void> _loadProfilePicture() async {


      final pictureBytes = await authService.getProfilePicture();
      setState(() {
        _profileImageBytes = pictureBytes;
      });

  }


  // Function to pick an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      // Await the length of the file to get the actual size
      final fileLength = await _profileImage!.length();
      print("length is: $fileLength");  // Now you should get the file size in bytes

      authService.uploadProfilePicture(_profileImage!);
    }
  }


  // Function to upload the profile picture


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture with Edit Icon
            Stack(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.deepOrange.shade100,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:_profileImageBytes == null
                          ? AssetImage('assets/profile_placeholder.jpg')
                          : MemoryImage(_profileImageBytes!),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.black, size: 30),
                    onPressed: _pickImage,  // Pick a new image when clicked
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Load User Info Asynchronously
            FutureBuilder<Map<String, dynamic>?>(
              future: authService.getUserInfo(), // Fetch user info
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Loading spinner
                } else if (snapshot.hasError) {
                  return Text("Error loading user info");
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Text("No user data available");
                }

                final userInfo = snapshot.data!; // User data is available

                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        buildProfileRow(Icons.person, userInfo['username'] ?? "Unknown User"),
                        buildProfileRow(Icons.email, userInfo['email'] ?? "No Email Available"),
                        buildProfileRow(Icons.badge, "${userInfo['name'] ?? ''} ${userInfo['lastname'] ?? ''}"),
                        buildProfileRow(Icons.phone, "Phone: ${userInfo['phoneNb'] ?? 'N/A'}"),
                        buildProfileRow(Icons.calendar_today, "Joined: ${userInfo['createdAt'] ?? 'N/A'}"),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 30),

            // Logout Button
            ElevatedButton(
              onPressed: () async {
                await authService.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build profile rows
  Widget buildProfileRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepOrange, size: 28),
          SizedBox(width: 15),
          Text(
            text,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
