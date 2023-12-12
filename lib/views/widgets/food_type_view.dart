import 'package:flutter/material.dart';
import 'package:numenu/state_management/global_state_service.dart';
import 'package:numenu/views/widgets/food_type_button.dart';
import 'package:provider/provider.dart';

class FoodTypeView extends StatelessWidget {
  const FoodTypeView({Key? key});

  @override
  Widget build(BuildContext context) {
    List<String> items = ['MEXICAN', 'ITALIAN', 'AMERICAN', 'ASIAN', 'MEDITERRANEAN', 'SOMETHING, IM HUNGRY'];

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    var buttonPadding = EdgeInsets.fromLTRB(
      screenWidth * 0.03,
      screenHeight * 0.025,
      screenWidth * 0.03,
      screenHeight * 0.01,
    );

    var count = 0;
    return Consumer<GlobalStateService>(
      builder: (context, state, child) {
        if (state.state == AppState.viewingFoodTypes) {
          return Column(
            children: [
              const Text(
                'FOOD TYPES',
                style: TextStyle(
                  color: Color.fromARGB(255, 251, 181, 29),
                  fontSize: 34.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                "WHAT'S YOUR MOOD?",
                style: TextStyle(
                  color: Color.fromARGB(255, 251, 181, 29),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.15,
                  MediaQuery.of(context).size.width * 0.0,
                  MediaQuery.of(context).size.width * 0.15,
                  0,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          if (count == 0) {
                            count++;
                            return Padding(
                              padding: EdgeInsets.fromLTRB(screenWidth * 0.03, 0, screenWidth * 0.03, screenHeight * 0.01),
                              child: FoodTypeButton(buttonText: items[index]),
                            );
                          } else {
                            count++;
                            return Padding(
                              padding: buttonPadding,
                              child: FoodTypeButton(buttonText: items[index]),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container(); // Return an empty Container or another widget as needed
        }
      },
    );
  }
}

