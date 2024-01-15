// ignore_for_file: use_key_in_widget_constructors, file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class FiveStars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Icon(
            Icons.star,
            color: Color(0xFFFFB755),
            size: 20,
          ),
          Icon(
            Icons.star,
            color: Color(0xFFFFB755),
            size: 20,
          ),
          Icon(
            Icons.star,
            color: Color(0xFFFFB755),
            size: 20,
          ),
          Icon(
            Icons.star,
            color: Color(0xFFFFB755),
            size: 20,
          ),
          Icon(
            Icons.star,
            color: Color(0xFFFFB755),
            size: 20,
          ),
        ],
      ),
    );
  }
}
