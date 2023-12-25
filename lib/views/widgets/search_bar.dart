// create a search bar widget
import 'package:flutter/material.dart';
import 'package:numenu/state_management/global_state_service.dart';
import 'package:provider/provider.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStateService>(
      builder: (context, state, child) {
        return Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.width * 0.2,
              left: MediaQuery.of(context).size.width * 0.05,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                curve: state.state == AppState.viewingRestaurantResults || state.state == AppState.minimizedDataView
                    ? Curves.linear
                    : Curves.linear,
                height: 40,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Positioned(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.fastEaseInToSlowEaseOut,
                height: 40,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05,
                  MediaQuery.of(context).size.width * 0.2,
                  MediaQuery.of(context).size.width * 0.05,
                  0,
                ),
                decoration: BoxDecoration(
                  color: state.state == AppState.viewingRestaurantResults || state.state == AppState.minimizedDataView
                      ? const Color.fromARGB(160, 251, 181, 29)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    hintText: 'Search Restaurants',
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    counterText: "",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width * 0.01,
                      horizontal: MediaQuery.of(context).size.width * 0.01,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

