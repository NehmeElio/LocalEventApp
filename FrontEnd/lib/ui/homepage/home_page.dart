import 'package:flutter/material.dart';
import 'package:local_event_finder_frontend/ui/add_event/add_event_page.dart';
import 'package:local_event_finder_frontend/ui/profile_page/profile_page.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../model/category.dart';
import '../../model/event.dart';
import '../../model/region.dart';
import '../../services/category_service.dart'; // Import CategoryService
import '../../services/event_service.dart';
import '../../services/region_service.dart';
import '../event_details/event_details_page.dart';
import '../favorite_events/favorite_event_page.dart';
import 'bottom_bar_widget.dart';
import 'category_widget.dart';
import 'event_widget.dart';
import 'filter_section_widget.dart';
import 'home_page_background.dart';
import 'side_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController(initialPage: 0);

  bool _showScrollToTopButton = false;
  List<Category> _categories = []; // Store fetched categories
  bool _isLoading = true; // Track loading state
  List<Region> _regions = [];

  List<Event> _events = []; // Store fetched events
  bool _isEventsLoading = true; // Track loading state for events

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchEvents();
    _fetchRegions();

    // Load favorite events after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().loadFavoriteEvents();
    });

    _scrollController.addListener(() {
      if (_scrollController.offset > 300) {
        setState(() {
          _showScrollToTopButton = true;
        });
      } else {
        setState(() {
          _showScrollToTopButton = false;
        });
      }
    });
  }


  // Fetch categories from API
  Future<void> _fetchCategories() async {
    try {
      List<Category> categories = await CategoryService().getAllCategories();

      setState(() {
        _categories = [
          Category(categoryId: -1, categoryName: "All", categoryDescription: 'all categories', iconName: 'Icons.category') // Add the "All" category
        ]..addAll(categories); // Append the fetched categories
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching categories: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchRegions() async {
    try {
      List<Region> regions = await RegionService().getAllRegions();
      setState(() {
        _regions = regions;
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  // Fetch events from API
  Future<void> _fetchEvents() async {
    try {
      List<Event>? events = await EventService().getEvents(); // Assuming EventService has a method getEvents()
      setState(() {
        _events = events ?? [];
        _isEventsLoading = false;
      });
    } catch (e) {
      print("Error fetching events: $e");
      setState(() {
        _isEventsLoading = false;
      });
    }
  }

  String _getEventTimePeriod(DateTime eventDateTime) {
    final hour = eventDateTime.hour;
    if (hour >= 5 && hour < 12) return 'Morning';
    if (hour >= 12 && hour < 17) return 'Afternoon';
    return 'Evening';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: SideMenu(regions: _regions,),
      body: Stack(
        children: <Widget>[
          HomePageBackground(screenHeight: MediaQuery.of(context).size.height),
          SafeArea(
            child: PageView(
              controller: _pageController,
              children: [
                // First page (HomePage)
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.menu, color: Color(0x99FFFFFF), size: 30),
                              onPressed: () {
                                scaffoldKey.currentState?.openDrawer();
                              },
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.person_outline, color: Color(0x99FFFFFF), size: 30),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProfilePage()),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: FilterSection(regions: _regions,events:_events),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: _isLoading
                            ? Center(child: CircularProgressIndicator()) // Show loader while fetching categories
                            : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _categories
                                .map((category) => CategoryWidget(category: category))
                                .toList(),
                          ),
                        ),
                      ),
                      // Show loading indicator for events if they are being fetched
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: _isEventsLoading
                            ? Center(child: CircularProgressIndicator()) // Show loader while fetching events
                            : Consumer<AppState>(
                          builder: (context, appState, _) {
                            // Get selected category ID from AppState
                            int selectedCategoryId = appState.selectedCategoryId;
                            String selectedRegion = appState.selectedRegion;
                            String? selectedTime = appState.selectedTime;
                            DateTime? selectedDate = appState.selectedDate;

                            int regionId = _regions
                                .where((r) => r.regionName == selectedRegion)
                                .map((r) => r.regionId)
                                .firstOrNull ?? -1;

                            // Filter events based on selected filters
                            List<Event> filteredEvents = _events.where((event) {
                              bool matchesCategory = selectedCategoryId == -1 || event.categoryId.contains(selectedCategoryId);
                              bool matchesRegion = selectedRegion == 'All' || event.regionId == regionId;
                              bool matchesDate = selectedDate == null || (event.eventDate.year == selectedDate.year && event.eventDate.month == selectedDate.month && event.eventDate.day == selectedDate.day);
                              bool matchesTime = selectedTime == null || _getEventTimePeriod(event.eventDate) == selectedTime;

                              return matchesCategory && matchesRegion && matchesDate && matchesTime;
                            }).toList();

                            print("🎯 Filtered events count: ${filteredEvents.length}");

                            return Column(
                              children: filteredEvents.isNotEmpty
                                  ? filteredEvents.map((event) => GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EventDetailsPage(event: event, regions: _regions,),
                                    ),
                                  );
                                },
                                child: EventWidget(event: event, regions: _regions,),
                              )).toList()
                                  : [Center(child: Text("No events available", style: TextStyle(color: Colors.white)))], // Show a message if no events
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Second page (AddEventPage)
                AddEventPage(),
                FavoriteEventPage(regions: _regions,),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _showScrollToTopButton
          ? FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: Color(0xFFFF4700),
        child: Icon(Icons.arrow_upward),
      )
          : null,
      bottomNavigationBar: BottomBar(pageController: _pageController),
    );
  }
}
