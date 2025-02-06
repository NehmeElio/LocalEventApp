import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:local_event_finder_frontend/config.dart';
import 'auth_service.dart';
import '../model/event.dart';

class FavoriteService {
  final String baseUrl = Config.baseUrl;
  final AuthService authService = AuthService();

  // Method to fetch favorite events
  Future<List<Event>?> getFavoriteEvents(int accountId) async {
    try {
      var uri = Uri.parse('$baseUrl/api/Favorite/$accountId');
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

  // Method to add a favorite event
  Future<bool> addFavoriteEvent(int accountId, int eventId) async {
    try {
      var uri = Uri.parse('$baseUrl/api/Favorite/Add?accountId=$accountId&eventId=$eventId');
      final token = await authService.getToken();

      var response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'accountId': accountId,
          'eventId': eventId,
        }),
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        print('Failed to add favorite event: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error while adding favorite event: $e');
      return false;
    }
  }

  // Method to remove a favorite event
  Future<bool> removeFavoriteEvent(int accountId, int eventId) async {
    try {
      var uri = Uri.parse('$baseUrl/api/Favorite/Remove?accountId=$accountId&eventId=$eventId');
      final token = await authService.getToken();

      var response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'accountId': accountId,
          'eventId': eventId,
        }),
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        print('Failed to remove favorite event: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error while removing favorite event: $e');
      return false;
    }
  }
}
