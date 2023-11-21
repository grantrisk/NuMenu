/*
import 'package:test/test.dart';
import 'package:numenu/controllers/google_places_api/google_places_api_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  group('GooglePlacesApiHelper', () {
    test('Fetches nearby restaurants with default parameters and parses them',
        () async {
      await dotenv.load(fileName: ".env");
      // Mocked latitude and longitude for a basic search test
      double latitude = 34.2104;
      double longitude = -77.8868;

      // This test assumes that the API Key and endpoint are valid.
      // In a real-world scenario, you would mock HTTP requests and responses.
      var jsonResponse = await GooglePlacesApiHelper.fetchNearbyRestaurants(
        latitude: latitude,
        longitude: longitude,
      );

      // Print the JSON response in the console
      print('JSON Response with Default Parameters: $jsonResponse');

      // Parse the places from the JSON response
      var places = GooglePlacesApiHelper.parsePlaces(jsonResponse);

      // Print the parsed places in the console
      places.forEach((place) =>
          print('Place: ${place.name}, Address: ${place.formattedAddress}'));

      // Check that the places list is not empty.
      expect(places.isNotEmpty, true);
    });

    test('Fetches nearby restaurants with specific filters and parses them',
        () async {
      // Mocked latitude and longitude for the filtered search test
      double latitude = 34.2104;
      double longitude = -77.8868;

      // Example restaurant types and field mask to include rating
      List<String> types = ['mexican_restaurant', 'american_restaurant'];
      String fieldMask =
          'places.displayName,places.formattedAddress,places.rating';

      // This test assumes that the API Key and endpoint are valid.
      // In a real-world scenario, you would mock HTTP requests and responses.
      var jsonResponse = await GooglePlacesApiHelper.fetchNearbyRestaurants(
        latitude: latitude,
        longitude: longitude,
        types: types,
        fieldMask: fieldMask,
      );

      // Print the JSON response in the console
      print('JSON Response with Filters: $jsonResponse');

      // Parse the places from the JSON response
      var places = GooglePlacesApiHelper.parsePlaces(jsonResponse);

      // Print the parsed places in the console
      places.forEach((place) => print(
          'Place: ${place.name}, Address: ${place.formattedAddress}, Rating: ${place.rating ?? "Not available"}'));

      // Check that the places list is not empty and contains the rating field.
      expect(places.isNotEmpty, true);
      expect(places.every((place) => place.rating != null), true);
    });
  });
}
*/
