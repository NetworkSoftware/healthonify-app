// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class AddAppointmentDropDown extends StatefulWidget {
  String dropDownHint;
  List<String> dropDownList;

  AddAppointmentDropDown({
    required this.dropDownHint,
    required this.dropDownList,
  });
  @override
  State<AddAppointmentDropDown> createState() => _AddAppointmentDropDownState();
}

class _AddAppointmentDropDownState extends State<AddAppointmentDropDown> {
  late String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.92,
          child: DropdownButtonFormField<dynamic>(
            hint: Text(
              widget.dropDownHint,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.grey),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF717579),
              size: 30,
            ),
            items: widget.dropDownList.map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodySmall!,
                  ),
                );
              },
            ).toList(),
            onChanged: (newValue) {
              setState(
                () {
                  dropdownValue = newValue;
                },
              );
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
