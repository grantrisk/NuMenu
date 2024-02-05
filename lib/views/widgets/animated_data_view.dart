import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:numenu/views/widgets/back_and_close_buttons.dart';
import 'package:numenu/views/widgets/food_type_view.dart';
import 'package:numenu/views/widgets/restaurant_card.dart';
import 'package:numenu/views/widgets/restaurant_results_view.dart';
import 'package:numenu/views/widgets/single_restuarant_view.dart';
import 'package:provider/provider.dart';

import '../../state_management/global_state_service.dart';

/// Dart doc strings for this class

/// This class is a widget that displays the food types, search results, and
/// restaurant information. It will change height depending on the state of the
/// application (searching, viewing results, viewing restaurant info)

class AnimatedDataView extends StatelessWidget {
  AnimatedDataView({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO: Abstract into the controller
    double determineHeight(AppState state) {
      switch (state) {
        case AppState.viewingFoodTypes:
          return MediaQuery.of(context).size.height / 1.25;
        case AppState.viewingRestaurantResults:
          return MediaQuery.of(context).size.height / 1.9;
        case AppState.viewingRestaurantInfo:
          return MediaQuery.of(context).size.height / 1.1;
        case AppState.viewingMap:
          return MediaQuery.of(context).size.height / 2;
        case AppState.loading:
          return 0;
        case AppState.init:
          return 0;
        case AppState.minimizedDataView:
          return MediaQuery.of(context).size.height / 10;
        default:
          return 0;
      }
    }

    return Positioned(
      bottom: 0,
      child: Consumer<GlobalStateService>(
        builder: (context, state, child) {
          if (state.state == AppState.viewingFoodTypes) {
            // _scrollController.jumpTo(0);
          }
          return GestureDetector(
            onVerticalDragUpdate: (details) {
              // if the app state is not viewing restaurant results, return
              if (state.state == AppState.minimizedDataView) {
                Provider.of<GlobalStateService>(context, listen: false)
                    .changeStateTo(AppState.viewingRestaurantResults);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              // TODO: Abstract into the controller
              curve: state.state == AppState.viewingRestaurantResults ||
                      state.state == AppState.minimizedDataView
                  ? Curves.fastEaseInToSlowEaseOut
                  : Curves.fastLinearToSlowEaseIn,
              width: MediaQuery.of(context).size.width,
              height: determineHeight(
                  Provider.of<GlobalStateService>(context, listen: false)
                      .state),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 10.0,
                    offset: const Offset(0, 0),
                  ),
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(65),
                  topRight: Radius.circular(65),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    const BackAndCloseButtons(),
                    Expanded(
                        child: SingleChildScrollView(
                            physics: state.state == AppState.viewingFoodTypes
                                ? const NeverScrollableScrollPhysics()
                                : const AlwaysScrollableScrollPhysics(),
                            child: determineViewVisibility(state.state)))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget determineViewVisibility(AppState state) {
  switch (state) {
    case AppState.viewingFoodTypes:
      return const FoodTypeView();
    case AppState.viewingRestaurantResults:
      return const RestaurantResultsView();
    case AppState.viewingRestaurantInfo:
      return const SingleRestaurantView();
    case AppState.viewingMap:
      return Container();
    case AppState.loading:
      return Container();
    case AppState.init:
      return Container();
    case AppState.minimizedDataView:
      return Container();
    default:
      return Container();
  }
}
