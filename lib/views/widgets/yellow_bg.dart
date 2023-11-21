import 'package:flutter/material.dart';

class YellowBackground extends StatefulWidget {
  const YellowBackground({super.key});

  @override
  State<YellowBackground> createState() => _YellowBackgroundState();
}

class _YellowBackgroundState extends State<YellowBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.amber,
      ),
    );
  }
}
