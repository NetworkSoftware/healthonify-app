import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';

String? filterValue = filterOptions[0];
List filterOptions = [
  'This Week',
  'This Month',
  'Last 2 months',
  'Last 3 months',
];

Map<String, dynamic> filterMap = {
  filterOptions[0]: 7,
  filterOptions[1]: 30,
  filterOptions[2]: 60,
  filterOptions[3]: 90,
};

class FilterDropDown extends StatefulWidget {
  final Function onSelected;
  const FilterDropDown({required this.onSelected, Key? key}) : super(key: key);

  @override
  State<FilterDropDown> createState() => _FilterDropDownState();
}

class _FilterDropDownState extends State<FilterDropDown> {
  @override
  void initState() {
    super.initState();
    setState(() {
      filterValue = filterOptions[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Container(
        decoration: const BoxDecoration(
          color: orange,
          borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Filter by',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            Expanded(
              child: DropdownButtonFormField(
                isDense: true,
                items: filterOptions.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    filterValue = newValue!;
                  });
                  widget.onSelected();
                },
                value: filterValue,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.25,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
                hint: Text(
                  'filter',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
