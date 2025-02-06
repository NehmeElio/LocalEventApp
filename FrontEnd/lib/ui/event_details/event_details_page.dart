import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/category.dart';
import '../../model/event.dart';
import '../../model/region.dart';
import 'event_details_background.dart';
import 'event_details_content.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;
  final List<Region> regions;

  const EventDetailsPage({
    super.key,
    required this.event,
    required this.regions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          Provider<Event>.value(value: event), // Provide event
          Provider<List<Region>>.value(value: regions), // Provide categories
        ],
        child: Stack(
          children: <Widget>[
            EventDetailsBackground(),
            EventDetailsContent(regions: regions,), // This widget will consume both event and categories
          ],
        ),
      ),
    );
  }
}
