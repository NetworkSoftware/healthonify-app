import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/workout/add_workout_temp_model.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/counters/reps_counter.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/counters/set_counter.dart';

class AddExcToHepDialog extends StatelessWidget {
  final Function(AddSetsModel) onSubmit;
  AddExcToHepDialog({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  AddSetsModel sets = AddSetsModel(reps: 1, sets: 1);

  void getSetsValue(int value) {
    sets.sets = value;
  }

  void getRepsValue(int value) {
    sets.reps = value;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Sets",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            SetCounter(getValue: getSetsValue),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Reps",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            RepCounter(getRepsValue: getRepsValue),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onSubmit(sets);
              },
              child: const Text("Add"),
            )
          ],
        ),
      ],
    );
  }
}
