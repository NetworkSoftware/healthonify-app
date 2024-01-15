import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';

class GoalEndCard extends StatefulWidget {
  const GoalEndCard({Key? key}) : super(key: key);

  @override
  State<GoalEndCard> createState() => _GoalEndCardState();
}

class _GoalEndCardState extends State<GoalEndCard> {
  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Card(
        // color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: InkWell(
          onTap: () {
            showDatePicker(
              context: context,
              builder: (context, child) {
                return Theme(
                  data: datePickerDarkTheme,
                  child: child!,
                );
              },
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            ).then(
              (value) {
                if (value == null) {
                  const Text('Select Time');
                  return;
                }
                setState(() {
                  _selectedDate = value;
                });
              },
            );
          },
          borderRadius: BorderRadius.circular(13),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 8),
                //       child: Text(
                //         'Goal end date',
                //         style: Theme.of(context).textTheme.bodyLarge,
                //       ),
                //     ),
                //   ],
                // ),
                _selectedDate == null
                    ? Text(
                        'Choose ending date',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: const Color(0xFFff7f3f)),
                      )
                    : Text(
                        DateFormat("MM/dd/yyyy").format(_selectedDate!),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: const Color(0xFFff7f3f)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
