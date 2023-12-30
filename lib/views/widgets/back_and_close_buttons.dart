import 'package:flutter/material.dart';
import 'package:numenu/views/widgets/animated_text.dart';
import 'package:provider/provider.dart';

import '../../state_management/global_state_service.dart';

class BackAndCloseButtons extends StatelessWidget {
  const BackAndCloseButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              top: MediaQuery.of(context).size.width * 0.05,
            ),
            child: IconButton(
              onPressed: () {
                Provider.of<GlobalStateService>(context, listen: false)
                    .changeStateTo(AppState.viewingFoodTypes);

                // This ensures that there is no scroll offset when the user
                // goes back to the food types view
                Provider.of<GlobalStateService>(context, listen: false)
                    .resetScrollController();
              },
              icon: const Icon(Icons.arrow_back),
            ),
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
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.05,
              top: MediaQuery.of(context).size.width * 0.05,
            ),
            child: IconButton(
              onPressed: () {
                Provider.of<GlobalStateService>(context, listen: false)
                    .changeStateTo(AppState.minimizedDataView);
              },
              icon: const Icon(Icons.close),
            ),
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
}
