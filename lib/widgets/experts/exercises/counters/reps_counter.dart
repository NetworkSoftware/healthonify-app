import 'package:flutter/material.dart';

class RepCounter extends StatefulWidget {
  final String repsCount;
  final Function getRepsValue;
  const RepCounter({Key? key, this.repsCount = "1", required this.getRepsValue})
      : super(key: key);

  @override
  State<RepCounter> createState() => _RepCounterState();
}

class _RepCounterState extends State<RepCounter> {
  int counter = 1;

  @override
  void initState() {
    super.initState();
    counter = int.parse(widget.repsCount);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (counter > 1) {
              setState(() {
                counter--;
              });
            }

            widget.getRepsValue(counter);
            // wieghtController.value = TextEditingValue(text: '$_weight');
          },
          borderRadius: BorderRadius.circular(20),
          child: const Icon(
            Icons.remove_circle,
            size: 35,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(counter.toString()),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {
            setState(() {
              counter++;
            });
            widget.getRepsValue(counter);
            // wieghtController.value = TextEditingValue(text: '$_weight');
          },
          borderRadius: BorderRadius.circular(20),
          child: const Icon(
            Icons.add_circle,
            size: 35,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
