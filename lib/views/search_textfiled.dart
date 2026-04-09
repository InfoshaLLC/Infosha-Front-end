import 'package:flutter/material.dart';
import 'package:infosha/views/colors.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      child: TextField(
        decoration: InputDecoration(
            hintText: "Search",
            contentPadding: EdgeInsets.only(top: 5),
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(25)),
            filled: true,
            fillColor: lightGrey),
      ),
    );
  }
}
