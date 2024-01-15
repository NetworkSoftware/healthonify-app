import 'package:flutter/material.dart';

class IndianFoodMark extends StatelessWidget {
  final Color? color;
  const IndianFoodMark({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        border: Border.all(
          color: color!,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: CircleAvatar(
          backgroundColor: color,
        ),
      ),
    );
  }
}
