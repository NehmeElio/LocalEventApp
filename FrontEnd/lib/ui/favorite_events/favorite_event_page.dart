import 'package:flutter/material.dart';
import 'package:local_event_finder_frontend/model/event.dart';
import 'package:local_event_finder_frontend/model/region.dart';
import 'package:local_event_finder_frontend/services/favorite_service.dart';
import 'package:local_event_finder_frontend/ui/event_details/event_details_page.dart';
import '../../services/auth_service.dart';
import '../homepage/event_widget.dart';

class FavoriteEventPage extends StatefulWidget {
  final List<Region> regions;

  const FavoriteEventPage({super.key, required this.regions});

  @override
  _FavoriteEventPageState createState() => _FavoriteEventPageState();
}

class _FavoriteEventPageState extends State<FavoriteEventPage> {
  List<Event> favoriteEvents = [];
  Set<int> favoriteEventIds = Set(); // To keep track of favorite event IDs
  final FavoriteService _favoriteService = FavoriteService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadFavoriteEvents();
  }

  // Fetch favorite events based on the user accountId
  Future<void> _loadFavoriteEvents() async {
    try {
      final userInfo = await _authService.getUserInfo();
      final accountId = userInfo?['accountId'];  // Get accountId from user info

      if (accountId == null) {
        print("Error: User not logged in or accountId is missing");
        return;
      }

      final events = await _favoriteService.getFavoriteEvents(accountId);

      if (events != null && mounted) {
        setState(() {
          favoriteEvents = events;
          favoriteEventIds = events.map((event) => event.eventId).toSet(); // Keep track of favorite event IDs
        });
      } else {
        print("Error: No favorite events found or error in fetching events.");
      }
    } catch (e) {
      print("Error fetching favorite events: $e");
    }
  }

  // Toggle favorite status for an event
  Future<void> _toggleFavorite(Event event) async {
    try {
      final userInfo = await _authService.getUserInfo();
      final accountId = userInfo?['accountId'];

      if (accountId == null) {
        print("Error: User not logged in");
        return;
      }

      final isFavorite = favoriteEventIds.contains(event.eventId); // Check if the event is in favorites

      if (isFavorite) {
        // Remove from favorites if it's already in the list
        await _favoriteService.removeFavoriteEvent(accountId, event.eventId);
        setState(() {
          favoriteEventIds.remove(event.eventId); // Update the local list of favorite event IDs
          favoriteEvents.removeWhere((e) => e.eventId == event.eventId); // Remove event from the UI
        });
      } else {
        // Add to favorites if it's not in the list
        await _favoriteService.addFavoriteEvent(accountId, event.eventId);
        setState(() {
          favoriteEventIds.add(event.eventId); // Add the event ID to the favorites list
          favoriteEvents.add(event); // Add the event to the UI
        });
      }
    } catch (e) {
      print("Error toggling favorite status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: favoriteEvents.isEmpty
          ? Center(child: Text("No favorite events yet!"))
          : ListView.builder(
        itemCount: favoriteEvents.length,
        itemBuilder: (context, index) {
          final event = favoriteEvents[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      EventDetailsPage(event: event, regions: widget.regions),
                ),
              );
            },
            child: EventWidget(
              event: event,
              regions: widget.regions,
              //onFavoriteToggle: () => _toggleFavorite(event), // Pass the function to toggle favorite
            ),
          );
        },
      ),
    );
  }
}
