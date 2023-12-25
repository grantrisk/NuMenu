import 'package:flutter/material.dart';
import 'package:numenu/views/widgets/food_type_button.dart';

class FoodTypeView extends StatelessWidget {
  const FoodTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> items = ['MEXICAN', 'ITALIAN', 'AMERICAN', 'ASIAN', 'MEDITERRANEAN', 'SOMETHING, IM HUNGRY'];

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    var buttonPadding = EdgeInsets.fromLTRB(
      screenWidth * 0.15,
      screenHeight * 0.025,
      screenWidth * 0.15,
      screenHeight * 0.01,
    );

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
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: (index == 0)
                    ? EdgeInsets.fromLTRB(screenWidth * 0.15, 0.00, screenWidth * 0.15, screenHeight * 0.01)
                    : buttonPadding,
                child: FoodTypeButton(buttonText: items[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
