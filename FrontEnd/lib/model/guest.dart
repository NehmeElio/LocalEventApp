import 'dart:convert';
import 'dart:typed_data'; // Importing Uint8List

class Guest {
  final int accountId;
  final Uint8List? profilePicture; // Store the profile picture as a Uint8List (byte array)

  Guest({required this.accountId, this.profilePicture});

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      accountId: json['accountId'],
      profilePicture: processImage(json['profilePicture'])
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



// Sample guest data (Note that in your real scenario, you'd fetch this from the API)
// final guests = [
//   Guest(accountId: 1, profilePicture: null), // No profile picture
//   Guest(accountId: 2, profilePicture: Uint8List.fromList([/* byte data here */])),
// ];
