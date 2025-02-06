import 'dart:convert';
import 'dart:typed_data';

class Event {
  final int eventId;
  final String title;
  final String? description;
  final int regionId;
  final DateTime eventDate;
  final String punchLine1;
  final String punchLine2;
  final Uint8List? eventImage; // Event image as byte array
  final int hostId;
  final List<ImageGalleryDTO> galleryImages; // List of gallery images
  final List<int> categoryId; // List of category IDs

  Event({
    required this.eventId,
    required this.title,
    this.description,
    required this.regionId,
    required this.eventDate,
    required this.punchLine1,
    required this.punchLine2,
    this.eventImage,
    required this.hostId,
    required this.galleryImages,
    required this.categoryId,
  });

  // Factory method to map from JSON to Event
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['eventId'],
      title: json['title'],
      description: json['description'],
      regionId: json['regionId'],
      eventDate: DateTime.parse(json['eventDate']),
      punchLine1: json['punchline1'] ?? json['Punchline1'] ?? '',
      punchLine2: json['punchline2'] ?? json['Punchline2'] ?? '',
      eventImage: processImage(json['eventImage']),
      hostId: json['hostId'],
      galleryImages: (json['galleryImages'] as List?)
          ?.map((item) => ImageGalleryDTO.fromJson(item))
          .toList() ??
          [],
      categoryId: (json['categoryId'] is List)
          ? List<int>.from(json['categoryId'])
          : [],
    );
  }

  static Uint8List? processImage(dynamic imageData) {
    if (imageData == null) return null;
    if (imageData is Uint8List) return imageData;
    if (imageData is List<int>) return Uint8List.fromList(imageData);
    if (imageData is String) {
      try {
        return Uint8List.fromList(base64Decode(imageData));
      } catch (e) {
        print('Image decoding error: $e');
        return null;
      }
    }
    return null;
  }
}

// ImageGalleryDTO for representing each gallery image
class ImageGalleryDTO {
  final int imageGalleryId;
  final Uint8List? image; // Now matches eventImage type

  ImageGalleryDTO({
    required this.imageGalleryId,
    this.image,
  });

  factory ImageGalleryDTO.fromJson(Map<String, dynamic> json) {
    return ImageGalleryDTO(
      imageGalleryId: json['imageGalleryId'] ?? 0,
      image: Event.processImage(json['image']), // Use the same image processing
    );
  }
}
