import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state_management/global_state_service.dart';

class BackAndCloseButtons extends StatelessWidget {
  const BackAndCloseButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.width * 0.05),
            child: IconButton(
                onPressed: () => {
                  Provider.of<GlobalStateService>(context,
                      listen: false)
                      .changeStateTo(
                      AppState.viewingFoodTypes)
                },
                icon: const Icon(Icons.arrow_back)),
          ),
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.only(right  : MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.width * 0.05),
            child: IconButton(
                onPressed: () => {
                  Provider.of<GlobalStateService>(context,
                      listen: false)
                      .changeStateTo(
                      AppState.minimizedDataView)
                },
                icon: const Icon(Icons.close)),
          ),
        ],
      ),
    );
  }
}
