import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/category.dart';
import '../../model/event.dart';
import '../../model/region.dart';
import '../../services/category_service.dart';
import '../../services/region_service.dart';
import '../../services/event_service.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController punchLine1Controller = TextEditingController();
  final TextEditingController punchLine2Controller = TextEditingController();

  DateTime? eventDateTime;
  String? selectedCategory;
  String? selectedLocation;
  List<Category> categories = [];
  List<Region> locations = [];
  List<String> galleryImages = [];
  XFile? eventImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  final EventService _eventService = EventService();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchRegions();
  }

  Future<void> _saveEvent() async {
    if (titleController.text.isEmpty ||
        eventDateTime == null ||
        selectedCategory == null ||
        selectedLocation == null ||
        punchLine1Controller.text.isEmpty ||
        punchLine2Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Convert gallery image paths to XFile objects
      List<XFile> galleryXFiles = galleryImages.map((path) => XFile(path)).toList();

      // Get the region and category IDs
      Region selectedRegionObj = locations.firstWhere(
              (region) => region.regionName == selectedLocation
      );
      Category selectedCategoryObj = categories.firstWhere(
              (category) => category.categoryName == selectedCategory
      );
      print("category id +${selectedCategoryObj.categoryId}");
      print("before sending ${eventDateTime!}");


      final success = await _eventService.addEvent(
        title: titleController.text,
        description: descriptionController.text,
        regionId: selectedRegionObj.regionId,
        date: eventDateTime!,
        categoryId: selectedCategoryObj.categoryId,
        punchLine1: punchLine1Controller.text,
        punchLine2: punchLine2Controller.text,
        eventImage: eventImage, // Replace with actual host ID from your auth system
        galleryImages: galleryXFiles,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event Created Successfully!")),
        );// Return to previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to create event. Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating event: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickEventImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        eventImage = pickedFile;
      });
    }
  }

  Future<void> _pickImages() async {
    if (galleryImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only add up to 5 images.")),
      );
      return;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        galleryImages.add(pickedFile.path);
      });
    }
  }

  Future<void> _fetchCategories() async {
    try {
      List<Category> fetchedCategories = await CategoryService().getAllCategories();
      setState(() {
        categories = fetchedCategories;
        if (categories.isNotEmpty) {
          selectedCategory = categories[0].categoryName;
        }
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> _fetchRegions() async {
    try {
      List<Region> fetchedRegions = await RegionService().getAllRegions();
      setState(() {
        locations = fetchedRegions;
        if (locations.isNotEmpty) {
          selectedLocation = locations[0].regionName;
        }
      });
    } catch (e) {
      print("Error fetching regions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Event'),
        backgroundColor: themeData.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            const Text("Event Image (1 image only)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (eventImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(eventImage!.path),  // Use .path to get the file path from XFile
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              )
            else
              GestureDetector(
                onTap: _pickEventImage,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: themeData.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.add_a_photo,
                      color: themeData.primaryColor, size: 40),
                ),
              ),
            const SizedBox(height: 16),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(),
                hintText: 'Enter event title',
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                hintText: 'Enter event description',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedLocation,
              hint: const Text('Select a location'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocation = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              items: locations.map((Region region) {
                return DropdownMenuItem<String>(
                  value: region.regionName,
                  child: Text(region.regionName),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  onConfirm: (date) {
                    setState(() {
                      print(date);
                      eventDateTime = date;
                    });
                  },
                  currentTime: eventDateTime ?? DateTime.now(),
                  locale: LocaleType.en,
                );
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: TextEditingController(
                    text: eventDateTime == null
                        ? "Select event date & time"
                        : DateFormat('yyyy-MM-dd HH:mm').format(eventDateTime!),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Event Date & Time',
                    border: OutlineInputBorder(),
                    hintText: 'Select event date & time',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              hint: const Text('Select a category'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: categories.map((Category category) {
                return DropdownMenuItem<String>(
                  value: category.categoryName,
                  child: Text(category.categoryName),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: punchLine1Controller,
              decoration: const InputDecoration(
                labelText: 'Punchline 1',
                border: OutlineInputBorder(),
                hintText: 'Enter punchline 1',
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: punchLine2Controller,
              decoration: const InputDecoration(
                labelText: 'Punchline 2',
                border: OutlineInputBorder(),
                hintText: 'Enter punchline 2',
              ),
            ),
            const SizedBox(height: 16),

            const Text("Gallery Images (Max 5)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: [
                ...galleryImages.map((path) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(path),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                )),
                if (galleryImages.length < 5)
                  GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: themeData.primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.add_a_photo,
                          color: themeData.primaryColor, size: 40),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeData.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Save Event',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}