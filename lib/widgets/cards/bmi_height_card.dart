import 'dart:developer';
import 'package:flutter/material.dart';

class BmiHeightCard extends StatefulWidget {
  final Function? getHeight;
  final Function? getUnit;

  const BmiHeightCard({Key? key, required this.getHeight, this.getUnit})
      : super(key: key);

  @override
  State<BmiHeightCard> createState() => _BmiHeightCardState();
}

class _BmiHeightCardState extends State<BmiHeightCard> {
  int _height = 0;
  int _inch = 0;
  late TextEditingController heightController;
  late TextEditingController inchController;
  final List<bool> _selections = [
    true,
    false,
  ];
  String _selected = "cm";
  @override
  void initState() {
    super.initState();
    heightController = TextEditingController();
    inchController = TextEditingController();
  }

  @override
  void dispose() {
    heightController.dispose();
    inchController.dispose();
    super.dispose();
  }

  void saveHeight(String selected) {
    double finalHeight = 0.0;
    if (selected == "cm") {
      finalHeight = double.parse(_height.toString());
    } else {
      double h = _height * 30.48;
      double i = _inch * 2.54;
      finalHeight = h + i;
    }
    log("$selected $finalHeight");
    widget.getHeight!(
      finalHeight.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 170,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Height',
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
                        // log(index.toString());
                        heightController.text = '';
                        heightController.selection = TextSelection.collapsed(
                            offset: heightController.text.length);
                        //
                        inchController.text = '';
                        inchController.selection = TextSelection.collapsed(
                            offset: inchController.text.length);

                        widget.getHeight!('0');

                        if (index == 0) {
                          _selected = "cm";
                        } else {
                          _selected = "ft";
                        }

                        // log(_selected);
                        widget.getUnit!("cm");

                        setState(
                          () {
                            for (int buttonIndex = 0;
                                buttonIndex < _selections.length;
                                buttonIndex++) {
                              _selections[buttonIndex] = buttonIndex == index;
                            }
                            //https://stackoverflow.com/questions/57910554/flutter-togglebutton-class-flutter-1-9-1 answer from here
                            // if (buttonIndex == index) {
                            //   _selections[buttonIndex] =
                            //       !_selections[buttonIndex];
                            // } else {
                            //   _selections[buttonIndex] = false;
                            // }
                          },
                        );
                      },
                      children: const [
                        Text(
                          'Cm',
                        ),
                        Text(
                          'Ft',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      if (_selected == "ft") const Text("Ft"),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          controller: heightController,
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
                          //?changed onchanged to onsaved.
                          onChanged: (value) {
                            if (value.isEmpty) {
                              widget.getHeight!(
                                "0",
                              );
                              setState(() {
                                _height = int.parse("0");
                              });
                              return;
                            }
                            setState(() {
                              _height = int.parse(value);
                            });

                            saveHeight(_selected);
                            // widget.getHeight!(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selected == "ft")
                  Flexible(
                    child: Column(
                      children: [
                        const Text("In"),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            controller: inchController,
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
                                widget.getHeight!(
                                  "0.0",
                                );
                                setState(() {
                                  _inch = int.parse("0");
                                });
                                return;
                              }
                              setState(() {
                                _inch = int.parse(value);
                              });
                              saveHeight(_selected);
                              // widget.getHeight!(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            // Text(
            //   '$_height',
            //   style: Theme.of(context).textTheme.labelLarge,
            // ),
            const SizedBox(height: 10),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 10),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(8),
            //     child: Container(
            //       height: 36,
            //       color: grey,
            //       child: Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           const SizedBox(width: 8),
            //           InkWell(
            //             onTap: () {
            //               if (_height <= 0) {
            //                 return;
            //               }
            //               setState(() {
            //                 _height--;
            //               });
            //               widget.getHeight!(_height.toString());
            //               heightController.value =
            //                   TextEditingValue(text: '$_height');
            //             },
            //             child: const Icon(Icons.remove),
            //           ),
            //           const SizedBox(width: 8),
            //           Text(
            //             '$_height',
            //             style: Theme.of(context).textTheme.bodyLarge,
            //           ),
            //           const SizedBox(width: 8),
            //           InkWell(
            //             onTap: () {
            //               setState(() {
            //                 _height++;
            //               });
            //               widget.getHeight!(
            //                 _height.toString(),
            //               );
            //               heightController.value =
            //                   TextEditingValue(text: '$_height');
            //             },
            //             child: const Icon(Icons.add),
            //           ),
            //           const SizedBox(width: 8),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
