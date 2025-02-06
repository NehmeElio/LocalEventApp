import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:local_event_finder_frontend/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../model/category.dart';
import '../../model/event.dart';
import '../../model/guest.dart';
import '../../model/region.dart';
import '../../style_guide.dart';
import '../../app_state.dart';
import '../../services/guest_service.dart';

class EventDetailsContent extends StatefulWidget {
  final List<Region> regions;
  const EventDetailsContent({super.key, required this.regions});

  @override
  _EventDetailsContentState createState() => _EventDetailsContentState();
}

class _EventDetailsContentState extends State<EventDetailsContent> {
  late Future<List<Guest>> guestsFuture;
  late bool isUserJoined; // To track if the user has joined or not

  // Store favorite state locally to minimize rebuilds.
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    final event = Provider.of<Event>(context, listen: false);
    guestsFuture = GuestService().getAllGuests(event.eventId); // Fetch guests when widget is initialized
    isUserJoined = false;
    //isFavorite = Provider.of<AppState>(context, listen: false).favorites.isFavorite(event); // Set the initial favorite state

    // Fetch user info and check if the user is in the guest list
    _checkUserJoined();
  }

  Future<void> _checkUserJoined() async {
    try {
      // Retrieve user info
      final userInfo = await AuthService().getUserInfo();

      if (userInfo != null) {
        final userAccountId = userInfo['accountId']; // Extract accountId from user info

        // Check if the user is in the guest list
        guestsFuture.then((guests) {
          setState(() {
            isUserJoined = guests.any((guest) => guest.accountId == userAccountId);
          });
        });
      } else {
        print('[EventDetails] No user info available');
      }
    } catch (error) {
      print('[EventDetails] Error checking user join status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = Provider.of<Event>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final appState = Provider.of<AppState>(context, listen: false);
    final themeData = Theme.of(context);

    String regionName = "";

    // Find the region for the event
    for (var region in widget.regions) {
      if (region.regionId == event.regionId) {
        regionName = region.regionName;
        break;
      }
    }


    // Check if the current event is in favorites (using favoriteEventIds)
    //var appState = Provider.of<AppState>(context);

    // Check if the current event is in favorites (using favoriteEventIds)
    isFavorite = appState.favoriteEventIdsSet.contains(event.eventId);

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 100),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
                child: Text(
                  event.title,
                  style: eventWhiteTitleTextStyle,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.24),
                child: FittedBox(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "-",
                        style: eventLocationTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        regionName,
                        style: eventLocationTextStyle.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (isUserJoined) {
                      _unjoinEvent(event.eventId);
                    } else {
                      _joinEvent(event.eventId);
                    }
                  },
                  icon: Icon(Icons.how_to_reg),
                  label: Text(isUserJoined ? "Unjoin" : "Join"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeData.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "GUESTS",
                  style: guestTextStyle,
                ),
              ),
              FutureBuilder<List<Guest>>(
                future: guestsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: snapshot.data!.map((guest) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: ClipOval(
                              child: guest.profilePicture != null && guest.profilePicture!.isNotEmpty
                                  ? Image.memory(
                                guest.profilePicture!,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              )
                                  : Icon(Icons.account_circle, size: 90),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return Text('No guests available');
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: event.punchLine1,
                      style: punchLine1TextStyle,
                    ),
                    TextSpan(
                      text: event.punchLine2,
                      style: punchLine2TextStyle,
                    ),
                  ]),
                ),
              ),
              if (event.description != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    event.description ?? "No Description Available",
                    style: eventLocationTextStyle,
                  ),
                ),
              if (event.galleryImages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
                  child: Text(
                    "GALLERY",
                    style: guestTextStyle,
                  ),
                ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    for (final galleryImagePath in event.galleryImages)
                      Container(
                        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: galleryImagePath.image != null
                              ? Image.memory(
                            galleryImagePath.image!,
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                          )
                              : Container(),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        Positioned(
          top: 40,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      Share.share('Check out this cool event: ${event.title}!');
                    },
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle favorite state
                        if (isFavorite) {
                          appState.removeFromFavorites(event.eventId);
                        } else {
                          appState.addToFavorites(event.eventId);
                        }

                        // Update the favorite state
                        isFavorite = !isFavorite; // This ensures the heart icon toggles
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: isFavorite ? 1.2 : 1.0,
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _joinEvent(int eventId) async {
    final userAccountId = (await AuthService().getUserInfo())?['accountId'];
    if (userAccountId != null) {
      bool success = await GuestService().addGuest(eventId, userAccountId);
      if (success) {
        setState(() {
          isUserJoined = true; // Update UI to show "Unjoin"
          guestsFuture = GuestService().getAllGuests(eventId); // Refresh guest list
        });
      }
    }
  }

  void _unjoinEvent(int eventId) async {
    final userAccountId = (await AuthService().getUserInfo())?['accountId'];
    if (userAccountId != null) {
      bool success = await GuestService().removeGuest(eventId, userAccountId);
      if (success) {
        setState(() {
          isUserJoined = false; // Update UI to show "Join"
          guestsFuture = GuestService().getAllGuests(eventId); // Refresh guest list
        });
      }
    }
  }
}
