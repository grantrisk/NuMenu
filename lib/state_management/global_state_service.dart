import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:numenu/api/api.dart';

import '../services/location_service.dart';

/// This service allows you to change the global state of the application
///
/// The application will always be in one of the following states:

enum AppState {
  /// The initial state of the application
  init,

  /// The state of the application when the user is selecting a food type
  viewingFoodTypes,

  /// The state of the application when the user is searching for restaurants
  viewingRestaurantResults,

  /// The state of the application when the user is viewing the restaurant info
  viewingRestaurantInfo,

  /// When the map is focused and the white box is closed
  viewingMap,

  loading,

  minimizedDataView
}

/// These are the categorized restaurant types

final List<RestaurantType> americanTypes = [
  RestaurantType.americanRestaurant,
  RestaurantType.barbecueRestaurant,
  RestaurantType.breakfastRestaurant,
  RestaurantType.brunchRestaurant,
  RestaurantType.hamburgerRestaurant,
  RestaurantType.steakHouse
];

final List<RestaurantType> mexicanTypes = [
  RestaurantType.mexicanRestaurant
];

final List<RestaurantType> italianTypes = [
  RestaurantType.italianRestaurant,
  RestaurantType.pizzaRestaurant
];

final List<RestaurantType> asianTypes = [
  RestaurantType.chineseRestaurant,
  RestaurantType.indianRestaurant,
  RestaurantType.indonesianRestaurant,
  RestaurantType.japaneseRestaurant,
  RestaurantType.koreanRestaurant,
  RestaurantType.ramenRestaurant,
  RestaurantType.sushiRestaurant,
  RestaurantType.thaiRestaurant,
  RestaurantType.vietnameseRestaurant
];

final List<RestaurantType> mediterraneanTypes = [
  RestaurantType.greekRestaurant,
  RestaurantType.lebaneseRestaurant,
  RestaurantType.mediterraneanRestaurant,
  RestaurantType.turkishRestaurant
];

final List<RestaurantType> anyTypes = [
  RestaurantType.bakery,
  RestaurantType.bar,
  RestaurantType.cafe,
  RestaurantType.coffeeShop,
  RestaurantType.fastFoodRestaurant,
  RestaurantType.frenchRestaurant,
  RestaurantType.iceCreamShop,
  RestaurantType.mealDelivery,
  RestaurantType.mealTakeaway,
  RestaurantType.middleEasternRestaurant,
  RestaurantType.restaurant,
  RestaurantType.sandwichShop,
  RestaurantType.seafoodRestaurant,
  RestaurantType.spanishRestaurant,
  RestaurantType.veganRestaurant,
  RestaurantType.vegetarianRestaurant
];

/// The only component that can change the state of the application.
class GlobalStateService extends ChangeNotifier {

  late List<Restaurant>? restaurants;

  GeneralRestaurantType restaurantType = GeneralRestaurantType.any;

  List<RestaurantType> apiResTypes = anyTypes;

  final ScrollController _scrollController = ScrollController();

  /// When the user selects a restaurant to view, this will hold its info.
  late Map<String, dynamic> selectedResInfo;

  AppState _state = AppState.viewingFoodTypes;

  AppState get state => _state;

  String get currentRestaurantType => restaurantType.name;

  ScrollController get scrollController => _scrollController;

  void resetScrollController() {
    _scrollController.jumpTo(0);
  }

  void changeRestaurantTypeTo(GeneralRestaurantType type) async {
    restaurantType = type;
    restaurants = null;
    Position position = await LocationService.getCurrentLocation();

    try {
      switch (type) {
        case GeneralRestaurantType.american:
          apiResTypes = americanTypes;
          restaurants = await loadRestaurants(position, americanTypes);
          break;
        case GeneralRestaurantType.mexican:
          apiResTypes = mexicanTypes;
          restaurants = await loadRestaurants(position, mexicanTypes);
          break;
        case GeneralRestaurantType.italian:
          apiResTypes = italianTypes;
          restaurants = await loadRestaurants(position, italianTypes);
          break;
        case GeneralRestaurantType.asian:
          apiResTypes = asianTypes;
          restaurants = await loadRestaurants(position, asianTypes);
          break;
        case GeneralRestaurantType.mediterranean:
          apiResTypes = mediterraneanTypes;
          restaurants = await loadRestaurants(position, mediterraneanTypes);
          break;
        case GeneralRestaurantType.any:
          apiResTypes = anyTypes;
          restaurants = await loadRestaurants(position, anyTypes);
          break;
      }
    } catch (error) {
      // Handle the error, possibly logging it or showing a user-friendly message
      print('Failed to load restaurants: $error');
    }
    notifyListeners();
  }


  void changeSelectedRestaurantTo(Map<String,dynamic> newResInfo) {
    selectedResInfo = newResInfo;
    notifyListeners();
  }

  Future<List<Restaurant>> loadRestaurants(Position position, List<RestaurantType> resTypes) async {
    final service = RestaurantService();
    final newRestaurants = await service.getRestaurants(
      latitude: position.latitude,
      longitude: position.longitude,
      types: resTypes,
      maxResultCount: 20,
      radiusInMiles: 3,
    );

    return newRestaurants;
  }



  /// Sets the state of the application
  ///
  /// @param state The state to set the application to
  GlobalStateService changeStateTo(AppState state) {
    _state = state;
    notifyListeners();
    return this;
  }
}