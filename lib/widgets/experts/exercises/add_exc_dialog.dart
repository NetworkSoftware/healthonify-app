import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/counters/hold_counter.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/counters/reps_counter.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/counters/reset_counter.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/counters/set_counter.dart';

class AddExcDialog extends StatelessWidget {
  const AddExcDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: 25.0,
      ),
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
          child: Column(
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
                  SetCounter(getValue: () {}),
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
                   RepCounter(getRepsValue: (){}),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hold(secs)",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const HoldCounter(),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reset(secs)",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const ResetCounter(),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create new HEP",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Name your HEP",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      )),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "-OR-",
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add to existing",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      hintText: "This is a dropdown",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      )),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
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
                    },
                    child: const Text("Add"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
