import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:numenu/views/widgets/animated_data_view.dart';
import 'package:numenu/services/location_service.dart';
import 'package:numenu/api/api.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  Position position;

  try {
    position = await LocationService.getCurrentLocation();
    final service = RestaurantService();
    final restaurants = await service.getRestaurants(
      latitude: position.latitude,
      longitude: position.longitude,
      type: RestaurantType.pizzaRestaurant,
    );

    if (restaurants.isNotEmpty) {
      print('Fetched ${restaurants.length} restaurants:');
      for (final restaurant in restaurants) {
        print('Name: ${restaurant.name}, Address: ${restaurant.address}');
      }
    } else {
      print('No restaurants found.');
    }
  } catch (e) {
    print('An error occurred: $e');
    // Create a Position object with default values
    position = Position(
      latitude: 0.0,
      longitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
  }

  runApp(MyApp(position: position));
}

class MyApp extends StatelessWidget {
  final Position position;

  MyApp({Key? key, required this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NuMenu'),
          backgroundColor: Colors.black,
        ),
        body: MyMap(position: position),
      ),
      theme: ThemeData(
          primaryColor: Colors.black, secondaryHeaderColor: Colors.amber),
    );
  }
}

class MyMap extends StatefulWidget {
  final Position position;

  MyMap({Key? key, required this.position}) : super(key: key);

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final MapController mapController = MapController();
  double markerSize = 80;

  void updateMarkerSize(double zoom) {
    setState(() {
      markerSize = math.min(32, 200 / zoom); // Adjust this formula as needed
    });
    print(markerSize);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        /** Child 1: The map itself
         *      The first is the deepest in the stack, so it will be the bottom-most
         *    widget. It is only revealed when the user is not searching for
         *    restaurants.
         */
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter:
                LatLng(widget.position.latitude, widget.position.longitude),
            initialZoom: 9.2,
            onPositionChanged: (position, hasGesture) {
              final zoom = position.zoom;
              if (zoom != null) {
                updateMarkerSize(zoom);
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(34.2359, -77.9409),
                  width: markerSize,
                  height: markerSize,
                  child: Icon(Icons.location_on,
                      color: Colors.red, size: markerSize),
                ),
              ],
            ),
          ],
        ),
        /** Child 2: YellowBackground
         *       The second widget is the yellow background that appears when the splash
         *     screen is displayed, when the user is selecting a food type, and when
         *     the user is viewing the restaurant info.
         */

        /** Child 3: The search results
         *       The third widget is the search bar that is only displayed when the user
         *       is searching for restaurants.
         */

        /** Child 4: Jumpy White Box (AnimatedDataView)
         *        The fourth widget is the white box that appears when the user is
         *    searching for restaurants. It will be animated to move up and down
         *    depending on the state of the application.
         */
        const AnimatedDataView(),
      ],
    );
  }
}
