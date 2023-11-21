import 'package:flutter/material.dart';
import 'dart:math' as math;

/// This class is a widget that displays the food types, search results, and
/// restaurant information. It will change height depending on the state of the
/// application (searching, viewing results, viewing restaurant info)

class AnimatedDataView extends StatefulWidget {
  const AnimatedDataView({super.key});

  @override
  State<AnimatedDataView> createState() => _AnimatedDataViewState();
}

class _AnimatedDataViewState extends State<AnimatedDataView> {

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,

        // TODO: This will be watching the state of the application
        height: (MediaQuery.of(context).size.height / 2),

        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20.0,
              spreadRadius: 5.0,
              offset: const Offset(10, -5),
            ),
          ],
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(80), topRight: Radius.circular(80),
            ),
        ),
        child: const Center(
          child: Row(
            // Add two buttons
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(onPressed: null, child: Text('Previous State')),
              ElevatedButton(onPressed: null, child: Text('Next State')),
            ],
          ),
        ),

      ),
    );
  }
}
