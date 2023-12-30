import 'package:flutter/material.dart';
import 'package:numenu/views/widgets/back_and_close_buttons.dart';
import 'package:numenu/views/widgets/food_type_view.dart';
import 'package:provider/provider.dart';
import '../../state_management/global_state_service.dart';


/// This will hold all of the restaurant cards. It will display a card for each
/// area in proximity to the user.

class RestaurantCardView extends StatelessWidget {
  const RestaurantCardView({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    // return a listview wrapped in a consumer
    return Consumer<GlobalStateService>(
      builder: (context, state, child) => Container(
        height: MediaQuery.of(context).size.height / 1.9,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container();
          },
        ),
      ),
    );
  }
}