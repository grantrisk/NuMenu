import '../api/api_helpers/google_places_api_helper.dart';
import '../models/restaurant.dart';

class RestaurantService {
  /// Fetches nearby restaurants from the Google Places API.
  ///
  /// @param latitude The latitude of the user's current location.
  /// @param longitude The longitude of the user's current location.
  /// @param type The type of restaurant to search for.
  /// @param maxResultCount The maximum number of results to return.
  /// @param radiusInMiles The radius in miles to search within.
  ///
  /// @returns A list of restaurants.
  Future<List<Restaurant>> getRestaurants({
    required double latitude,
    required double longitude,
    required RestaurantType type,
    int maxResultCount = 10,
    double radiusInMiles = 5.0, // default radius in miles
  }) async {
    // Convert miles to meters
    double radiusInMeters = radiusInMiles * 1609.34;
    print('Radius in meters: $radiusInMeters');

    return GooglePlacesApiHelper.fetchNearbyRestaurants(
      latitude: latitude,
      longitude: longitude,
      type: type,
      maxResultCount: maxResultCount,
      radius: radiusInMeters,
    );
  }
}
