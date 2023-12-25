import 'package:flutter/foundation.dart';
import 'package:numenu/api/api.dart';

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

  // When the map is focused and the white box is closed
  viewingMap,

  loading,

  minimizedDataView
}

/// The only component that can change the state of the application.
class GlobalStateService extends ChangeNotifier {
  GlobalStateService({required this.restaurants});

  final List<Restaurant> restaurants;


  AppState _state = AppState.init;
  // TODO: map of restaurants from api

  // map of string to restaurantType
  Map<String, RestaurantType?> restaurantDetails = {
    "restaurantTypeSelected": null,
    "restaurantList": null,
  };

  AppState get state => _state;

  /// Sets the state of the application
  ///
  /// @param state The state to set the application to
  GlobalStateService changeStateTo(AppState state) {
    _state = state;
    notifyListeners();
    return this;
  }
}