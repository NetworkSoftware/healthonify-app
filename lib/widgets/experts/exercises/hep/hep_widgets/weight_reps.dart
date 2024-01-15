import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/workout/set_type_models.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';

class WeightRepsWidget extends StatefulWidget {
  final Function storeData;
  final List<Set>? setsData;
  const WeightRepsWidget(
      {Key? key, required this.storeData, required this.setsData})
      : super(key: key);

  @override
  State<WeightRepsWidget> createState() => _WeightRepsWidgetState();
}

class _WeightRepsWidgetState extends State<WeightRepsWidget> {
  String? dropdownValue;

  List<WeightReps> data = [
    WeightReps(
      reps: "0",
      unit: "kg",
      weight: "0",
    ),
  ];

  void addSet() {
    setState(() {
      data.add(WeightReps(
        reps: "0",
        unit: "kg",
        weight: "0",
      ));
    });
  }

  void deleteSet(int index) {
    // log(index.toString());
    if (data.length > 1) {
      setState(() {
        data.removeAt(index);
      });
    }
  }

  void pushData() {
    widget.storeData(SetTypeData(data: data, from: "weightReps"));
  }

  @override
  void initState() {
    super.initState();
    if (widget.setsData == null || widget.setsData!.isNotEmpty) {
      data = List.generate(
          widget.setsData!.length,
          (index) => WeightReps(
                reps: widget.setsData![index].reps,
                unit: widget.setsData![index].weightUnit,
                weight: widget.setsData![index].weight,
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('Set'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Weight'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Unit'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Reps'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Unit'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('+/-'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) => setWidget(index + 1),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: TextButton(
                onPressed: () {
                  addSet();
                },
                child: const Text('Add set'),
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     for (var ele in data) {
            //       log("weight  ${ele.weight}");
            //       log("reps ${ele.reps}");
            //     }
            //   },
            //   child: const Text("Hey"),
            // ),
          ],
        ),
      ),
    );
  }

  Widget setWidget(int setNumber) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text('$setNumber.'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: data[setNumber - 1].weight,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(left: 10, right: 10),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 60,
                        maxWidth: 52,
                      ),
                      hintText: '0',
                      hintStyle: const TextStyle(
                        color: Color(0xFF959EAD),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    onChanged: (value) {
                      // log("weight $value");
                      data[setNumber - 1].weight = value;
                      pushData();
                    },
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(child: Text("Kg")),
            ),
            Expanded(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: data[setNumber - 1].reps,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(left: 10, right: 10),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 60,
                        maxWidth: 52,
                      ),
                      hintText: '0',
                      hintStyle: const TextStyle(
                        color: Color(0xFF959EAD),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    onChanged: (value) {
                      data[setNumber - 1].reps = value;
                      pushData();
                    },
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(child: Text("Reps")),
            ),
            Expanded(
              child: Column(
                children: [
                  IconButton(
                    onPressed: data.length != setNumber
                        ? () {}
                        : () {
                            // log('tapped');
                            deleteSet(setNumber - 1);
                            pushData();
                          },
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 26,
                      color:
                          data.length != setNumber ? Colors.grey : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Expanded(
//   child: Column(
//     children: [
//       DropdownButtonFormField(
//         isDense: true,
//         items: dropDownOptions
//             .map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(
//               value,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyMedium!
//                   .copyWith(
//                     color: Colors.grey,
//                   ),
//             ),
//           );
//         }).toList(),
//         onChanged: (String? newValue) {
//           setState(() {
//             dropdownValue = newValue!;
//           });
//         },
//         value: dropdownValue,
//         style: Theme.of(context).textTheme.bodyMedium,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(
//               color: Colors.grey,
//               width: 1.25,
//             ),
//           ),
//           constraints: const BoxConstraints(
//             maxHeight: 36,
//           ),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 8),
//         ),
//         icon: const Icon(
//           Icons.keyboard_arrow_down_rounded,
//           color: Colors.grey,
//         ),
//         borderRadius: BorderRadius.circular(8),
//         hint: Text(
//           'kgs',
//           style: Theme.of(context)
//               .textTheme
//               .bodyMedium!
//               .copyWith(color: Colors.grey),
//         ),
//       ),
//     ],
//   ),
// ),
