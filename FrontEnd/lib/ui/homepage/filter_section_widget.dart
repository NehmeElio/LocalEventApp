import 'package:flutter/material.dart';
import 'package:local_event_finder_frontend/ui/homepage/surprise_me_widget.dart';
import 'package:provider/provider.dart';

import '../../model/region.dart';
import '../../app_state.dart'; // Import the AppState provider
import '../../services/region_service.dart';

class FilterSection extends StatefulWidget {
  final List<Region> regions; // Accept regions via constructor
  final List events;

  const FilterSection({super.key, required this.regions, required this.events});

  @override
  _FilterSectionState createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  String? _selectedLocation;
  String? _selectedTime;
  String? _selectedDate;
  void _clearFilters() {
    final appState = context.read<AppState>();
    appState.updateCategoryId(-1);  // Reset category filter to "All"
    appState.updateRegion('All');   // Reset region filter to "All"
    appState.updateDate(null);      // Reset date filter
    appState.updateTime(null);      // Reset time filter
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Compact Filter Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey[800]), // Location icon
                  // Location Dropdown
                  DropdownButton<String>(
                    hint: Text("Location", style: TextStyle(color: Colors.grey[800])),
                    value: _selectedLocation,
                    items: widget.regions.map((Region region) {
                      return DropdownMenuItem<String>(
                        value: region.regionName,  // Assuming regionName is the property in your Region model
                        child: Text(region.regionName, style: TextStyle(color: Colors.grey[800])),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLocation = newValue;
                      });
                      context.read<AppState>().updateRegion(newValue ?? 'All');  // Update AppState with selected region
                    },
                  ),
                ],
              ),

              // Time Dropdown
              DropdownButton<String>(
                hint: Text("Time", style: TextStyle(color: Colors.grey[800])),
                value: _selectedTime,
                items: <String>['Morning', 'Afternoon', 'Evening']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.grey[800])),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTime = newValue;
                  });
                  context.read<AppState>().updateTime(newValue);  // Update AppState with selected time
                },
              ),

              // Date Picker Button
              IconButton(
                icon: Icon(Icons.calendar_today, color: Colors.grey[800]),
                onPressed: () {
                  _selectDate(context);
                },
              ),
            ],
          ),
        ),

        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Aligns items in the center
          children: [
            SupriseMeWidget(events: widget.events,regions: widget.regions,), // Just place it normally
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _clearFilters,
                child: Text(
                  'Clear Filters',
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
            ),
          ],
        ),


        // Search Bar
        // TextField(
        //   decoration: InputDecoration(
        //     prefixIcon: Icon(Icons.search, color: Colors.grey[800]),
        //     hintText: 'Search events',
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(8),
        //       borderSide: BorderSide.none,
        //     ),
        //     filled: true,
        //     fillColor: Colors.grey[200],
        //   ),
        // ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _selectedDate = "${selectedDate.toLocal()}".split(' ')[0]; // Format the date
      });
      context.read<AppState>().updateDate(selectedDate);  // Update AppState with selected date
    }
  }
}
