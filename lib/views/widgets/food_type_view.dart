import 'package:flutter/material.dart';
import 'package:numenu/state_management/global_state_service.dart';
import 'package:numenu/views/widgets/food_type_button.dart';
import 'package:provider/provider.dart';

class FoodTypeView extends StatelessWidget {
  const FoodTypeView({Key? key});

  @override
  Widget build(BuildContext context) {
    List<String> items = ['Button 1', 'Button 2', 'Button 3', 'Button 4'];
    return Consumer<GlobalStateService>(
      builder: (context, state, child) {
        if (state.state == AppState.viewingFoodTypes) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                MediaQuery.of(context).size.width * 0.2,
                MediaQuery.of(context).size.width * 0.05,
                0),
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return FoodTypeButton(buttonText: items[index]);
                },
              ),
            ),
          );
        } else {
          return Container(); // Return an empty Container or another widget as needed
        }
      },
    );
  }
}

