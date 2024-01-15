import 'dart:developer';

import 'package:flutter/material.dart';

class BmiWeightCard extends StatefulWidget {
  final Function getWeight;
  final Function? getUnit;
  const BmiWeightCard({Key? key, required this.getWeight, this.getUnit})
      : super(key: key);

  @override
  State<BmiWeightCard> createState() => _BmiWeightCardState();
}

class _BmiWeightCardState extends State<BmiWeightCard> {
  TextEditingController weightController = TextEditingController();
  double _weight = 0;
  final List<bool> _selections = [
    true,
    false,
  ];
  String _selected = "kgs";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 184,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Weight',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ToggleButtons(
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
                      color: Colors.teal,
                      onPressed: (int index) {
                        weightController.text = "";
                        weightController.selection = TextSelection.collapsed(
                            offset: weightController.text.length);

                        widget.getWeight('0');
                        if (index == 0) {
                          _selected = "kgs";
                        } else {
                          _selected = "lbs";
                        }

                        log(_selected);
                        widget.getUnit!("kgs");

                        setState(
                          () {
                            for (int buttonIndex = 0;
                                buttonIndex < _selections.length;
                                buttonIndex++) {
                              _selections[buttonIndex] = buttonIndex == index;
                            }
                          },
                        );
                      },
                      children: const [
                        Text(
                          'Kgs',
                        ),
                        Text(
                          'Lbs',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: weightController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Theme.of(context).canvasColor,
                filled: true,
                hintText: '0',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.grey),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              onChanged: (value) {
                if (value.isEmpty) {
                  widget.getWeight("0.0");
                  _weight = double.parse("0");
                  return;
                }
                if (_selected == 'kgs') {
                  widget.getWeight(value);
                  _weight = double.parse(value);
                  log('weight in kgs => $_weight');
                }
                if (_selected == 'lbs') {
                  _weight = double.parse(value) * 0.4536;
                  widget.getWeight(_weight.toString());
                  log('weight in kgs conv from lbs => $_weight');
                }
              },
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       '$_weight',
            //       style: Theme.of(context).textTheme.titleMedium,
            //     ),
            //     const SizedBox(width: 8),
            //     const Text(
            //       'kg',
            //       style: Theme.of(context).textTheme.bodyLarge,
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (_weight <= 0) {
                      return;
                    }
                    setState(() {
                      _weight--;
                    });
                    widget.getWeight(_weight.toString());
                    weightController.value = TextEditingValue(text: '$_weight');
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: const Icon(
                    Icons.remove_circle,
                    size: 42,
                    color: Color(0xFF717579),
                  ),
                ),
                const SizedBox(width: 25),
                InkWell(
                  onTap: () {
                    setState(() {
                      _weight++;
                    });
                    widget.getWeight(_weight.toString());
                    weightController.value = TextEditingValue(text: '$_weight');
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: const Icon(
                    Icons.add_circle,
                    size: 42,
                    color: Color(0xFF717579),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
