import 'dart:convert';
import 'package:http/http.dart' as http;

class GooglePlacesApiHelper {
  static const String _apiKey = 'XXXXXXXXXXXXXX';
  static const String _baseUrl =
      'https://places.googleapis.com/v1/places:searchNearby';

  // Function to fetch nearby restaurants with additional filters
  static Future<String> fetchNearbyRestaurants({
    required double latitude,
    required double longitude,
    List<String> types = const ['restaurant'], // Default to 'restaurant' type
    int maxResultCount = 10, // Default to 10 results
    double radius = 8046.72, // Default radius --> 5 miles in meters
    String fieldMask =
        'places.displayName,places.formattedAddress', // Default fields
    String? rating, // Optional rating filter
  }) async {
    // Build the body based on parameters passed
    Map<String, dynamic> requestBody = {
      'includedTypes': types,
      'maxResultCount': maxResultCount,
      'locationRestriction': {
        'circle': {
          'center': {'latitude': latitude, 'longitude': longitude},
          'radius': radius,
        }
      },
    };

    // If a rating filter is specified, add it to the field mask
    if (rating != null) {
      fieldMask += ',places.rating';
    }

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': _apiKey,
        'X-Goog-FieldMask': fieldMask
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      // Print the entire response body for debugging purposes
      print('Request failed with status: ${response.statusCode}.');
      print('Response body: ${response.body}');
      throw Exception('Failed to load restaurants: ${response.reasonPhrase}');
    }
  }

  // Example function to parse the JSON response and extract a list of places
  static List<Place> parsePlaces(String responseBody) {
    if (responseBody.isEmpty) {
      return [];
    }

    final parsed = json.decode(responseBody);
    return parsed['places'].map<Place>((json) => Place.fromJson(json)).toList();
  }
}

class Place {
  final String name;
  final double? latitude;
  final double? longitude;
  final String? formattedAddress;
  final double? rating;
  // Additional fields from the Advanced SKU
  final String? phoneNumber;
  final String? websiteUri;
  final int? priceLevel;
  // ... Add other fields as needed

  Place({
    required this.name,
    this.latitude,
    this.longitude,
    this.formattedAddress,
    this.rating,
    this.phoneNumber,
    this.websiteUri,
    this.priceLevel,
    // ... Initialize other fields as needed
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    var location = json['location'] ?? {};
    // ... Existing parsing logic

    // Parsing additional fields if they are included in the response
    return Place(
      name: json['displayName']['text'],
      latitude: (location['latitude'] as num?)?.toDouble(),
      longitude: (location['longitude'] as num?)?.toDouble(),
      formattedAddress: json['formattedAddress'] as String?,
      rating: json.containsKey('rating')
          ? (json['rating'] as num?)?.toDouble()
          : null,
      phoneNumber: json['internationalPhoneNumber'] as String?,
      websiteUri: json['websiteUri'] as String?,
      priceLevel: json['priceLevel'] as int?,
      // ... Parse other fields as needed
    );
  }
}
