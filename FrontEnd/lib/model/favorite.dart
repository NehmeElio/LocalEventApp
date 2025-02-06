import 'package:flutter/material.dart';
import 'package:local_event_finder_frontend/model/event.dart';

class Favorite with ChangeNotifier {
  List<Event> _favoriteEvents = [];

  List<Event> get favoriteEvents => _favoriteEvents;

  void addFavorite(Event event) {
    if (!_favoriteEvents.contains(event)) {
      _favoriteEvents.add(event);
      notifyListeners(); // Notify listeners about the update
    }
  }

  void removeFavorite(Event event) {
    _favoriteEvents.remove(event);
    notifyListeners(); // Notify listeners about the update
  }

  bool isFavorite(Event event) {
    return _favoriteEvents.contains(event);
  }
}

//final favorites= Favorite();
