import 'package:flutter/material.dart';

class SetCounter extends StatefulWidget {
  final String setCount;
  final Function getValue;
  const SetCounter({Key? key, this.setCount = "1", required this.getValue})
      : super(key: key);

  @override
  State<SetCounter> createState() => _SetCounterState();
}

class _SetCounterState extends State<SetCounter> {
  int counter = 1;
  @override
  void initState() {
    super.initState();
    counter = int.parse(widget.setCount);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            if (counter > 1) {
              setState(() {
                counter--;
              });
            }
            widget.getValue(counter);
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
            widget.getValue(counter);
            // wieghtController.value = TextEditingValue(text: '$_weight');
          },
          borderRadius: BorderRadius.circular(20),
          child: const Icon(
            Icons.add_circle,
            color: Colors.grey,
            size: 35,
          ),
        ),
      ],
    );
  }
}
