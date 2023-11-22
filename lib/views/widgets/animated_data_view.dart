import 'package:binder/binder.dart';
import 'package:flutter/material.dart';
import 'package:numenu/state_management/global_state.dart';

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
    final state = context.watch(globalStateRef);
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,

        // TODO: This will be watching the state of the application
        height: state.state == States.splashScreen
            ? MediaQuery.of(context).size.height / 5
            : MediaQuery.of(context).size.height / 1.5,

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
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      context
                          .use(globalStateLogicRef)
                          .changeStateTo(States.splashScreen);
                    });
                  },
                  child: const Text('Button 1')),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      context
                          .use(globalStateLogicRef)
                          .changeStateTo(States.foodTypeSelection);
                    });
                  },
                  child: const Text('Button 2')),
              Text('State: ${context.watch(globalStateRef).state}'),
            ],
          ),
        ),
      ),
    );
  }
}
