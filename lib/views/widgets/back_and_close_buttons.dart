import 'package:flutter/material.dart';
import 'package:numenu/views/widgets/animated_text.dart';
import 'package:provider/provider.dart';

import '../../state_management/global_state_service.dart';

class BackAndCloseButtons extends StatelessWidget {
  const BackAndCloseButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer<GlobalStateService>(
            builder: (context, state, child) {
              return Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  top: MediaQuery.of(context).size.width * 0.05,
                ),
                child: showBackButton(state, context), // Assuming showBackButton uses the state
              );
            },
          ),
          Expanded(
            child: Consumer<GlobalStateService>(
              builder: (context, state, child) {
                return determineRestaurantTypeTextVisibility(state)
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: AnimatedTextWidget(
                          text: state.currentRestaurantType.toUpperCase(),
                        ),
                      )
                    : Container();
              },
            ),
          ),
          Consumer<GlobalStateService>(
            builder: (context, state, child) {
              return Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05,
                  top: MediaQuery.of(context).size.width * 0.05,
                ),
                child: showCloseButton(state, context), // Using state and context
              );
            },
          ),
        ],
      ),
    );
  }

  bool determineRestaurantTypeTextVisibility(GlobalStateService state) {
    switch (state.state) {
      case AppState.viewingFoodTypes:
      case AppState.viewingRestaurantInfo:
      case AppState.viewingMap:
      case AppState.loading:
      case AppState.init:
      case AppState.minimizedDataView:
        return false;
      case AppState.viewingRestaurantResults:
        return true;
    }
  }

  Widget showBackButton(GlobalStateService state, BuildContext context) {
    return AnimatedOpacity(
      opacity: state.state == AppState.viewingRestaurantResults ? 1 : 0,
      duration: const Duration(milliseconds: 50),
      child: IconButton(
        onPressed: () {
          Provider.of<GlobalStateService>(context, listen: false)
              .changeStateTo(AppState.viewingFoodTypes);
        },
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }

  Widget showCloseButton(GlobalStateService state, BuildContext context) {
      return AnimatedOpacity(
        opacity: state.state == AppState.viewingRestaurantResults || state.state == AppState.viewingRestaurantInfo ? 1 : 0,
        duration: const Duration(milliseconds: 50),
        child: IconButton(
          onPressed: () {
            if (state.state == AppState.viewingRestaurantInfo) {
              Provider.of<GlobalStateService>(context, listen: false)
                  .changeStateTo(AppState.viewingRestaurantResults);
            } else if (state.state == AppState.viewingRestaurantResults) {
              Provider.of<GlobalStateService>(context, listen: false)
                  .changeStateTo(AppState.minimizedDataView);
            }
          },
          icon: const Icon(Icons.close),
        ),
      );
  }
}
