import 'package:flutter/material.dart';
import 'package:numenu/state_management/global_state_service.dart';
import 'package:provider/provider.dart';


class YellowBg extends StatelessWidget {
  const YellowBg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStateService>(
      builder: (context, state, child) => Positioned(
        child: Align(
          alignment: Alignment.topCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 650),
            curve: state.state == AppState.viewingRestaurantResults || state.state == AppState.minimizedDataView ? Curves.fastEaseInToSlowEaseOut : Curves.easeOut,
            height: state.state == AppState.viewingRestaurantResults || state.state == AppState.minimizedDataView ? 0 : MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(5)
            ),
          ),
        ),
      ),
    );
  }
}