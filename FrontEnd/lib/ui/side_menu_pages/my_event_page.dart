import 'package:flutter/material.dart';
import 'package:local_event_finder_frontend/model/event.dart';
import 'package:local_event_finder_frontend/model/region.dart';
import 'package:local_event_finder_frontend/services/guest_service.dart'; // Import the service

import '../../services/event_service.dart';
import '../event_details/event_details_page.dart';
import '../homepage/event_widget.dart';

class MyEventPage extends StatefulWidget {
  final List<Region> regions;
  const MyEventPage({Key? key, required this.regions}) : super(key: key);

  @override
  _MyEventPageState createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {
  late Future<List<Event>?> events;

  @override
  void initState() {
    super.initState();
    events = _fetchEvents(); // Fetch events when the screen loads
  }

  Future<List<Event>?> _fetchEvents() async {
    final eventService=EventService(); // Initialize the GuestService


    return await eventService.getEventsByHost(); // Fetch events from the API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upcoming Events"),
      ),
      body: FutureBuilder<List<Event>?>(
        future: events, // The future that fetches events
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // Handle error
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No upcoming events.")); // Handle empty data
          }

          // If data is loaded, display the events
          final eventList = snapshot.data!;

          return ListView.builder(
            itemCount: eventList.length,
            itemBuilder: (context, index) {
              final event = eventList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EventDetailsPage(event: event, regions: widget.regions),
                    ),
                  );
                },
                child: EventWidget(event: event, regions: widget.regions),
              );
            },
          );
        },
      ),
    );
  }
}
