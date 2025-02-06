import '../config.dart';
import '../model/event.dart';
import '../model/guest.dart';
import 'auth_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GuestService {
  final String baseUrl = Config.baseUrl; // Replace with your actual API URL
  final AuthService authService = AuthService();

  // Function to get the authentication token from the AuthService
  Future<String?> _getAuthToken() async {
    return await authService.getToken(); // Replace with the actual method from AuthService to get the token
  }

  // Fetch all guests for a specific event
  Future<List<Guest>> getAllGuests(int eventId) async {
    final token = await _getAuthToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/guest/GetAllGuests?eventId=$eventId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token" // Add the token here
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((guest) => Guest.fromJson(guest)).toList();
    } else {
      throw Exception('Failed to load guests');
    }
  }

  // Add a guest to an event
  Future<bool> addGuest(int eventId, int userId) async {
    final token = await _getAuthToken();
    bool success;

    final response = await http.post(
      Uri.parse('$baseUrl/api/guest/AddGuest?eventId=$eventId&userId=$userId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token" // Add the token here
      },
    );

    if (response.statusCode != 201) {
      success = false;
    }
    else
      {
        success = true;
      }

    return success;
  }

  Future<bool> removeGuest(int eventId, int userId) async {
    final token = await _getAuthToken();
    bool success;

    final response = await http.post(
      Uri.parse('$baseUrl/api/guest/RemoveGuest?eventId=$eventId&userId=$userId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token" // Add the token here
      },
    );

    if (response.statusCode != 200) {
      success = false;
    }
    else
    {
      success = true;
    }

    return success;
  }

  Future<List<Event>?> getEvents() async {
    try {
      final userinfo=await authService.getUserInfo();
      final accountId = userinfo?['accountId'];

      var uri = Uri.parse('$baseUrl/api/Guest/GetAllEvents?accountId=$accountId');
      final token = await authService.getToken();

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          try {
            dynamic jsonData = json.decode(response.body);

            if (jsonData is List) {
              return jsonData.map((jsonItem) => Event.fromJson(jsonItem)).toList();
            } else {
              print('Unexpected JSON format');
              return null;
            }
          } catch (e) {
            print('Error parsing JSON: $e');
            return null;
          }
        } else {
          print('Received empty response body');
          return null;
        }
      } else {
        print('Failed to fetch favorite events: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error while fetching favorite events: $e');
      return null;
    }
  }
}
