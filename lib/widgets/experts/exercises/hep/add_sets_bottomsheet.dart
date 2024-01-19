import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/exercise/workout_types.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/physiotherapy/health_model.dart';
import 'package:healthonify_mobile/models/workout/set_type_models.dart';
import 'package:healthonify_mobile/providers/physiotherapy/health_data.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/hep_widgets/dist_speed.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/hep_widgets/dist_time_speed_sets.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/hep_widgets/distance_widget.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/hep_widgets/name_reps.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/hep_widgets/name_reps_time.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/hep_widgets/name_time.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/hep_widgets/reps_only.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/hep_widgets/time_distance.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/hep_widgets/time_only.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/hep_widgets/time_speed.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/hep_widgets/weight_reps.dart';
import 'package:provider/provider.dart';

class AddSetsBottomsheet extends StatefulWidget {
  final String? exerciseName;
  final Function saveData;
  final List<dynamic>? exerciseBodyPartGroupId;
  final List<HealthModel> bodyPartList;

  const AddSetsBottomsheet(
      {Key? key,
      required this.exerciseName,
      required this.saveData,
      required this.exerciseBodyPartGroupId,
      required this.bodyPartList})
      : super(key: key);

  @override
  State<AddSetsBottomsheet> createState() => _AddSetsBottomsheetState();
}

class _AddSetsBottomsheetState extends State<AddSetsBottomsheet> {
  String? selectedGroup;
  String? selectedSetType;
  String? bodyPartGroup;
  Map<String, dynamic>? bodyPartGroupMap;
  bool setTypeSelected = false;
  String? sequenceOfEx;
  String? setNote;
  SetTypeData? setsData;

  List<int> intList = [];

  @override
  void initState() {
    super.initState();

    intList = List.generate(
      10,
      (int index) {
        return index = index + 1;
      },
      growable: false,
    );
  }

  void getData(SetTypeData setTypeData) {
    // log(".......");
    // log("from ... ${setTypeData.from!}");

    setsData = setTypeData;
    // if (setTypeData.data.runtimeType == List<TimeSpeedModel>) {
    //   List<TimeSpeedModel> data = setTypeData.data;
    //   for (var ele in data) {
    //     log(ele.time!);
    //     log(ele.timeUnit!);
    //     log(ele.speed!);
    //   }
    // }
  }

  void onSubmit() {
    if (sequenceOfEx == null || sequenceOfEx!.isEmpty) {
      Fluttertoast.showToast(msg: "Enter the sequence of exercise");
      return;
    }
    if (selectedGroup == null || selectedGroup!.isEmpty) {
      Fluttertoast.showToast(msg: "Select a group");
      return;
    }
    if (setsData == null) {
      Fluttertoast.showToast(msg: "Please choose a set type");
      return;
    }

    Navigator.of(context).pop();

    // passing data to previous screen
    widget.saveData({
      "sequence": sequenceOfEx,
      "exGroup": selectedGroup,
      "sets": setsData,
      "setsNote": setNote,
      "bodyPartGroup": bodyPartGroupMap,
    });

    log("on submit in add sets bottomsheet");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: GestureDetector(
          onTap: () {
            onSubmit();
            // Navigator.pop(context);
          },
          child: Container(
            height: 56,
            color: orange,
            child: Center(
              child: Text(
                'SUBMIT',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 34),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.exerciseName ?? "",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Sequence of Exercise',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButtonFormField(
                  isDense: true,
                  items: intList.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(
                        value.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      sequenceOfEx = newValue!;
                    });
                  },
                  value: sequenceOfEx,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: 56,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  hint: Text(
                    'Sequence of Exercise',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: TextField(
              //     keyboardType: TextInputType.number,
              //     decoration: InputDecoration(
              //       filled: false,
              //       hintText: 'Sequence of Exercise',
              //       hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              //             color: const Color(0xFF717579),
              //           ),
              //       enabledBorder: const UnderlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Color(0xFF717579),
              //         ),
              //       ),
              //       focusedBorder: const UnderlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Color(0xFF717579),
              //         ),
              //       ),
              //       contentPadding: const EdgeInsets.all(0),
              //     ),
              //     style: Theme.of(context).textTheme.bodySmall,
              //     cursorColor: whiteColor,
              //     onChanged: (value) {
              //       sequenceOfEx = value;
              //     },
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButtonFormField(
                  isDense: true,
                  items: groupTypes.map<DropdownMenuItem<String>>((value) {
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
                      selectedGroup = newValue!;
                    });
                  },
                  value: selectedGroup,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: 56,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  hint: Text(
                    'Select a group',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ),
              widget.exerciseBodyPartGroupId == null
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: widget.bodyPartList
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value.id,
                            child: Text(
                              "${value.name}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please choose a value";
                          }
                          return null;
                        },
                        onChanged: (String? newValue) {
                          // log("$newValue");
                          for (var element in widget.bodyPartList) {
                            if (element.id == newValue) {
                              // log("${element.id}");
                              setState(() {
                                bodyPartGroup = newValue;
                              });

                              bodyPartGroupMap = {
                                "name": element.name,
                                "_id": bodyPartGroup,
                              };

                              print("bodyPartGroup : $bodyPartGroupMap");
                            }
                          }
                        },
                        value: bodyPartGroup,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.25,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.25,
                            ),
                          ),
                          constraints: const BoxConstraints(),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        hint: Text(
                          'Primary body part/ Exercise',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.grey),
                        ),
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButtonFormField(
                  isDense: true,
                  items: setTypes.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        selectedSetType = newValue!;
                        setTypeSelected = true;
                      },
                    );
                  },
                  value: selectedSetType,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: 56,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  hint: Text(
                    'Select set type',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ),
              //! widget should come here !//
              if (selectedSetType == 'Weight & Reps')
                WeightRepsWidget(storeData: getData, setsData: const []),
              if (selectedSetType == 'Reps only')
                RepsOnlyWidget(storeData: getData, setsData: const []),
              if (selectedSetType == 'Time only')
                TimeOnlyWidget(storeData: getData, setsData: const []),
              if (selectedSetType == 'Time & Distance')
                TimeDistanceWidget(storeData: getData, setsData: const []),
              if (selectedSetType == 'Exercise Name & Reps')
                ExerciseNameRepsWidget(storeData: getData, setsData: const []),
              if (selectedSetType == 'Exercise Name & Time')
                ExerciseNameTimeWidget(storeData: getData, setsData: const []),
              if (selectedSetType == 'Exercise Name, Reps & Time')
                ExerciseNameRepsTime(storeData: getData, setsData: const []),
              if (selectedSetType == 'Distance, Time, Speed & Sets')
                DistanceTimeSpeedSets(storeData: getData, setsData: const []),
              if (selectedSetType == 'Distance & Speed')
                DistanceSpeedWidget(storeData: getData, setsData: const []),
              if (selectedSetType == 'Distance')
                DistanceWidget(storeData: getData, setsData: const []),
              if (selectedSetType == 'Time & Speed')
                TimeSpeedWidget(storeData: getData, setsData: const []),
              //! //
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: false,
                    hintText: 'Add a note (Optional)',
                    hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: const Color(0xFF717579),
                        ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF717579),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF717579),
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                  cursorColor: whiteColor,
                  onChanged: (value) {
                    setNote = value;
                    // if (setNote != null) {
                    //   widget.saveData({"setsNote": setNote});
                    // }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
