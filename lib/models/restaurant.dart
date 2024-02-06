import 'package:latlong2/latlong.dart';

enum GeneralRestaurantType {
  mexican,
  italian,
  american,
  asian,
  mediterranean,
  any
}

class Restaurant {
  final String name;
  final String address;
  final double rating;
  final LatLng location;
  final Map<String, dynamic> additionalInfo;

  Restaurant({
    required this.name,
    required this.address,
    required this.rating,
    required this.location,
    this.additionalInfo = const {},
  });

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
      additionalInfo: json,
    );
  }

  @override
  String toString() {
    return 'Restaurant{name: $name, address: $address, rating: $rating, location: (${location.latitude}, ${location.longitude}), additionalInfo: $additionalInfo}';
  }

}
