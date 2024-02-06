import 'package:flutter/material.dart';
import 'package:numenu/views/widgets/animated_text.dart';
import 'package:provider/provider.dart';

import '../../state_management/global_state_service.dart';

class BackAndCloseButtons extends StatelessWidget {
  const BackAndCloseButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.width * 0.05),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<GlobalStateService>(
              builder: (context, state, child) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.07,
                    top: MediaQuery.of(context).size.width * 0.07,
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
                            top: MediaQuery.of(context).size.width * 0.07,
                            left: MediaQuery.of(context).size.width * 0.04
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
                    right: MediaQuery.of(context).size.width * 0.07,
                    top: MediaQuery.of(context).size.width * 0.07,
                  ),
                  child: showCloseButton(state, context), // Using state and context
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool determineRestaurantTypeTextVisibility(GlobalStateService state) {
    return state.state == AppState.viewingRestaurantResults;
  }


  Widget showBackButton(GlobalStateService state, BuildContext context) {
    return AnimatedOpacity(
      opacity: state.state == AppState.viewingRestaurantResults ? 1 : 0,
      duration: const Duration(milliseconds: 50),
      child: GestureDetector(
        onTap: () {
          Provider.of<GlobalStateService>(context, listen: false)
              .changeStateTo(AppState.viewingFoodTypes);
        },
        child: Image.asset('icons/back_button.png'), // Replace with your image asset
      ),
    );
  }


  Widget showCloseButton(GlobalStateService state, BuildContext context) {
    return AnimatedOpacity(
      opacity: state.state == AppState.viewingRestaurantResults || state.state == AppState.viewingRestaurantInfo ? 1 : 0,
      duration: const Duration(milliseconds: 50),
      child: GestureDetector(
        onTap: () {
          if (state.state == AppState.viewingRestaurantInfo) {
            Provider.of<GlobalStateService>(context, listen: false)
                .changeStateTo(AppState.viewingRestaurantResults);
          } else if (state.state == AppState.viewingRestaurantResults) {
            Provider.of<GlobalStateService>(context, listen: false)
                .changeStateTo(AppState.minimizedDataView);
          }
        },
        child: Image.asset('icons/close_button.png'), // Use your image asset path
      ),
    );
  }

}
