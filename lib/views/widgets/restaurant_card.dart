import 'package:flutter/material.dart';
import 'package:numenu/views/widgets/back_and_close_buttons.dart';
import 'package:numenu/views/widgets/food_type_view.dart';
import 'package:provider/provider.dart';
import '../../state_management/global_state_service.dart';
import 'package:latlong2/latlong.dart';

class RestaurantCard extends StatelessWidget {
  // TODO
  /// Convert these params into a map for ease of passage to state service
  const RestaurantCard({
    Key? key,
    required this.resName,
    required this.address,
    required this.rating,
    required this.latLng,
  }) : super(key: key);

  final String resName;
  final String address;
  final double rating;
  final LatLng latLng;

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStateService>(
      builder: (context, state, child) {
        return GestureDetector(
          onTap: () {
            final selectedResInfo = {
              'Name' : resName,
              'Address' : address,
              'Rating' : rating,
              'Phone' : '(123) 456-7890'
            };
            Provider.of<GlobalStateService>(context, listen: false)
                .changeSelectedRestaurantTo(selectedResInfo);

            Provider.of<GlobalStateService>(context, listen: false)
                .changeStateTo(AppState.viewingRestaurantInfo);
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey[500]!,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.025,
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.03,
                    bottom: MediaQuery.of(context).size.width * 0.025,
                  ),
                  child: Row(
                    children: [
                      Text(
                        resName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        '⭐',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 251, 181, 29),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
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
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        bottom: MediaQuery.of(context).size.width * 0.025,
                      ),
                      /// Restaurant type here
                      child: Text(
                        'Food | Restaurant Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        bottom: MediaQuery.of(context).size.width * 0.025,
                      ),
                      child: Text(
                        address,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    const Spacer(flex: 3),
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        bottom: MediaQuery.of(context).size.width * 0.025,
                        right: MediaQuery.of(context).size.width * 0.025,
                      ),
                      child: Text(
                        '0.5 miles',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
