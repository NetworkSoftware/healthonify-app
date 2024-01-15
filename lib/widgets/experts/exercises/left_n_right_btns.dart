import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';

class LeftAndRightBtns extends StatefulWidget {
  const LeftAndRightBtns({Key? key}) : super(key: key);

  @override
  State<LeftAndRightBtns> createState() => _LeftAndRightBtnsState();
}

class _LeftAndRightBtnsState extends State<LeftAndRightBtns> {
  bool _rightSel = false, _leftSel = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: _leftSel ? Theme.of(context).colorScheme.secondary : grey,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 3,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _leftSel = !_leftSel;
              });
              log(_leftSel.toString());
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                "Left",
                style: _leftSel
                    ? Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: whiteColor)
                    : Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          decoration: BoxDecoration(
            color: _rightSel ? Theme.of(context).colorScheme.secondary : grey,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 3,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _rightSel = !_rightSel;
              });
              log(_leftSel.toString());
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                "Right",
                style: _rightSel
                    ? Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: whiteColor)
                    : Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
