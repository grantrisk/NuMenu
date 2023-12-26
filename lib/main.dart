import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:numenu/api/api.dart';
import 'package:numenu/services/location_service.dart';
import 'package:numenu/state_management/global_state_service.dart';
import 'package:numenu/views/widgets/animated_data_view.dart';
import 'package:numenu/views/widgets/search_bar.dart';
import 'package:numenu/views/widgets/yellow_bg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  await dotenv.load(fileName: "DEV.env");
  Position position;

  try {
    position = await LocationService.getCurrentLocation();
    print('Current location: ${position.latitude}, ${position.longitude}');
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

  // Temp...
  // TODO: Make this callable by the state controller
  // TODO revert back after cullin fixes his location problem so the lat and long arent hard coded
  final service = RestaurantService();
  final restaurants = await service.getRestaurants(
    latitude: 34.2104,
    longitude: -77.8868,
    type: RestaurantType.hamburgerRestaurant,
    maxResultCount: 20,
    radiusInMiles: 3,
  );

  // TODO get the lat and long of the businesses
  if (restaurants.isNotEmpty) {
    print('Fetched ${restaurants.length} restaurants:');
    /*for (final restaurant in restaurants) {
      print('Name: ${restaurant.name}, Address: ${restaurant.address}, '
          'Rating: ${restaurant.rating}, Location: ${restaurant.location}');
    }*/
  } else {
    print('No restaurants found.');
  }

  runApp(
    MultiProvider(providers: [
      // TODO: Create a param for state service called restaurants
      ChangeNotifierProvider(
          create: (_) => GlobalStateService(restaurants: restaurants)),
    ], child: MyApp(position: position, restaurants: restaurants)),
  );
}

class MyApp extends StatelessWidget {
  final Position position;
  final List<Restaurant> restaurants;

  MyApp({Key? key, required this.position, required this.restaurants})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Prevents the bottom overflow error when the keyboard is open
      home: Scaffold(
        // appBar: AppBar(
        //   toolbarHeight: MediaQuery.of(context).size.height * 0.01,
        //   backgroundColor: const Color.fromARGB(255, 251, 181, 29),
        // ),
        resizeToAvoidBottomInset: false,
        body: MyMap(position: position, restaurants: restaurants),
      ),
      theme: ThemeData(
          fontFamily: 'Montserrat',
          primaryColor: Colors.black,
          secondaryHeaderColor: Colors.amber),
    );
  }
}

class MyMap extends StatefulWidget {
  final Position position;
  final List<Restaurant> restaurants;

  MyMap({Key? key, required this.position, required this.restaurants})
      : super(key: key);

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final MapController mapController = MapController();
  Timer? _debounce;
  double markerSize = 16;
  List<Restaurant> restaurants = [];

  @override
  void initState() {
    super.initState();
    restaurants = widget.restaurants; // Initialize with initial restaurants
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onMapPositionChange(MapPosition position, bool hasGesture) {
    if (hasGesture) {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(seconds: 2), () {
        // Ensure the position center is not null
        if (position.center != null) {
          _loadRestaurants(position
              .center!); // Use the '!' operator to cast LatLng? to LatLng
        }
      });
    }
  }

  Future<void> _loadRestaurants(LatLng center) async {
    final service = RestaurantService();
    final newRestaurants = await service.getRestaurants(
      latitude: center.latitude,
      longitude: center.longitude,
      type: RestaurantType.hamburgerRestaurant,
      maxResultCount: 20,
      radiusInMiles: 3,
    );

    // Update state with the new restaurants
    setState(() {
      restaurants = newRestaurants;
    });

    // Logging for debugging
    if (restaurants.isNotEmpty) {
      print('Fetched ${restaurants.length} restaurants after moving.');
    } else {
      print('No restaurants found after moving.');
    }
  }

  List<Marker> _createRestaurantMarkers() {
    return restaurants.map((restaurant) {
      return Marker(
        point:
            LatLng(restaurant.location.latitude, restaurant.location.longitude),
        width: markerSize,
        height: markerSize,
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () => _showRestaurantInfo(restaurant),
          child: Container(
            width: markerSize,
            height: markerSize,
            child: Image.asset('assets/images/restaurant_marker.png'),
          ),
        ),
      );
    }).toList();
  }

  void updateMarkerSize(double zoom) {
    setState(() {
      // Exponential growth formula for the marker size
      markerSize = math.max(
          16, math.pow(zoom / 9.2, 2) * 10); // Adjust constants as needed
    });
  }

  void _showRestaurantInfo(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(height: 16.0),
                ListTile(
                  leading: Icon(Icons.location_on,
                      color: Theme.of(context).primaryColor),
                  title: Text('Address'),
                  subtitle: Text(restaurant.address),
                  onTap: () async {
                    var query = Uri.encodeComponent(restaurant.address);
                    var googleUrl =
                        "https://www.google.com/maps/search/?api=1&query=$query";
                    if (await canLaunch(googleUrl)) {
                      await launch(googleUrl);
                    } else {
                      print(
                          'Could not open the map.'); // Using print to handle the error for now
                    }
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.star, color: Theme.of(context).primaryColor),
                  title: Text('Rating'),
                  subtitle: Text(restaurant.rating.toString()),
                ),
                // ... additional details ...
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                  // ... button styling ...
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
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
              _onMapPositionChange(position, hasGesture);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(markers: _createRestaurantMarkers()),
          ],
        ),
        const YellowBg(),
        const MySearchBar(),

        /** Child 4: Jumpy White Box (AnimatedDataView)
         *        The fourth widget is the white box that appears when the user is
         *    searching for restaurants. It will be animated to move up and down
         *    depending on the state of the application.
         */
        Consumer<GlobalStateService>(
          builder: (context, state, child) {
            return const AnimatedDataView();
          },
        ),
      ],
    );
  }
}
