import 'package:edupot/core/constants/colors.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final void Function(String)? onChanged;

  const SearchWidget({
    super.key,
    this.onChanged, // Add onChanged as a parameter
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: Icon(
          Icons.search,
          color: blueApp, // Icon color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.grey, // Border color when not focused
            width: 1.0, // Border width when not focused
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.grey, // Border color when focused
            width: 2.0, // Border width when focused
          ),
        ),
        fillColor: Colors.white, // Background color
        filled: true, // Enable the background color
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 12.0),
      ),
      style: TextStyle(
        color: Colors.black, // Input text color
      ),
      cursorColor: Colors.grey, // Cursor color
      onChanged: onChanged, // Use the passed onChanged callback
    );
  }
}
