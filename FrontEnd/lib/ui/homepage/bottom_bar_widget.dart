import 'package:flutter/material.dart';
import 'package:local_event_finder_frontend/ui/add_event/add_event_page.dart';

class BottomBar extends StatelessWidget {
  final PageController pageController;

  const BottomBar({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white.withOpacity(0.05), // More transparent
      elevation: 0, // No shadow
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.grey, size: 30),
            onPressed: () {
              pageController.animateToPage(0,
                  duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
            },
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.grey, size: 30),
            onPressed: () {
              pageController.animateToPage(1,
                  duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.grey, size: 30),
            onPressed: () {
              pageController.animateToPage(2,
                  duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
            },
          ),
        ],
      ),
    );
  }
}
