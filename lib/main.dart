import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'package:numenu/views/widgets/search_result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NuMenu'),
          backgroundColor: Colors.black,
        ),
        body: MyMap(),
      ),
      theme: ThemeData(
          primaryColor: Colors.black, secondaryHeaderColor: Colors.amber),
    );
  }
}

class MyMap extends StatefulWidget {
  MyMap({Key? key}) : super(key: key);

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
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: LatLng(34.2104, -77.8868),
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
        SearchResult(),
      ],
    );
  }
}
