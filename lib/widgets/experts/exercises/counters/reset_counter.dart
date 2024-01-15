import 'package:flutter/material.dart';

class ResetCounter extends StatefulWidget {
  const ResetCounter({Key? key}) : super(key: key);

  @override
  State<ResetCounter> createState() => _ResetCounterState();
}

class _ResetCounterState extends State<ResetCounter> {
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (counter > 0) {
              setState(() {
                counter--;
              });
            }
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
