import 'package:flutter/material.dart';

class Category {
  final int categoryId;
  final String categoryName;
  final String categoryDescription;
  final String iconName; // Store icon as a string

  Category({required this.categoryId, required this.categoryName,required this.categoryDescription, required this.iconName});

  IconData get icon {
    return _iconFromString(iconName);
  }

  static IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'Icons.music_note':
        return Icons.music_note;
      case 'Icons.sports_soccer':
        return Icons.sports_soccer;
      case 'Icons.fastfood':
        return Icons.fastfood;
      case 'Icons.computer':
        return Icons.computer;
      case 'Icons.brush':
        return Icons.brush;
      case 'Icons.school':
        return Icons.school;
      case 'Icons.fitness_center':
        return Icons.fitness_center;
      case 'Icons.volunteer_activism':
        return Icons.volunteer_activism;
      case 'Icons.airplanemode_active':
        return Icons.airplanemode_active;
      case 'Icons.business_center':
        return Icons.business_center;
      case 'Icons.category':
        return Icons.category;
      default:
        return Icons.help_outline; // Default if no match
    }
  }


}
