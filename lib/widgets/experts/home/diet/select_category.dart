import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SelectCategory extends StatefulWidget {
  final List<String> data;
  String dropdownValue;
  final String title;
  final bool isUnderline, isExpanded;

  SelectCategory(
      {Key? key,
      required this.data,
      required this.dropdownValue,
      this.isUnderline = true,
      this.isExpanded = false,
      required this.title})
      : super(key: key);

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        DropdownButton<String>(
          isExpanded: widget.isExpanded,
          value: widget.dropdownValue,
          icon: const Icon(Icons.arrow_drop_down_rounded),
          elevation: 16,
          style: Theme.of(context).textTheme.bodyLarge,
          underline: Container(
            height: widget.isUnderline ? 2 : 0,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onChanged: (String? newValue) {
            setState(() {
              widget.dropdownValue = newValue!;
            });
          },
          items: widget.data.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
