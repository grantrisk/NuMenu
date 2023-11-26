import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'close_button.dart';
import 'global_state.dart';

/// Dart doc strings for this class

/// This class is a widget that displays the food types, search results, and
/// restaurant information. It will change height depending on the state of the
/// application (searching, viewing results, viewing restaurant info)

class AnimatedDataView extends StatefulWidget {
  const AnimatedDataView({Key? key}) : super(key: key);

  @override
  State<AnimatedDataView> createState() => _AnimatedDataViewState();
}

class _AnimatedDataViewState extends State<AnimatedDataView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: context.watch<GlobalStateNotifier>().height,
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
          topLeft: Radius.circular(80),
          topRight: Radius.circular(80),
        ),
      ),
      child: Center(
        child: Row(
          // Add two buttons
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MyCloseButton(parentContext: context),
            ElevatedButton(
                onPressed: () => Provider.of<GlobalStateNotifier>(context,
                        listen: false)
                    .changeStateTo(GlobalStateTypes.viewingRestaurantDetails),
                child: const Text('View Restaurant Details')),
          ],
        ),
      ),
    );
  }
}
