import 'package:flutter/material.dart';

import '../models/restaurant.dart';

class DataView extends StatelessWidget {
  final List<Restaurant> restaurants;

  const DataView({Key? key, required this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return list view
    return ListView(
      children: [
        // for each restaurant, return a card
        for (var restaurant in restaurants)
          Card(
            child: ListTile(
              title: Text(restaurant.name),
              subtitle: Text(restaurant.address),
              trailing: Text(restaurant.rating.toString()),
            ),
          ),
      ],
    );
  }
}
