import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:numenu/state_management/global_state_service.dart';
import 'package:numenu/views/widgets/restaurant_card.dart';
import 'package:provider/provider.dart';

class RestaurantResultsView extends StatefulWidget {
  const RestaurantResultsView({Key? key}) : super(key: key);

  @override
  _RestaurantResultsViewState createState() => _RestaurantResultsViewState();
}

class _RestaurantResultsViewState extends State<RestaurantResultsView>
    with TickerProviderStateMixin {
  late List<AnimationController> _fadeControllers;

  @override
  void initState() {
    super.initState();

    _fadeControllers = [];

    // Create an AnimationController and a CurvedAnimation for each item
    for (var i = 0; i < 10; i++) {
      var controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );

      // Add a delay to stagger the animations
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted) {
          controller.forward();
        }
      });

      _fadeControllers.add(controller);
    }
  }

  @override
  void dispose() {
    for (var controller in _fadeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    var buttonPadding = EdgeInsets.fromLTRB(
      screenWidth * 0.05,
      screenHeight * 0.01,
      screenWidth * 0.05,
      screenHeight * 0.01,
    );

    /// Here is how I am making the cards at the moment
    ///
    /// When filtering the restaurants, you could use the length of the list
    /// rather than 10.
    List<Widget> restaurantCards = List.generate(10, (index) {
      return Padding(
        padding: (index == 0)
            ? EdgeInsets.fromLTRB(screenWidth * 0.05, 0.00, screenWidth * 0.05,
                screenHeight * 0.01)
            : buttonPadding,
        child: FadeTransition(
          opacity: _fadeControllers[index],
          child: RestaurantCard(
            /// Here, you could access the index of the list of filtered restaurants
            resName: 'Restaurant ${index + 1}',
            address: 'Address ${index + 1}',
            rating: 5,
            latLng: LatLng(0, 0),
          ),
        ),
      );
    });

    return Consumer<GlobalStateService>(
      builder: (context, state, child) {
        return Column(
          children: restaurantCards,
        );
      },
    );
  }
}
