import 'package:flutter/material.dart';

enum RecipeSub { cooked, raw }

class RecipieSubTypeRadio extends StatefulWidget {
  const RecipieSubTypeRadio({Key? key}) : super(key: key);

  @override
  State<RecipieSubTypeRadio> createState() => RecipieSubTypeRadioState();
}

class RecipieSubTypeRadioState extends State<RecipieSubTypeRadio> {
  RecipeSub? _character = RecipeSub.cooked;

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
                  'Cooked',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                leading: Radio<RecipeSub>(
                    value: RecipeSub.cooked,
                    groupValue: _character,
                    onChanged: (RecipeSub? value) {
                      setState(() {
                        _character = value;
                      });
                    }),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text(
                  'Raw',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                leading: Radio<RecipeSub>(
                    value: RecipeSub.raw,
                    groupValue: _character,
                    onChanged: (RecipeSub? value) {
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
