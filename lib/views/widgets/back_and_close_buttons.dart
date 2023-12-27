import 'package:flutter/material.dart';
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
                        child: Text(
                          state.currentRestaurantType.toUpperCase(),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 251, 181, 29),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                          ),
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
