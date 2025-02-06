import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../model/region.dart';
import '../event_details/event_details_page.dart';

class SupriseMeWidget extends StatelessWidget {
  final List events;
  final List<Region> regions;

  const SupriseMeWidget({super.key, required this.events,required this.regions});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _surpriseMe(context), // Pass context
      backgroundColor: Colors.white,
      child: Icon(Icons.card_giftcard, color: Colors.deepOrange),
    ).animate().shake(duration: 1.seconds, hz: 3); // Adds a fun shake effect
  }

  void _surpriseMe(BuildContext context) {
    if (events.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No events available to surprise you!")),
      );
      return;
    }

    final randomEvent = events[Random().nextInt(events.length)];

    // Show animation before navigating
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.card_giftcard, size: 80, color: Colors.deepOrange)
                .animate()
                .scale(duration: 500.ms)
                .then()
                .fadeOut(duration: 500.ms),
            SizedBox(height: 10),
            Text("Surprise Event Unlocked!",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
                .animate()
                .fadeIn(duration: 300.ms),
          ],
        ),
      ),
    );

    // Delay before navigating to event details
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop(); // Close animation dialog
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EventDetailsPage(event: randomEvent, regions: regions,),
        ),
      );
    });
  }
}
