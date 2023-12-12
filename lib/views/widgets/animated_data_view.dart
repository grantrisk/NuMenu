import 'package:flutter/material.dart';
import 'package:numenu/views/widgets/food_type_view.dart';
import 'package:provider/provider.dart';

import '../../state_management/global_state_service.dart';

/// Dart doc strings for this class

/// This class is a widget that displays the food types, search results, and
/// restaurant information. It will change height depending on the state of the
/// application (searching, viewing results, viewing restaurant info)

class AnimatedDataView extends StatelessWidget {
  const AnimatedDataView({super.key});

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
          return 0;
        case AppState.viewingMap:
          return MediaQuery.of(context).size.height / 2;
        case AppState.loading:
          return 0;
        case AppState.init:
          return MediaQuery.of(context).size.height / 1.2;
        case AppState.minimizedDataView:
          return MediaQuery.of(context).size.height / 10;
        default:
          return 0;
      }
    }

    return Positioned(
      bottom: 0,
      child: Consumer<GlobalStateService>(
        builder: (context, state, child) => GestureDetector(
          onVerticalDragUpdate: (details) {
            // if the app state is not viewing restaurant results, return
            if (state.state != AppState.viewingRestaurantResults) {
              return;
            }

            if (details.delta.dy > 0) {
              Provider.of<GlobalStateService>(context, listen: false)
                  .changeStateTo(AppState.minimizedDataView);
            } else {
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
                Provider.of<GlobalStateService>(context, listen: false).state),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 5.0,
                  offset: const Offset(0, 0),
                ),
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(80),
                topRight: Radius.circular(80),
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Row(
                    // Add two buttons
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.width * 0.05),
                        child: IconButton(
                              onPressed: () => {
                                    Provider.of<GlobalStateService>(context,
                                            listen: false)
                                        .changeStateTo(
                                            AppState.viewingFoodTypes)
                                  },
                              icon: const Icon(Icons.arrow_back)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right  : MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.width * 0.05),
                        child: IconButton(
                            onPressed: () => {
                              Provider.of<GlobalStateService>(context,
                                  listen: false)
                                  .changeStateTo(
                                  AppState.minimizedDataView)
                                },
                            icon: const Icon(Icons.close)),
                      ),
                    ],
                  ),
                    const FoodTypeView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
