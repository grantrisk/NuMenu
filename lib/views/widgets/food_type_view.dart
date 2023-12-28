import 'package:flutter/material.dart';
import 'package:numenu/views/widgets/food_type_button.dart';
import 'package:provider/provider.dart';

class FoodTypeView extends StatefulWidget {
  const FoodTypeView({Key? key}) : super(key: key);

  @override
  _FoodTypeViewState createState() => _FoodTypeViewState();
}

class _FoodTypeViewState extends State<FoodTypeView> with TickerProviderStateMixin {
  late List<AnimationController> _fadeControllers;
  late AnimationController _textFadeController;
  late Animation<double> _textFadeAnimation;
  late List<String> items;

  @override
  void initState() {
    super.initState();

    items = ['MEXICAN', 'ITALIAN', 'AMERICAN', 'ASIAN', 'MEDITERRANEAN', 'SOMETHING, IM HUNGRY'];

    _fadeControllers = [];

    // This allows each button to have individual fade animations
    for (var i = 0; i < items.length; i++) {
      var controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );

      // This staggers the animations
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted) {
          controller.forward();
        }
      });

      _fadeControllers.add(controller);
    }

    // Initialize the fade animation controller for the text with a curve
    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
      parent: _textFadeController,
      curve: Curves.easeInOut,
    ));

    _textFadeController.forward();
  }

  @override
  void dispose() {
    for (var controller in _fadeControllers) {
      controller.dispose();
    }
    _textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        FadeTransition(
          opacity: _textFadeAnimation,
          child: const Column(
            children: [
              Text(
                'FOOD TYPES',
                style: TextStyle(
                  color: Color.fromARGB(255, 251, 181, 29),
                  fontSize: 34.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "WHAT'S YOUR MOOD?",
                style: TextStyle(
                  color: Color.fromARGB(255, 251, 181, 29),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: (index == 0)
                    ? EdgeInsets.fromLTRB(screenWidth * 0.15, 0.00, screenWidth * 0.15, screenHeight * 0.01)
                    : buttonPadding,
                child: FadeTransition(
                  opacity: _fadeControllers[index],
                  child: FoodTypeButton(buttonText: items[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
