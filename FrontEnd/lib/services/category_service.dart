import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_event_finder_frontend/config.dart';
import 'package:local_event_finder_frontend/model/category.dart';
import 'package:local_event_finder_frontend/services/auth_service.dart'; // Adjust the import path

class CategoryService {
  final String url = "${Config.baseUrl}/api/Category/GetCategories";
  final AuthService authService = AuthService();

  Future<List<Category>> getAllCategories() async {
    try {
      final token = await authService.getToken(); // Ensure token retrieval is awaited

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
          return Category(
            categoryId: categoryData['categoryId'],
            categoryName: categoryData['categoryName'],
            categoryDescription: categoryData['categoryDescription'],
            iconName: categoryData['icon'],
          );
        }).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Helper method to map the icon data to IconData


}
