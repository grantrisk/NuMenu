import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:numenu/state_management/global_state_service.dart';
import 'package:numenu/views/widgets/restaurant_card.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../models/restaurant.dart';

class RestaurantResultsView extends StatefulWidget {
  const RestaurantResultsView({Key? key}) : super(key: key);

  @override
  _RestaurantResultsViewState createState() => _RestaurantResultsViewState();
}

class _RestaurantResultsViewState extends State<RestaurantResultsView>
    with TickerProviderStateMixin {
  late List<AnimationController> _fadeControllers;
  bool loading = false;
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

    return Consumer<GlobalStateService>(
      builder: (context, state, child) {
        if (state.restaurants == null) {
          return const Center(
            child: SingleChildScrollView(
              child: Column(
                children: [CircularProgressIndicator()],
              ),
            ),
          );
        }

        if (_fadeControllers.length != state.restaurants!.length) {
          _fadeControllers = state.restaurants!.map((_) => AnimationController(
            vsync: this, // Make sure your class includes TickerProviderStateMixin
            duration: const Duration(milliseconds: 500),
          )..forward()).toList();
        }

        List<Widget>? restaurantCards;

        restaurantCards = state.restaurants!.asMap().entries.map((entry) {
          int index = entry.key;
          Restaurant res = entry.value;

          return Padding(
            padding: index == 0
                ? EdgeInsets.fromLTRB(screenWidth * 0.05, 0.00, screenWidth * 0.05, screenHeight * 0.01)
                : buttonPadding,
            child: FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(_fadeControllers[index]),
              child: RestaurantCard(
                resName: res.name,
                address: res.address,
                rating: res.rating,
                latLng: res.location,
              ),
            ),
          );
        }).toList();

        return SingleChildScrollView(
          child: Column(
            children: restaurantCards,
          ),
        );
      },
    );
  }
}
