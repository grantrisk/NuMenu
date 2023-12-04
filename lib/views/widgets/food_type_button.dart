import 'package:flutter/material.dart';
import 'package:numenu/state_management/global_state_service.dart';
import 'package:provider/provider.dart';

class FoodTypeButton extends StatelessWidget {
  final String buttonText;

  FoodTypeButton({required this.buttonText});

  @override
  Widget build(BuildContext context) {
    // write a void function that changes the state to viewingRestaurantResults

    void changeStateToViewingRestaurantResults() {
      Provider.of<GlobalStateService>(context, listen: false)
          .changeStateTo(AppState.viewingRestaurantResults);
    }

    return GestureDetector(
      onTap: () {
        changeStateToViewingRestaurantResults();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 50,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 251, 181, 29),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6.0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}