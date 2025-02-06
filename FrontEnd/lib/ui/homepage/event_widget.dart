import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app_state.dart';
import '../../model/event.dart';
import 'package:local_event_finder_frontend/style_guide.dart';
import 'package:provider/provider.dart'; // Import provider for access to AppState
import '../../model/region.dart'; // Import the Regions model

class EventWidget extends StatefulWidget {
  final Event event;
  final List<Region> regions;
  const EventWidget({super.key, required this.event, required this.regions});

  @override
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  bool isFavorite = false; // Track favorite state
  String regionName = "";

  @override
  Widget build(BuildContext context) {
    // Look up the region name based on event's regionId
    regionName = widget.regions.firstWhere(
          (region) => region.regionId == widget.event.regionId,
      orElse: () => Region(regionId: -1, regionName: 'Unknown'),
    ).regionName;

    // Fetching the AppState instance
    var appState = Provider.of<AppState>(context);

    // Check if the current event is in favorites (using favoriteEventIds)
    isFavorite = appState.favoriteEventIdsSet.contains(widget.event.eventId);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20),
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: (widget.event.eventImage != null && widget.event.eventImage!.isNotEmpty)
                  ? Image.memory(
                widget.event.eventImage!,
                height: 150,
                width: double.infinity, // Ensures it stretches properly
                fit: BoxFit.fitWidth, // Keeps the image within the container without cropping
              )
                  : Image.asset(
                'assets/event_placeholder.png', // Replace with your actual placeholder asset path
                height: 150,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),

            // Event Title, Region ID, Date/Time & Heart Icon
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns heart to right
                children: <Widget>[
                  // Left Side: Title, Region, and Date/Time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Event Title
                        Text(
                          widget.event.title,
                          style: eventTitleTextStyle,
                        ),
                        const SizedBox(height: 6),

                        // Event Region ID (This can be translated into a region name if needed)
                        Row(
                          children: <Widget>[
                            const Icon(Icons.location_on, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              regionName, // Display region name
                              style: eventLocationTextStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Date & Time (Greyed Out)
                        Text(
                          DateFormat('EEEE, MMM d • HH:mm').format(widget.event.eventDate),
                          style: eventLocationTextStyle.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Side: Favorite Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle favorite state
                        if (isFavorite) {
                          appState.removeFromFavorites(widget.event.eventId);
                        } else {
                          appState.addToFavorites(widget.event.eventId);
                        }

                        // Update the favorite state
                        isFavorite = !isFavorite; // This ensures the heart icon toggles
                      });
                    },
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: isFavorite ? 1.2 : 1.0, // Small bounce effect
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
