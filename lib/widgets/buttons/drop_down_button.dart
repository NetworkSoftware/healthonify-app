import 'package:flutter/material.dart';

class CustomDropDownButton extends StatefulWidget {
  const CustomDropDownButton({Key? key}) : super(key: key);

  @override
  State<CustomDropDownButton> createState() => CustomDropDownButtonState();
}

class CustomDropDownButtonState extends State<CustomDropDownButton> {
  String dropdownValue = 'Today';
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 18),
        child: DropdownButton<String>(
          value: dropdownValue,
          items: <String>[
            'Today',
            'Yesterday',
            'Earlier',
          ].map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
          style: Theme.of(context).textTheme.bodyLarge,
          onChanged: (String? newValue) {
            setState(
              () {
                dropdownValue = newValue!;
              },
            );
          },
          // ignore: prefer_const_constructors
          icon: Icon(
            Icons.expand_more_rounded,
            color: const Color(0xFFFF6666),
          ),
          iconSize: 30,
          underline: const SizedBox(),
          elevation: 2,
          borderRadius: BorderRadius.circular(6),
          isDense: true,
        ),
      ),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({Key? key}) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String dropdownV = 'Active';
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 8),
        child: DropdownButton<String>(
          value: dropdownV,
          items: <String>[
            'Active',
            'Inactive',
          ].map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
          style: Theme.of(context).textTheme.bodyLarge,
          onChanged: (String? newValue) {
            setState(
              () {
                dropdownV = newValue!;
              },
            );
          },
          // ignore: prefer_const_constructors
          icon: Icon(
            Icons.expand_more_rounded,
            color: const Color(0xFFFF6666),
          ),
          iconSize: 30,
          underline: const SizedBox(),
          elevation: 2,
          borderRadius: BorderRadius.circular(6),
          isDense: true,
        ),
      ),
    );
  }
}
