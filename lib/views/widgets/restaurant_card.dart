import 'package:flutter/material.dart';
import 'package:numenu/views/widgets/back_and_close_buttons.dart';
import 'package:numenu/views/widgets/food_type_view.dart';
import 'package:provider/provider.dart';
import '../../state_management/global_state_service.dart';
import 'package:latlong2/latlong.dart';

class RestaurantCard extends StatelessWidget {
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
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(resName),
            Text(address),
            Text(rating.toString()),
            Text(latLng.toString()),
          ],
        ),
    );
  }
}
