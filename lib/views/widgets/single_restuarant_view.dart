import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:numenu/state_management/global_state_service.dart';
import 'package:numenu/views/widgets/restaurant_card.dart';
import 'package:provider/provider.dart';

class SingleRestaurantView extends StatefulWidget {
  const SingleRestaurantView({Key? key, required this.resInfo}) : super(key: key);

  final Map<String, dynamic> resInfo;

  @override
  _SingleRestaurantViewState createState() => _SingleRestaurantViewState();
}

class _SingleRestaurantViewState extends State<SingleRestaurantView>
    with TickerProviderStateMixin {
  late List<AnimationController> _fadeControllers;
  late Map<String, dynamic> resInfo;
  @override
  void initState() {
    super.initState();

    resInfo = widget.resInfo;

    _fadeControllers = [];

    /// This needs to be the length of the images list instead of 10
    for (var i = 0; i < 10; i++) {
      var controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
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

    var squareSize = screenWidth * 0.25; // Example: 20% of the screen width

    return Consumer<GlobalStateService>(
      builder: (context, state, child) {
        return Padding(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: squareSize + MediaQuery.of(context).size.height * 0.02,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10, // Use the length of your images list here
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: determineButtonPadding(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height, index),
                      child: FadeTransition(
                        opacity: _fadeControllers[index],
                        child: Container(
                          width: squareSize,
                          height: squareSize,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          // Add your image widget here
                          // Example: RestaurantImage(image: imagesList[index])
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Text(
                  resInfo['Name'],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.05),
              Wrap(
                spacing: 8.0, // Space between the address and phone number if they wrap
                alignment: WrapAlignment.start,
                children: [
                  Text(
                    resInfo['Address'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02), // You can adjust or remove this based on your design needs
                  Text(
                    resInfo['Phone'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.05),
              Wrap(
                spacing: 8.0, // Space between elements if they wrap
                children: [
                  const Text(
                    '⭐',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    resInfo['Rating'].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 251, 181, 29),
                    ),
                  ),
                  Text(
                    '(400) Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[400]!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  determineButtonPadding(screenWidth, screenHeight, index) {
    if (index == 0) {
      return EdgeInsets.fromLTRB(
        screenWidth * 0.00,
        screenHeight * 0.01,
        screenWidth * 0.01,
        screenHeight * 0.01,
      );
    } else {
      return EdgeInsets.fromLTRB(
        screenWidth * 0.02,
        screenHeight * 0.01,
        screenWidth * 0.01,
        screenHeight * 0.01,
      );
    }
  }
}

