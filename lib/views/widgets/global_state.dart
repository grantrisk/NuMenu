import 'package:flutter/material.dart';

enum GlobalStateTypes {
  viewingFoodTypeSelection,
  viewingRestaurantsResults,
  viewingRestaurantDetails,
  loading,
  init,
}

class GlobalStateNotifier extends ChangeNotifier {
  GlobalStateTypes _state = GlobalStateTypes.init;
  double _height = 70.0;

  GlobalStateTypes get state => _state;

  double? get height => _height;

  static final GlobalStateNotifier _instance = GlobalStateNotifier._internal();

  factory GlobalStateNotifier() {
    return _instance;
  }

  GlobalStateNotifier._internal();

  void changeStateTo(GlobalStateTypes newState) {
    _state = newState;
    _changeHeight(newState);
    notifyListeners();
  }

  void _changeHeight(GlobalStateTypes newState) {
    switch (newState) {
      case GlobalStateTypes.viewingFoodTypeSelection:
        _height = 300;
        break;
      case GlobalStateTypes.viewingRestaurantsResults:
        _height = 500;
        break;
      case GlobalStateTypes.viewingRestaurantDetails:
        _height = 700;
        break;
      case GlobalStateTypes.loading:
        _height = 100;
        break;
      default:
        _height = 0;
        break;
    }
  }
}

