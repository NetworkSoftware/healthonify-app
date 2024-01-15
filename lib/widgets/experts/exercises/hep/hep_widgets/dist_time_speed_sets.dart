import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/workout/set_type_models.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';

class DistanceTimeSpeedSets extends StatefulWidget {
  final Function storeData;
  final List<Set>? setsData;
  const DistanceTimeSpeedSets(
      {Key? key, required this.storeData, required this.setsData})
      : super(key: key);

  @override
  State<DistanceTimeSpeedSets> createState() => _DistanceTimeSpeedSetsState();
}

class _DistanceTimeSpeedSetsState extends State<DistanceTimeSpeedSets> {
  String? dropdownValue;
  List<String> dropDownOptions = [
    'Fast',
    'Slow',
    'Walk',
    'Rest',
    'Easy',
  ];

  List<DistanceTimeSets> data = [
    DistanceTimeSets(
      distance: "0",
      time: "0",
      sets: "0",
      distanceUnit: "km",
      timeUnit: "mins",
      speed: "",
    ),
  ];

  void addSet() {
    setState(() {
      data.add(
        DistanceTimeSets(
          distance: "0",
          time: "0",
          sets: "0",
          distanceUnit: "km",
          timeUnit: "mins",
          speed: "",
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
    if (dropdownValue != null) {
      for (var ele in data) {
        ele.speed = dropdownValue;
      }
    }
    widget.storeData(SetTypeData(data: data, from: "distTimeSpeedSets"));
  }

  @override
  void initState() {
    super.initState();
    if (widget.setsData == null || widget.setsData!.isNotEmpty) {
      if (widget.setsData![0].speed != null &&
          widget.setsData![0].speed!.isNotEmpty) {
        dropdownValue = widget.setsData![0].speed;
      }
      // log("speed ${widget.setsData![0].speed}");
      data = List.generate(
          widget.setsData!.length,
          (index) => DistanceTimeSets(
                distance: widget.setsData![index].distance,
                distanceUnit: widget.setsData![index].distanceUnit,
                time: widget.setsData![index].time,
                timeUnit: widget.setsData![index].timeUnit,
                sets: widget.setsData![index].set,
                speed: widget.setsData![index].speed,
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
            child: DropdownButtonFormField(
              isDense: true,
              items:
                  dropDownOptions.map<DropdownMenuItem<String>>((String value) {
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
                  dropdownValue = newValue!;
                  log(newValue);
                });
                pushData();
              },
              value: dropdownValue,
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
                  maxHeight: 40,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(8),
              hint: Text(
                'Speed',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.grey),
              ),
            ),
          ),
          Card(
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
                              Text(
                                'Distance (km)',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('Time (mins)'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('Sets'),
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
                  itemBuilder: (context, index) =>
                      disTimeSpeedSetsWidget(index + 1),
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
                //       log("dist  ${ele.distance}");
                //       log("time ${ele.time}");
                //       log("set ${ele.sets}");
                //     }
                //   },
                //   child: const Text("Hey"),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget disTimeSpeedSetsWidget(int setNumber) {
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
                      initialValue: data[setNumber - 1].distance,
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
                        hintText: '0.0',
                        hintStyle: const TextStyle(
                          color: Color(0xFF959EAD),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      onChanged: (value) {
                        // log("weight $value");
                        data[setNumber - 1].distance = value;
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
                        hintText: '0.0',
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: data[setNumber - 1].sets,
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
                          // maxWidth: 52,
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
                        data[setNumber - 1].sets = value;
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
