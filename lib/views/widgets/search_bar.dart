import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: MediaQuery.of(context).size.width / 1.2,
          height: 45,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            )
            ),
          child: const Center(
            child: TextField(
              // vertically align text in text field
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Restaurants',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
