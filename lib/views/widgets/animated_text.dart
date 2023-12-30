import 'package:flutter/material.dart';


/// The text that indicates what kind of restaurants the user is viewing

class AnimatedTextWidget extends StatefulWidget {
  final String text;
  const AnimatedTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  _AnimatedTextWidgetState createState() => _AnimatedTextWidgetState();
}

class _AnimatedTextWidgetState extends State<AnimatedTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Adjust the duration as needed
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Text(
        widget.text,
        style: const TextStyle(
          color: Color.fromARGB(255, 251, 181, 29),
          fontSize: 18.0,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
