import 'package:flutter/material.dart';
import 'package:local_event_finder_frontend/services/auth_service.dart';
import 'package:local_event_finder_frontend/ui/side_menu_pages/my_event_page.dart';
import 'package:local_event_finder_frontend/ui/sign_in/sign_in_page.dart';

import '../../model/region.dart';
import '../side_menu_pages/upcoming_event.dart';


class SideMenu extends StatelessWidget {
  final iconColor = Colors.grey;
  final textColor = Colors.black;
  final menuColor = const Color(0xFFFDF4E3);
  final boxColor = const Color(0xFFFFDAB9);
  final authService=AuthService();
  final List<Region> regions;

   SideMenu({super.key,required this.regions});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: menuColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: boxColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.event,
                  color: Colors.grey,
                  size: 40,
                ),
                SizedBox(height: 16),
                Text(
                  'Local Event Finder',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ],
            ),
          ),
          // Drawer Items
          ListTile(
            leading: Icon(Icons.home, color: iconColor),
            title: Text('Home', style: TextStyle(color: textColor)),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.event_note, color: iconColor),
            title: Text('My Events', style: TextStyle(color: textColor)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MyEventPage(regions: regions,)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.group, color: iconColor),
            title: Text('Upcoming Events', style: TextStyle(color: textColor)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => UpcomingEventPage(regions: regions,)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: iconColor),
            title: Text('Settings', style: TextStyle(color: textColor)),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
            },
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.logout, color: iconColor),
            title: Text('Logout', style: TextStyle(color: textColor)),
            onTap: () async {
              Navigator.of(context).pop();
              await authService.logout();// Close the drawer
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
