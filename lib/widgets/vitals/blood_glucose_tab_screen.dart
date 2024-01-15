import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/vitals/all_vitals.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/vitals/blood_glucose_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BloodGlucoseTabScreen extends StatefulWidget {
  final String tabName, dateType;

  const BloodGlucoseTabScreen(
      {Key? key, required this.tabName, required this.dateType})
      : super(key: key);

  @override
  State<BloodGlucoseTabScreen> createState() => _BloodGlucoseTabScreenState();
}

class _BloodGlucoseTabScreenState extends State<BloodGlucoseTabScreen>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  BloodGlucose _bloodGlucose = BloodGlucose();
  String type = "fasting";
  List<BloodGlucoseRecentLogs> recentLogs = [];

  final List<bool> _selections = [
    true,
    false,
  ];

  Future<void> getBloodGlucose() async {
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      _bloodGlucose =
          await Provider.of<BloodGlucoseData>(context, listen: false)
              .getBloodGlucose(userId, widget.dateType);
      log(_bloodGlucose.averageData!['fastingTypeAverage'].toString());
      recentLogs = [];
      if (_bloodGlucose.recentLogs != null &&
          _bloodGlucose.recentLogs!.isNotEmpty) {
        if (type == "fasting") {
          for (int i = 0; i < _bloodGlucose.recentLogs!.length; i++) {
            if (_bloodGlucose.recentLogs![i].testType == "fasting") {
              recentLogs.add(_bloodGlucose.recentLogs![i]);
            }
          }
        } else {
          for (int i = 0; i < _bloodGlucose.recentLogs!.length; i++) {
            if (_bloodGlucose.recentLogs![i].testType == "random") {
              recentLogs.add(_bloodGlucose.recentLogs![i]);
            }
          }
        }
      }
      averageBloodGlucose = _bloodGlucose.averageData != null
          ? _bloodGlucose.averageData!['fastingTypeAverage'] ?? "0.00"
          : "0.0";
      averagePPRandomBloodGlucose = _bloodGlucose.averageData != null
          ? _bloodGlucose.averageData!['randomTypeAverage'] ?? "0.00"
          : "0.0";
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error blood glucose $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  Future<void> editBloodGlucose(String bpId) async {
    try {
      await Provider.of<BloodGlucoseData>(context, listen: false)
          .editBloodGlucose(editBloodGlucoseMap, bpId);

      popFunction();
      Fluttertoast.showToast(msg: 'Successfully edited blood glucose log');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to edit logs");
    } catch (e) {
      log("Error bp widget $e");
      Fluttertoast.showToast(msg: "Unable to edit logs");
    } finally {
      setState(() {});
    }
  }

  void popFunction() {
    Navigator.pop(context);
  }

  late String averageBloodGlucose;
  late String averagePPRandomBloodGlucose;
  late String userId;

  @override
  void initState() {
    super.initState();
    print("TAb1 : ${widget.tabName}");
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: getBloodGlucose(),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       vertical: 10, horizontal: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         widget.tabName,
                  //         style: Theme.of(context).textTheme.labelLarge,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                widget.tabName == "Today"
                                    ? Text(
                                        "Today's Average Blood Glucose",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      )
                                    : widget.tabName == "This Week"
                                        ? Text(
                                            "Weekly Average Blood Glucose",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          )
                                        : widget.tabName == "This Month"
                                            ? Text(
                                                "Monthly Average Blood Glucose",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              )
                                            : Text(
                                                "Yearly Average Blood Glucose",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            type == "fasting"
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  averageBloodGlucose,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium,
                                                ),
                                                Text(
                                                  ' mg/dl',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        averageBloodGlucose == '0'
                                            ? 'No data available'
                                            : double.parse(averageBloodGlucose) >
                                                        70 &&
                                                    double.parse(
                                                            averageBloodGlucose) <
                                                        100
                                                ? 'Normal'
                                                : double.parse(averageBloodGlucose) >
                                                            100 &&
                                                        double.parse(
                                                                averageBloodGlucose) <
                                                            126
                                                    ? 'Early Diabetes'
                                                    : 'Established Diabetes',
                                        style: double.parse(averageBloodGlucose) >
                                                    70 &&
                                                double.parse(averageBloodGlucose) <
                                                    100
                                            ? Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color:
                                                        const Color(0xFF4599d9))
                                            : double.parse(averageBloodGlucose) >
                                                        100 &&
                                                    double.parse(
                                                            averageBloodGlucose) <
                                                        126
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(color: orange)
                                                : averageBloodGlucose == '0'
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Colors.red),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  averagePPRandomBloodGlucose,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium,
                                                ),
                                                Text(
                                                  ' mg/dl',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        averagePPRandomBloodGlucose == '0'
                                            ? 'No data available'
                                            : double.parse(averagePPRandomBloodGlucose) >
                                                        70 &&
                                                    double.parse(
                                                            averagePPRandomBloodGlucose) <
                                                        100
                                                ? 'Normal'
                                                : double.parse(averagePPRandomBloodGlucose) >
                                                            100 &&
                                                        double.parse(
                                                                averagePPRandomBloodGlucose) <
                                                            126
                                                    ? 'Early Diabetes'
                                                    : 'Established Diabetes',
                                        style: double.parse(
                                                        averagePPRandomBloodGlucose) >
                                                    70 &&
                                                double.parse(averagePPRandomBloodGlucose) <
                                                    100
                                            ? Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color:
                                                        const Color(0xFF4599d9))
                                            : double.parse(averagePPRandomBloodGlucose) >
                                                        100 &&
                                                    double.parse(averagePPRandomBloodGlucose) <
                                                        126
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(color: orange)
                                                : averagePPRandomBloodGlucose ==
                                                        '0'
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Center(
                      child: Text(
                        'Previous Logs',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: orange),
                      ),
                    ),
                  ),
                  Align(alignment: Alignment.center, child: toggleButton()),
                  if (recentLogs.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentLogs.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              recentLogs[index]
                                                  .bloodGlucoseLevel!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ),
                                            Text(
                                              ' mg/dl',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(color: orange),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${StringDateTimeFormat().stringtDateFormatLogWeight(recentLogs[index].date!)} at ${recentLogs[index].time!}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 2),
                                        type != "fasting"
                                            ? Row(
                                                children: [
                                                  Text(
                                                    "Meal Type : ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge!
                                                        .copyWith(fontSize: 14),
                                                  ),
                                                  Text(
                                                    recentLogs[index].mealType!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: orange),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      print("stringDateBloodGlucoseFormat");
                                      dateController.text =
                                          StringDateTimeFormat()
                                              .stringDateBloodGlucoseFormat(
                                                  recentLogs[index].date!);
                                      timeController.text =
                                          recentLogs[index].time!;
                                      dropDownValue = type != "fasting"
                                          ? recentLogs[index].mealType!
                                          : "beforebreakfast";
                                      levelController.text =
                                          recentLogs[index].bloodGlucoseLevel!;

                                      editBloodGlucoseRecord(
                                          recentLogs[index].id!);
                                    },
                                    icon: const Icon(
                                      Icons.edit_note_rounded,
                                      color: orange,
                                      size: 34,
                                    ),
                                    splashRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }

  bool isPostPrandial = false;
  String? dropDownValue;
  List dropDownOptions = [
    {
      "title": "Before Breakfast",
      "key": "beforebreakfast",
    },
    {
      "title": "After Breakfast",
      "key": "afterbreakfast",
    },
    {
      "title": "Before Lunch",
      "key": "beforelunch",
    },
    {
      "title": "After Lunch",
      "key": "afterlunch",
    },
    {
      "title": "Before Snacks",
      "key": "beforesnack",
    },
    {
      "title": "After Snacks",
      "key": "aftersnack",
    },
    {
      "title": "Before Dinner",
      "key": "beforedinner",
    },
    {
      "title": "After Dinner",
      "key": "afterdinner",
    },
  ];

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController levelController = TextEditingController();

  Map<String, dynamic> editBloodGlucoseMap = {"set": {}};

  final formKey = GlobalKey<FormState>();

  void onEditSubmit(String bgId) {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    editBloodGlucoseMap["set"]["userId"] = userId;
    editBloodGlucoseMap["set"]["date"] =
        DateFormat("MM/dd/yyyy").format(selectedDate!);
    editBloodGlucoseMap["set"]["time"] = selectedTime!;
    editBloodGlucoseMap["set"]["bloodGlucoseLevel"] = bloodGlucose!;
    editBloodGlucoseMap["set"]["testType"] =
        type == "random" ? 'random' : 'fasting';
    if (type == "random") {
      if (dropDownValue == null) {
        Fluttertoast.showToast(msg: 'Please select a meal type');
        return;
      }
      editBloodGlucoseMap["set"]["mealType"] = dropDownValue!;
    }
    log(editBloodGlucoseMap.toString());

    editBloodGlucose(bgId);
  }

  // String date,String time,String level,String meal
  void editBloodGlucoseRecord(String bloodGlucoseId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      //backgroundColor: Colors.black,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, sheetState) {
            return Form(
              key: formKey,
              child: Column(
                //mainAxisSize : MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: Theme.of(context).colorScheme.onBackground,
                            size: 32,
                          ),
                          splashRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => datePicker(),
                      child: IgnorePointer(
                        child: TextFormField(
                          controller: dateController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).canvasColor,
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: grey,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: orange,
                              ),
                            ),
                            suffixIcon: TextButton(
                              onPressed: () {
                                datePicker();
                              },
                              child: const Icon(
                                Icons.calendar_month_rounded,
                                color: orange,
                                size: 28,
                              ),
                            ),
                            hintText: "Choose log date",
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          onSaved: (value) {
                            log(selectedDate.toString());
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your logging date';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => timePicker(),
                      child: IgnorePointer(
                        child: TextFormField(
                          controller: timeController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).canvasColor,
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: grey,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: orange,
                              ),
                            ),
                            suffixIcon: TextButton(
                              onPressed: () {
                                timePicker();
                              },
                              child: const Icon(
                                Icons.schedule_rounded,
                                color: orange,
                                size: 28,
                              ),
                            ),
                            hintText: "Choose log time",
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          onSaved: (value) {
                            log(selectedTime.toString());
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your logging time';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        inputFields('Blood Glucose Level'),
                        const SizedBox(width: 16),
                        Text(
                          'mg/dl',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  ToggleButtons(
                    isSelected: _selections,
                    constraints: const BoxConstraints(
                      minWidth: 100,
                      maxWidth: 150,
                      maxHeight: 56,
                      minHeight: 30,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    selectedColor: Colors.white,
                    fillColor: const Color(0xFFff7f3f),
                    color: Colors.grey,
                    onPressed: (int index) {
                      if (index == 0) {
                        type = "fasting";
                      } else {
                        type = "random";
                      }

                      log(type);
                      sheetState(
                        () {
                          for (int buttonIndex = 0;
                              buttonIndex < _selections.length;
                              buttonIndex++) {
                            _selections[buttonIndex] = buttonIndex == index;
                          }
                        },
                      );
                    },
                    children: const [
                      Text(
                        'Fasting',
                      ),
                      Text(
                        'PP/Random',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  type == "random"
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Meal Type'),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: DropdownButtonFormField(
                                      isDense: true,
                                      items: dropDownOptions
                                          .map<DropdownMenuItem<String>>(
                                              (value) {
                                        return DropdownMenuItem<String>(
                                          value: value["key"],
                                          child: Text(value["title"]),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropDownValue = newValue!;
                                          log(dropDownValue!);
                                        });
                                      },
                                      value: dropDownValue,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                            width: 1.25,
                                          ),
                                        ),
                                        constraints: const BoxConstraints(
                                          maxHeight: 36,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8),
                                      ),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      hint: Text(
                                        'Select',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientButton(
                        title: 'SAVE',
                        func: () {
                          onEditSubmit(bloodGlucoseId);
                        },
                        gradient: orangeGradient,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  DateTime? selectedDate;

  void datePicker() {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: datePickerDarkTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        log(value.toString());
        selectedDate = value;
        dateController.text = DateFormat('dd-MMM-yyyy').format(selectedDate!);
      });
    });
  }

  String? selectedTime;

  void timePicker() {
    showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: customTimePickerTheme,
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        var selection = value;
        var format24hrTime =
            '${selection.hour.toString().padLeft(2, "0")}:${selection.minute.toString().padLeft(2, "0")}:00';
        selectedTime = selection.format(context);
        timeController.text = selectedTime!;
        log('selected time in 24 hrs -> $format24hrTime');
        log('selected time -> ${selectedTime!}');
      });
    });
  }

  String? bloodGlucose;

  Widget inputFields(String glucoseLevel) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: levelController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFC3CAD9),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        hintText: glucoseLevel,
        hintStyle: const TextStyle(
          color: Color(0xFF959EAD),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'OpenSans',
        ),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      onChanged: (value) {
        bloodGlucose = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter $glucoseLevel ';
        }
        return null;
      },
    );
  }

  Widget toggleButton() {
    return ToggleButtons(
      isSelected: _selections,
      constraints: const BoxConstraints(
        minWidth: 100,
        maxWidth: 150,
        maxHeight: 56,
        minHeight: 30,
      ),
      borderRadius: BorderRadius.circular(30),
      selectedColor: Colors.white,
      fillColor: const Color(0xFFff7f3f),
      color: Colors.grey,
      onPressed: (int index) {
        if (index == 0) {
          type = "fasting";
        } else {
          type = "random";
        }

        log(type);
        setState(
          () {
            for (int buttonIndex = 0;
                buttonIndex < _selections.length;
                buttonIndex++) {
              _selections[buttonIndex] = buttonIndex == index;
            }
          },
        );
      },
      children: const [
        Text(
          'Fasting',
        ),
        Text(
          'PP/Random',
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
