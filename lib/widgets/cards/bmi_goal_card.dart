import 'package:flutter/material.dart';

class BmiGoalCard extends StatefulWidget {
  const BmiGoalCard({Key? key}) : super(key: key);

  @override
  State<BmiGoalCard> createState() => _BmiGoalCardState();
}

class _BmiGoalCardState extends State<BmiGoalCard> {
  final List<bool> _selections = [
    true,
    false,
  ];
  int _weight = 53;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Target Weight',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '$_weight',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                Text(
                  'kgs',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 36,
                width: 102,
                color: const Color(0xFFDEDBDB),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _weight--;
                        });
                      },
                      child: const Icon(Icons.remove),
                    ),
                    Text(
                      '$_weight',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _weight++;
                        });
                      },
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
            ToggleButtons(
              isSelected: _selections,
              constraints: const BoxConstraints(
                minWidth: 46,
                maxWidth: 56,
                maxHeight: 64,
                minHeight: 28,
              ),
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: const Color(0xFFff7f3f),
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < _selections.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      _selections[buttonIndex] = !_selections[buttonIndex];
                    } else {
                      _selections[buttonIndex] = false;
                    }
                  }
                });
              },
              children: const [
                Text(
                  'Kg',
                ),
                Text(
                  'Lb',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
