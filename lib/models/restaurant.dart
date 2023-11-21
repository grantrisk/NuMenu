import 'package:latlong2/latlong.dart';

class Restaurant {
  final String name;
  final String address;
  final double rating;
  final LatLng location;

  Restaurant(
      {required this.name,
      required this.address,
      required this.rating,
      required this.location});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['displayName']['text'] ?? 'Unknown Name',
      address: json['formattedAddress'] ?? 'Unknown Address',
      location: LatLng(
        json['location']['latitude'],
        json['location']['longitude'],
      ),
      rating:
          (json['rating'] != null) ? (json['rating'] as num).toDouble() : 0.0,
    );
  }
}
