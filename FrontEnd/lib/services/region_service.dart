import 'dart:convert';

import '../config.dart';
import '../model/region.dart';
import 'auth_service.dart';
import 'package:http/http.dart' as http;

class RegionService {
  final String url = "${Config.baseUrl}/api/Region/GetAllRegions";
  final AuthService authService = AuthService();

  Future<List<Region>> getAllRegions() async {
    try {
      final token = await authService
          .getToken(); // Ensure token retrieval is awaited

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Add token to headers
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        return data.map((categoryData) {
          return Region(
            regionId: categoryData['regionId'],
            regionName: categoryData['regionName']
          );
        }).toList();
      } else {
        throw Exception('Failed to load regions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching regions: $e');
    }
  }
}