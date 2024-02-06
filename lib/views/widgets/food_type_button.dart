import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:numenu/api/api.dart';
import 'package:numenu/state_management/global_state_service.dart';
import 'package:provider/provider.dart';

import '../../services/location_service.dart';

class FoodTypeButton extends StatelessWidget {
  final String buttonText;

  FoodTypeButton({required this.buttonText});

  @override
  Widget build(BuildContext context) {
    void changeStateToViewingRestaurantResults() {
      Provider.of<GlobalStateService>(context, listen: false)
          .changeStateTo(AppState.viewingRestaurantResults);
    }

    void setRestaurantType(buttonText) async {
      switch (buttonText) {
        case 'MEXICAN':
          print('mexican');
          Provider.of<GlobalStateService>(context, listen: false)
              .changeRestaurantTypeTo(GeneralRestaurantType.mexican);
          break;
        case 'ITALIAN':
          Provider.of<GlobalStateService>(context, listen: false)
              .changeRestaurantTypeTo(GeneralRestaurantType.italian);
          break;
        case 'AMERICAN':
          Provider.of<GlobalStateService>(context, listen: false)
              .changeRestaurantTypeTo(GeneralRestaurantType.american);
          break;
        case 'ASIAN':
          Provider.of<GlobalStateService>(context, listen: false)
              .changeRestaurantTypeTo(GeneralRestaurantType.asian);
          break;
        case 'MEDITERRANEAN':
          Provider.of<GlobalStateService>(context, listen: false)
              .changeRestaurantTypeTo(GeneralRestaurantType.mediterranean);
          break;
        case 'SOMETHING, IM HUNGRY':
          Provider.of<GlobalStateService>(context, listen: false)
              .changeRestaurantTypeTo(GeneralRestaurantType.any);
          break;
        default:
          Provider.of<GlobalStateService>(context, listen: false)
              .changeRestaurantTypeTo(GeneralRestaurantType.any);

      }
    }

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    var buttonWidth = screenWidth * 0.05;
    var buttonHeight = screenHeight * 0.055;

    return GestureDetector(
      onTap: () {
        changeStateToViewingRestaurantResults();
        setRestaurantType(buttonText);
      },
      child: Container(
          width: buttonWidth,
          height: buttonHeight,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 251, 181, 29),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 6.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
    );
  }
}