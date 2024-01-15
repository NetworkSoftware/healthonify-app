import 'package:flutter/material.dart';

class CustomSnackBarChild extends StatelessWidget {
  final String title;
  const CustomSnackBarChild({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Text(title),
    );
  }
}
