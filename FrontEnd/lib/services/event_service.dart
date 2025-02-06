import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:local_event_finder_frontend/config.dart';
import '../model/event.dart';
import 'auth_service.dart';

class EventService {
  final String baseUrl = Config.baseUrl;
  final AuthService authService = AuthService();

  // Method to add event
  Future<bool> addEvent({
    required String title,
    String? description,
    required int regionId,
    required DateTime date,
    required int categoryId,
    required String punchLine1,
    required String punchLine2,
    XFile? eventImage,
    List<XFile>? galleryImages,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/api/Event/AddEvent');
      final token = await authService.getToken();
      final userInfo = await authService.getUserInfo();
      final userId = userInfo?['accountId'];
      final userIdString = userId.toString();


      var formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(date);
      print("formatted date is ${formattedDate}");


      // Prepare the form data
      var request = http.MultipartRequest('POST', uri)
        ..fields['title'] = title
        ..fields['description'] = description ?? ''
        ..fields['regionId'] = regionId.toString()
        ..fields['Date'] = formattedDate
        ..fields['categoryId'] = categoryId.toString()
        ..fields['punchLine1'] = punchLine1
        ..fields['punchLine2'] = punchLine2
        ..fields['hostId'] = userIdString
        ..headers['Authorization'] = 'Bearer $token';

      // Add event image if present
      if (eventImage != null) {
        var eventImageBytes = await eventImage.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'eventImage',
          eventImageBytes,
          filename: eventImage.name,
        ));
      }

      // Add gallery images if present
      if (galleryImages != null && galleryImages.isNotEmpty) {
        for (var galleryImage in galleryImages) {
          var galleryImageBytes = await galleryImage.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            'galleryImages',
            galleryImageBytes,
            filename: galleryImage.name,
          ));
        }
      }

      // Send the request
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to add event: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error while adding event: $e');
      return false;
    }
  }

  // Method to fetch events
  Future<List<Event>?> getEvents() async {
    try {
      var uri = Uri.parse('$baseUrl/api/Event/GetEvents');
      final token = await authService.getToken();

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          try {
            // First, try parsing as a list
            dynamic jsonData = json.decode(response.body);

            // Check if it's a list
            if (jsonData is List) {
              List<Event> events = jsonData.map((jsonItem) {
                //print("it is a list");
                return Event.fromJson(jsonItem);
              }).toList();
              return events;
            }
            // If not a list, check if it's a single event object
            else if (jsonData is Map<String, dynamic>) {
              return [Event.fromJson(jsonData)];
            }
            else {
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
        print('Failed to fetch events: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error while fetching events: $e');
      return null;
    }
  }

  Future<List<Event>?> getEventsByHost() async {
    try {
      final userinfo=await authService.getUserInfo();
      final accountId = userinfo?['accountId'];

      var uri = Uri.parse('$baseUrl/api/Event/GetEventByHost/$accountId');
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
