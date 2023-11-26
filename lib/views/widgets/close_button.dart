import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'global_state.dart';

class MyCloseButton extends StatelessWidget {
  BuildContext parentContext;
  MyCloseButton({Key? key, required this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => Provider.of<GlobalStateNotifier>(context,
            listen: false)
            .changeStateTo(GlobalStateTypes.viewingFoodTypeSelection),
        child: const Text('View Restaurant Details'))
    ;
  }
}
