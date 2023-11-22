import 'package:binder/binder.dart';

/// This class describes the global state of the application. The widgets in the
/// application will watch the global state and react accordingly.
///
/// The process of using NuMenu can be described as the following states.
///   1. Splash Screen
///   2. Food Type Selection
///   3. Restaurant Selection/Results From Food Type
///   4. Restaurant Information
///
/// Some intermediate states are:
///  1. Loading (In between states for processing data)
///  2. Initialization (Very first state)

// map of type string to state

final globalStateRef = StateRef(GlobalState());
final globalStateLogicRef = LogicRef((scope) => GlobalStateLogic(scope));

enum States {
  splashScreen,
  foodTypeSelection,
  restaurantSelection,
  restaurantInfo,
  loading,
  initialization,
}

class GlobalState {
  GlobalState();

  States _state = States.initialization;
  States? _previousState;

  get state => _state;
  get previousState => _previousState;

  GlobalState changeStateTo (updatedState) {
    switch (updatedState) {
      case States.splashScreen:
        _previousState = _state;
        _state = States.splashScreen;
        return this;

      case States.foodTypeSelection:
        _previousState = _state;
        _state = States.foodTypeSelection;
        return this;

      case States.restaurantSelection:
        _previousState = _state;
        _state = States.restaurantSelection;
        return this;

      case States.restaurantInfo:
        _previousState = _state;
        _state = States.restaurantInfo;
        return this;

      case States.loading:
        _previousState = _state;
        _state = States.loading;
        return this;

      case States.initialization:
        _previousState = _state;
        _state = States.initialization;
        return this;

      default:
        _previousState = _state;
        _state = States.initialization;
        return this;
    }
  }
}

class GlobalStateLogic with Logic {
  const GlobalStateLogic(this.scope);

  @override
  final Scope scope;

  void changeStateTo(States updatedState) => write(globalStateRef, read(globalStateRef).changeStateTo(updatedState));

}