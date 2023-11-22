import 'package:binder/binder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;
import 'package:numenu/views/widgets/animated_data_view.dart';
import 'package:numenu/views/widgets/yellow_bg.dart';
import 'package:numenu/views/widgets/search_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BinderScope(
      child: MaterialApp(
        home: Scaffold(
          // TODO: Figure out which options work best for the app
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.amber,
          ),
          body: const MyMap(),
        ),
        theme: ThemeData(
            primaryColor: Colors.black, secondaryHeaderColor: Colors.amber),
      ),
    );
  }
}

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
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
            initialCenter: const LatLng(34.2104, -77.8868),
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
                  point: const LatLng(34.2359, -77.9409),
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
        const YellowBackground(),

        /** Child 3: The search results
         *       The third widget is the search bar that is only displayed when the user
         *       is searching for restaurants.
         */
        const Search(),

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

