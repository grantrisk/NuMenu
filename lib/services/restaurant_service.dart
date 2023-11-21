import '../api/api_helpers/google_places_api_helper.dart';
import '../models/restaurant.dart';

class RestaurantService {
  Future<List<Restaurant>> getRestaurants({
    required double latitude,
    required double longitude,
    required RestaurantType type,
  }) async {
    return GooglePlacesApiHelper.fetchNearbyRestaurants(
      latitude: latitude,
      longitude: longitude,
      type: type,
    );
  }
}
