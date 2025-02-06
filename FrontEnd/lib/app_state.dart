import 'package:flutter/material.dart';
import 'package:local_event_finder_frontend/services/auth_service.dart';
import 'package:local_event_finder_frontend/services/favorite_service.dart';
import 'model/event.dart'; // Import the Event model

class AppState extends ChangeNotifier {
  final authService = AuthService();
  int _selectedCategoryId = -1;
  String _selectedRegion = 'All';
  DateTime? _selectedDate;
  String? _selectedTime;
  final _favoriteService = FavoriteService();

  List<Event> favoriteEvents = [];
  Set<int> favoriteEventIds = Set(); // To track favorite event IDs

  // Getters for the state variables
  int get selectedCategoryId => _selectedCategoryId;
  String get selectedRegion => _selectedRegion;
  DateTime? get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;

  // Getters for favorite events and event IDs
  List<Event> get favoriteEventsList => favoriteEvents;
  Set<int> get favoriteEventIdsSet => favoriteEventIds;

  // Methods to update the selected category ID, region, date, and time
  void updateCategoryId(int selectedCategoryId) {
    if (_selectedCategoryId != selectedCategoryId) {
      _selectedCategoryId = selectedCategoryId;
      notifyListeners();
    }
  }

  void updateRegion(String selectedRegion) {
    if (_selectedRegion != selectedRegion) {
      _selectedRegion = selectedRegion;
      notifyListeners();
    }
  }

  void updateDate(DateTime? selectedDate) {
    if (_selectedDate != selectedDate) {
      _selectedDate = selectedDate;
      notifyListeners();
    }
  }

  void updateTime(String? selectedTime) {
    if (_selectedTime != selectedTime) {
      _selectedTime = selectedTime;
      notifyListeners();
    }
  }

  // Method to load favorite events
  Future<void> loadFavoriteEvents() async {
    try {
      final userInfo = await authService.getUserInfo();
      final accountId = userInfo?['accountId'];  // Get accountId from user info

      if (accountId == null) {
        print("Error: User not logged in or accountId is missing");
        return;
      }

      final events = await _favoriteService.getFavoriteEvents(accountId);

      if (events != null) {
        // Update state with favorite events
        favoriteEvents = events;
        favoriteEventIds = events.map((event) => event.eventId).toSet();

        // Notify listeners to update UI
        notifyListeners();
      } else {
        print("Error: No favorite events found or error in fetching events.");
      }
    } catch (e) {
      print("Error fetching favorite events: $e");
    }
  }

  // Add event to favorites
  void addToFavorites(int eventId) async {
    final userInfo = await authService.getUserInfo();
    final accountId = userInfo?['accountId'];  // Get accountId from user info

    if (accountId == null) {
      print("Error: User not logged in or accountId is missing");
      return;
    }

    if (!favoriteEventIds.contains(eventId)) {
      favoriteEventIds.add(eventId);  // Add eventId to the set
      await _favoriteService.addFavoriteEvent(accountId, eventId);
      notifyListeners();
    }
  }

  // Remove event from favorites
  void removeFromFavorites(int eventId) async {
    final userInfo = await authService.getUserInfo();
    final accountId = userInfo?['accountId'];  // Get accountId from user info
    print("accountId: $accountId");

    if (accountId == null) {
      print("Error: User not logged in or accountId is missing");
      return;
    }

    if (favoriteEventIds.contains(eventId)) {
      favoriteEventIds.remove(eventId);  // Remove eventId from the set
      await _favoriteService.removeFavoriteEvent(accountId, eventId);
      notifyListeners();
    }
  }
}
