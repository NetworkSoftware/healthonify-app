import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/exercise/workout_types.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/workout/set_type_models.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
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

class EditAddSetsBottomsheet extends StatefulWidget {
  final ExerciseWorkoutModel exModel;
  final Function saveData;

  const EditAddSetsBottomsheet({
    Key? key,
    required this.exModel,
    required this.saveData,
  }) : super(key: key);

  @override
  State<EditAddSetsBottomsheet> createState() => _EditAddSetsBottomsheetState();
}

class _EditAddSetsBottomsheetState extends State<EditAddSetsBottomsheet> {
  String? selectedGroup;
  String? selectedSetType;
  bool setTypeSelected = false;

  String? sequenceOfEx = "";
  String? setNote = "";

  SetTypeData? setsData;

  List<Set> tempSets = [];

  @override
  void initState() {
    super.initState();

    sequenceOfEx = widget.exModel.round;
    selectedGroup = widget.exModel.group;
    selectedSetType = widget.exModel.setType;
    setNote = widget.exModel.note;
    tempSets = List.from(widget.exModel.sets!);
    // log(widget.exModel.setType!);
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
      // Fluttertoast.showToast(msg: "Please choose a set type");
      Navigator.of(context).pop();
      return;
    }

    if (setNote == null) {
      Fluttertoast.showToast(msg: "Please enter a note");
      return;
    }

    // passing data to previous screen
    widget.saveData({
      "sequence": sequenceOfEx,
      "exGroup": selectedGroup,
      "sets": setsData,
      "setsNote": setNote,
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
                        widget.exModel.exerciseId!["name"] ?? "",
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  initialValue: sequenceOfEx,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: false,
                    hintText: 'Sequence of Exercise',
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
                    sequenceOfEx = value;
                  },
                ),
              ),
              const SizedBox(height: 10),
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
                        tempSets.clear();
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
                WeightRepsWidget(storeData: getData, setsData: tempSets),
              if (selectedSetType == 'Reps only')
                RepsOnlyWidget(storeData: getData, setsData: tempSets),
              if (selectedSetType == 'Time only')
                TimeOnlyWidget(storeData: getData, setsData: tempSets),
              if (selectedSetType == 'Time & Distance')
                TimeDistanceWidget(storeData: getData, setsData: tempSets),
              if (selectedSetType == 'Exercise Name & Reps')
                ExerciseNameRepsWidget(storeData: getData, setsData: tempSets),
              if (selectedSetType == 'Exercise Name & Time')
                ExerciseNameTimeWidget(storeData: getData, setsData: tempSets),
              if (selectedSetType == 'Exercise Name, Reps & Time')
                ExerciseNameRepsTime(storeData: getData, setsData: tempSets),
              if (selectedSetType == 'Distance, Time, Speed & Sets')
                DistanceTimeSpeedSets(storeData: getData, setsData: tempSets),
              if (selectedSetType == 'Distance & Speed')
                DistanceSpeedWidget(storeData: getData, setsData: tempSets),
              if (selectedSetType == 'Distance')
                DistanceWidget(storeData: getData, setsData: tempSets),
              if (selectedSetType == 'Time & Speed')
                TimeSpeedWidget(storeData: getData, setsData: tempSets),
              //! //
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  initialValue: setNote,
                  decoration: InputDecoration(
                    filled: false,
                    hintText: 'Add a note',
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
