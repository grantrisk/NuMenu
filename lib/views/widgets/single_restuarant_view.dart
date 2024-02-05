import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:numenu/state_management/global_state_service.dart';
import 'package:numenu/views/widgets/restaurant_card.dart';
import 'package:provider/provider.dart';

class SingleRestaurantView extends StatefulWidget {
  const SingleRestaurantView({Key? key, required Map<String, dynamic> resInfo}) : super(key: key);

  @override
  _SingleRestaurantViewState createState() => _SingleRestaurantViewState();
}

class _SingleRestaurantViewState extends State<SingleRestaurantView>
    with TickerProviderStateMixin {
  late List<AnimationController> _fadeControllers;
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();

    _fadeControllers = [];

    /// This needs to be the length of the images list instead of 10
    for (var i = 0; i < 10; i++) {
      var controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );

      var curvedAnimation = CurvedAnimation(
          parent: controller,
          curve: Curves.fastEaseInToSlowEaseOut // Define the curve
      );

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
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    var squareSize = screenWidth * 0.2; // Example: 20% of the screen width

    var buttonPadding = EdgeInsets.fromLTRB(
      screenWidth * 0.05,
      screenHeight * 0.01,
      screenWidth * 0.05,
      screenHeight * 0.01,
    );

    return Consumer<GlobalStateService>(
      builder: (context, state, child) {
        return Column(
          children: [
            Container(
              height: squareSize + screenHeight * 0.02,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                // TODO
                /// This needs to be the length of the images list
                /// This needs to be the length of the images list
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: buttonPadding,
                    child: FadeTransition(
                      opacity: _fadeControllers[index],
                      // TODO
                      /// Pass in the image as a param
                      /// ```
                      ///  RestaurantImage(image: imagesList[index])
                      /// ```
                      child: Container(
                        width: squareSize,
                        height: squareSize,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        );
      },
    );
  }
}

