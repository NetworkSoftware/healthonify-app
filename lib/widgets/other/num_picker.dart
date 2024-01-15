import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

// ignore: must_be_immutable
class NumPicker extends StatefulWidget {
  final int minimumValue;
  final int maximumValue;
  final Function getNumber;
  int initVal;
  NumPicker({
    required this.minimumValue,
    required this.maximumValue,
    required this.getNumber,
    required this.initVal,
    Key? key,
  }) : super(key: key);

  @override
  State<NumPicker> createState() => _NumPickerState();
}

class _NumPickerState extends State<NumPicker> {
  @override
  Widget build(BuildContext context) {
    return NumberPicker(
      itemWidth: 70,
      minValue: widget.minimumValue,
      maxValue: widget.maximumValue,
      value: widget.initVal,
      onChanged: (i) => setState(
        () {
          widget.initVal = i;
          widget.getNumber(i);
        },
      ),
      selectedTextStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}
