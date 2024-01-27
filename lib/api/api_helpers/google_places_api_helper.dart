import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/restaurant.dart';

/*
 * Google Places API Helper Class
 * This class provides methods to interact with the Google Places API to fetch nearby restaurants.
 * API Documentation: https://developers.google.com/maps/documentation/places/web-service/overview
 */

// Enum representing various restaurant types. These correspond to the 'types' parameter in the Google Places API.
enum RestaurantType {
  americanRestaurant,
  bakery,
  bar,
  barbecueRestaurant,
  brazilianRestaurant,
  breakfastRestaurant,
  brunchRestaurant,
  cafe,
  chineseRestaurant,
  coffeeShop,
  fastFoodRestaurant,
  frenchRestaurant,
  greekRestaurant,
  hamburgerRestaurant,
  iceCreamShop,
  indianRestaurant,
  indonesianRestaurant,
  italianRestaurant,
  japaneseRestaurant,
  koreanRestaurant,
  lebaneseRestaurant,
  mealDelivery,
  mealTakeaway,
  mediterraneanRestaurant,
  mexicanRestaurant,
  middleEasternRestaurant,
  pizzaRestaurant,
  ramenRestaurant,
  restaurant,
  sandwichShop,
  seafoodRestaurant,
  spanishRestaurant,
  steakHouse,
  sushiRestaurant,
  thaiRestaurant,
  turkishRestaurant,
  veganRestaurant,
  vegetarianRestaurant,
  vietnameseRestaurant,
}

// Class that contains various basic field masks for the Google Places API.
class BasicFieldMasks {
  static const String accessibilityOptions = 'places.accessibilityOptions';
  static const String addressComponents = 'places.addressComponents';
// ... Add other fields in the Basic category
}

// Class that contains various advanced field masks for the Google Places API.
class AdvancedFieldMasks {
  static const String currentOpeningHours = 'places.currentOpeningHours';
  static const String internationalPhoneNumber =
      'places.internationalPhoneNumber';
// ... Add other fields in the Advanced category
}

// Class that contains various preferred field masks for the Google Places API.
class PreferredFieldMasks {
  static const String allowsDogs = 'places.allowsDogs';
  static const String curbsidePickup = 'places.curbsidePickup';
// ... Add other fields in the Preferred category
}

class GooglePlacesApiHelper {
  // Retrieves the API key from the environment variables.
  static String get _apiKey =>
      dotenv.env['GOOGLE_PLACES_API_KEY'] ??
      (throw Exception('API key not found'));

  // Base URL for the Google Places API.
  static const String _baseUrl =
      'https://places.googleapis.com/v1/places:searchNearby';

  /*
   * Fetches nearby restaurants based on the specified criteria.
   *
   * Parameters:
   * latitude - Latitude of the search location.
   * longitude - Longitude of the search location.
   * types - List of restaurant types to filter the search (see RestaurantType enum).
   * maxResultCount - Maximum number of results to return (default is 20).
   * radius - Search radius in meters (default is 1000m).
   * languageCode - Language code for the results (default is 'en').
   * rankPreference - Ranking preference for results. Can be 'POPULARITY' (default) or 'DISTANCE'.
   *                'POPULARITY' ranks results based on their popularity.
   *                'DISTANCE' ranks results by their distance from the search location.
   * basicFieldMasks - List of basic field masks to include in the response (see BasicFieldMasks class).
   * advancedFieldMasks - List of advanced field masks to include in the response (see AdvancedFieldMasks class).
   * preferredFieldMasks - List of preferred field masks to include in the response (see PreferredFieldMasks class).
   *
   * Returns a list of Restaurant objects based on the response from the API.
   */
  static Future<List<Restaurant>> fetchNearbyRestaurants({
    required double latitude,
    required double longitude,
    required List<RestaurantType> types,
    int maxResultCount = 20,
    double radius = 1000.0,
    String languageCode = 'en',
    String rankPreference = 'POPULARITY',
    List<String> basicFieldMasks = const [],
    List<String> advancedFieldMasks = const [],
    List<String> preferredFieldMasks = const [],
  }) async {
    final typeStrings = types.map(_getTypeString).toList();
    final combinedFieldMasks = combineFieldMasks(
      basic: basicFieldMasks,
      advanced: advancedFieldMasks,
      preferred: preferredFieldMasks,
    );
    // Include default field masks and combine with additional ones
    final fieldMask =
        'places.displayName,places.formattedAddress,places.rating,places.location' +
            (combinedFieldMasks.isNotEmpty ? ',' : '') +
            combinedFieldMasks.join(',');

    Map<String, dynamic> requestBody = {
      'includedTypes': typeStrings,
      'maxResultCount': maxResultCount,
      'locationRestriction': {
        'circle': {
          'center': {'latitude': latitude, 'longitude': longitude},
          'radius': radius,
        }
      },
      'languageCode': languageCode,
      'rankPreference': rankPreference,
    };

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
      return _parsePlaces(response.body);
    } else {
      throw Exception('Failed to load restaurants: ${response.reasonPhrase}');
    }
  }

  // Combines selected field masks from each category into a single list.
  static List<String> combineFieldMasks({
    List<String> basic = const [],
    List<String> advanced = const [],
    List<String> preferred = const [],
  }) {
    return [...basic, ...advanced, ...preferred];
  }

  // Parses the API response and converts it into a list of Restaurant objects.
  static List<Restaurant> _parsePlaces(String responseBody) {
    final parsed = json.decode(responseBody);
    if (parsed['places'] == null) {
      return [];
    }
    return parsed['places']
        .map<Restaurant>((json) => Restaurant.fromJson(json))
        .toList();
  }

  // Helper method to convert RestaurantType enum values to their corresponding strings for the API request.
  static String _getTypeString(RestaurantType type) {
    switch (type) {
      case RestaurantType.americanRestaurant:
        return 'american_restaurant';
      case RestaurantType.bakery:
        return 'bakery';
      case RestaurantType.bar:
        return 'bar';
      case RestaurantType.barbecueRestaurant:
        return 'barbecue_restaurant';
      case RestaurantType.brazilianRestaurant:
        return 'brazilian_restaurant';
      case RestaurantType.breakfastRestaurant:
        return 'breakfast_restaurant';
      case RestaurantType.brunchRestaurant:
        return 'brunch_restaurant';
      case RestaurantType.cafe:
        return 'cafe';
      case RestaurantType.chineseRestaurant:
        return 'chinese_restaurant';
      case RestaurantType.coffeeShop:
        return 'coffee_shop';
      case RestaurantType.fastFoodRestaurant:
        return 'fast_food_restaurant';
      case RestaurantType.frenchRestaurant:
        return 'french_restaurant';
      case RestaurantType.greekRestaurant:
        return 'greek_restaurant';
      case RestaurantType.hamburgerRestaurant:
        return 'hamburger_restaurant';
      case RestaurantType.iceCreamShop:
        return 'ice_cream_shop';
      case RestaurantType.indianRestaurant:
        return 'indian_restaurant';
      case RestaurantType.indonesianRestaurant:
        return 'indonesian_restaurant';
      case RestaurantType.italianRestaurant:
        return 'italian_restaurant';
      case RestaurantType.japaneseRestaurant:
        return 'japanese_restaurant';
      case RestaurantType.koreanRestaurant:
        return 'korean_restaurant';
      case RestaurantType.lebaneseRestaurant:
        return 'lebanese_restaurant';
      case RestaurantType.mealDelivery:
        return 'meal_delivery';
      case RestaurantType.mealTakeaway:
        return 'meal_takeaway';
      case RestaurantType.mediterraneanRestaurant:
        return 'mediterranean_restaurant';
      case RestaurantType.mexicanRestaurant:
        return 'mexican_restaurant';
      case RestaurantType.middleEasternRestaurant:
        return 'middle_eastern_restaurant';
      case RestaurantType.pizzaRestaurant:
        return 'pizza_restaurant';
      case RestaurantType.ramenRestaurant:
        return 'ramen_restaurant';
      case RestaurantType.restaurant:
        return 'restaurant';
      case RestaurantType.sandwichShop:
        return 'sandwich_shop';
      case RestaurantType.seafoodRestaurant:
        return 'seafood_restaurant';
      case RestaurantType.spanishRestaurant:
        return 'spanish_restaurant';
      case RestaurantType.steakHouse:
        return 'steak_house';
      case RestaurantType.sushiRestaurant:
        return 'sushi_restaurant';
      case RestaurantType.thaiRestaurant:
        return 'thai_restaurant';
      case RestaurantType.turkishRestaurant:
        return 'turkish_restaurant';
      case RestaurantType.veganRestaurant:
        return 'vegan_restaurant';
      case RestaurantType.vegetarianRestaurant:
        return 'vegetarian_restaurant';
      case RestaurantType.vietnameseRestaurant:
        return 'vietnamese_restaurant';
      default:
        throw Exception('Invalid restaurant type: $type');
    }
  }
}
