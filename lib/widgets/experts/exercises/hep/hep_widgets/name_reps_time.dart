import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/workout/set_type_models.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';

class ExerciseNameRepsTime extends StatefulWidget {
  final Function storeData;
  final List<Set>? setsData;

  const ExerciseNameRepsTime(
      {Key? key, required this.storeData, required this.setsData})
      : super(key: key);

  @override
  State<ExerciseNameRepsTime> createState() => _ExerciseNameRepsTimeState();
}

class _ExerciseNameRepsTimeState extends State<ExerciseNameRepsTime> {
  String? dropdownValue;
  List<String> dropDownOptions = [
    'sec',
    'min',
  ];

  List<ExNameRepsTime> data = [
    ExNameRepsTime(
      name: "",
      reps: "0",
      time: "0",
      timeUnit: "sec",
    ),
  ];

  void addSet() {
    setState(() {
      data.add(
        ExNameRepsTime(
          name: "",
          reps: "0",
          time: "0",
          timeUnit: "sec",
        ),
      );
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
    widget.storeData(SetTypeData(data: data, from: "nameRepsTime"));
  }

  @override
  void initState() {
    super.initState();
    if (widget.setsData == null || widget.setsData!.isNotEmpty) {
      data = List.generate(
          widget.setsData!.length,
          (index) => ExNameRepsTime(
                name: widget.setsData![index].name,
                reps: widget.setsData![index].reps,
                time: widget.setsData![index].time,
                timeUnit: widget.setsData![index].timeUnit,
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
                    Text(" "),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Exercise'),
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
                          Text('Time'),
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
              itemBuilder: (context, index) => nameRepsTimeWidget(index + 1),
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
            //       log("name  ${ele.name}");
            //       log("reps ${ele.reps}");
            //       log("time ${ele.time}");
            //       log("unit ${ele.timeUnit}");
            //     }
            //   },
            //   child: const Text("Hey"),
            // ),
          ],
        ),
      ),
    );
  }

  Widget nameRepsTimeWidget(int setNumber) {
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
            Text('$setNumber.'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: data[setNumber - 1].name,
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
                          maxHeight: 60, // maxWidth: 52,
                        ),
                        hintText: 'Name',
                        hintStyle: const TextStyle(
                          color: Color(0xFF959EAD),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      onChanged: (value) {
                        // log("weight $value");
                        data[setNumber - 1].name = value;
                        pushData();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
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
                          maxHeight: 60, // maxWidth: 52,
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
                        data[setNumber - 1].reps = value;
                        pushData();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: data[setNumber - 1].time,
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
                          maxHeight: 60, // maxWidth: 52,
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
                        data[setNumber - 1].time = value;
                        pushData();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  DropdownButtonFormField(
                    isDense: true,
                    items: dropDownOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        data[setNumber - 1].timeUnit = newValue!;
                        pushData();
                      });
                    },
                    value: data[setNumber - 1].timeUnit,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.25,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 60,
                        // maxWidth: 70,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    hint: Text(
                      'secs',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              ),
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
