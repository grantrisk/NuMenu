import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/restaurant.dart';

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

class GooglePlacesApiHelper {
  static String get _apiKey =>
      dotenv.env['GOOGLE_PLACES_API_KEY'] ??
      (throw Exception('API key not found'));
  static const String _baseUrl =
      'https://places.googleapis.com/v1/places:searchNearby';

  static Future<List<Restaurant>> fetchNearbyRestaurants({
    required double latitude,
    required double longitude,
    required RestaurantType type,
    required int maxResultCount,
    required double radius,
  }) async {
    final typeString = _getTypeString(type);
    final fieldMask =
        'places.displayName,places.formattedAddress,places.rating,places.location';
    // TODO: cache the placeId? (see https://developers.google.com/maps/documentation/places/web-service/place-id)

    Map<String, dynamic> requestBody = {
      'includedTypes': [typeString],
      'maxResultCount': maxResultCount,
      'locationRestriction': {
        'circle': {
          'center': {'latitude': latitude, 'longitude': longitude},
          'radius': radius,
        }
      },
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
      return parsePlaces(response.body);
    } else {
      throw Exception('Failed to load restaurants: ${response.reasonPhrase}');
    }
  }

  static List<Restaurant> parsePlaces(String responseBody) {
    if (responseBody.isEmpty) {
      return [];
    }

    final parsed = json.decode(responseBody);
    if (parsed['places'] == null) {
      return [];
    }

    return parsed['places']
        .map<Restaurant>((json) => Restaurant.fromJson(json))
        .toList();
  }

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
