import 'package:flutter/material.dart';
enum RecipeType { veg, nonveg }


class RecipeTypeRadioBtn extends StatefulWidget {
  const RecipeTypeRadioBtn({Key? key}) : super(key: key);

  @override
  State<RecipeTypeRadioBtn> createState() => _RecipeTypeRadioState();
}

class _RecipeTypeRadioState extends State<RecipeTypeRadioBtn> {
  RecipeType? _character = RecipeType.veg;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recipe Type",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  'Veg',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                leading: Radio<RecipeType>(
                    value: RecipeType.veg,
                    groupValue: _character,
                    onChanged: (RecipeType? value) {
                      setState(() {
                        _character = value;
                      });
                    }),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text(
                  'Non-Veg',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                leading: Radio<RecipeType>(
                    value: RecipeType.nonveg,
                    groupValue: _character,
                    onChanged: (RecipeType? value) {
                      setState(() {
                        _character = value;
                      });
                    }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}