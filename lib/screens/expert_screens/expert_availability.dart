import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/experts/upload_certificates_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/expert_home.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class ExpertAvailabilityScreen extends StatefulWidget {
  const ExpertAvailabilityScreen({super.key});

  @override
  State<ExpertAvailabilityScreen> createState() =>
      _ExpertAvailabilityScreenState();
}

class _ExpertAvailabilityScreenState extends State<ExpertAvailabilityScreen> {
  List weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();

  Map<String, dynamic> availability = {};

  List mondaySlots = [];
  List tuesdaySlots = [];
  List wednesdaySlots = [];
  List thursdaySlots = [];
  List fridaySlots = [];
  List saturdaySlots = [];
  List sundaySlots = [];

  List expertAvailability = [];

  bool isloading = false;

  void fetchExpertAvailability() async {
    setState(() {
      isloading = true;
    });
    await Provider.of<UserData>(context, listen: false).fetchExpertData();
    expertAvailability =
        Provider.of<UserData>(context, listen: false).userData.availability ??
            [];

    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    fetchExpertAvailability();

    availability = {
      "availability": [
        {
          "timings": mondaySlots,
          "day": "Monday",
        },
        {
          "timings": tuesdaySlots,
          "day": "Tuesday",
        },
        {
          "timings": wednesdaySlots,
          "day": "Wednesday",
        },
        {
          "timings": thursdaySlots,
          "day": "Thursday",
        },
        {
          "timings": fridaySlots,
          "day": "Friday",
        },
        {
          "timings": saturdaySlots,
          "day": "Saturday",
        },
        {
          "timings": sundaySlots,
          "day": "Sunday",
        },
      ],
    };
  }

  void updateAvailability() {
    if (mondaySlots.isEmpty &&
        tuesdaySlots.isEmpty &&
        wednesdaySlots.isEmpty &&
        thursdaySlots.isEmpty &&
        fridaySlots.isEmpty &&
        saturdaySlots.isEmpty &&
        sundaySlots.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please choose time slots for atleast one day');
      return;
    }

    availability['availability'][0]['timings'] = mondaySlots;
    availability['availability'][1]['timings'] = tuesdaySlots;
    availability['availability'][2]['timings'] = wednesdaySlots;
    availability['availability'][3]['timings'] = thursdaySlots;
    availability['availability'][4]['timings'] = fridaySlots;
    availability['availability'][5]['timings'] = saturdaySlots;
    availability['availability'][6]['timings'] = sundaySlots;

    uploadAvailability(context);
  }

  Future<void> uploadAvailability(BuildContext context) async {
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      await Provider.of<UploadCertificatesAndAvailabilityProvider>(context,
              listen: false)
          .uploadCertificatesAndAvailability(
        {
          "set": {"availability": availability['availability']}
        },
        userId,
      );

      popfunction();
      // gotohome();
      Fluttertoast.showToast(msg: 'Availability slots uploaded');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to upload availability slots');
    }
  }

  void popfunction() {
    Navigator.pop(context);
  }

  void gotohome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const ExpertHomeScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Availability'),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    shrinkWrap: true,
                    itemCount: availability['availability'].length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                availability['availability'][index]['day'],
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            const SizedBox(height: 8),
                            expertAvailability.isEmpty ||
                                    expertAvailability[index]["timings"].isEmpty
                                ? const SizedBox()
                                : SizedBox(
                                    height: 35,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: expertAvailability[index]
                                              ["timings"]
                                          .length,
                                      itemBuilder: (context, idx) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          child: Container(
                                            height: 20,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: orange,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Center(
                                                child: Text(
                                                  expertAvailability[index]
                                                      ["timings"][idx],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        color: whiteColor,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    timeSlotPicker(
                                      availability['availability'][index]
                                          ['day'],
                                      availability['availability'][index]
                                          ['timings'],
                                    );
                                  },
                                  child: expertAvailability.isEmpty ||
                                          expertAvailability[index]["timings"]
                                              .isEmpty
                                      ? const Text("Add time slots")
                                      : const Text("Edit time slots"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // trailing: TextButton(
                        //   onPressed: () {
                        //     timeSlotPicker(
                        //       availability['availability'][index]['day'],
                        //       availability['availability'][index]['timings'],
                        //     );
                        //   },
                        //   child: const Text('Add time slot'),
                        // ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        height: 56,
        color: orange,
        child: InkWell(
          onTap: () {
            updateAvailability();
          },
          child: Center(
            child: Text(
              'Update Time Slots',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: whiteColor),
            ),
          ),
        ),
      ),
    );
  }

  String? fromTime;
  String? toTime;

  void timeSlotPicker(String day, List list) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).canvasColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, sheetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Add your slot timings',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => timePicker(fromTimeController, true),
                            child: IgnorePointer(
                              child: TextFormField(
                                controller: fromTimeController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: grey,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: orange,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      timePicker(fromTimeController, true);
                                    },
                                    icon: const Icon(
                                      Icons.schedule_rounded,
                                      color: orange,
                                      size: 28,
                                    ),
                                  ),
                                  hintText: "Slot start",
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                style: Theme.of(context).textTheme.bodyMedium,
                                onSaved: (value) {
                                  log(fromTime.toString());
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please choose a time';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => timePicker(toTimeController, false),
                            child: IgnorePointer(
                              child: TextFormField(
                                controller: toTimeController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: grey,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: orange,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      timePicker(toTimeController, false);
                                    },
                                    icon: const Icon(
                                      Icons.schedule_rounded,
                                      color: orange,
                                      size: 28,
                                    ),
                                  ),
                                  hintText: "Slot end",
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                style: Theme.of(context).textTheme.bodyMedium,
                                onSaved: (value) {
                                  log(toTime.toString());
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please choose a time';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                list.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              list[index],
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                sheetState(() {
                                  list.remove(list[index]);
                                });
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                color: orange,
                                size: 28,
                              ),
                              splashRadius: 20,
                            ),
                          );
                        },
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (fromTime != null && toTime != null) {
                            if (day == 'Monday') {
                              mondaySlots.add("$fromTime - $toTime");
                              log(mondaySlots.toString());
                            }
                            if (day == 'Tuesday') {
                              tuesdaySlots.add("$fromTime - $toTime");
                              log(tuesdaySlots.toString());
                            }
                            if (day == 'Wednesday') {
                              wednesdaySlots.add("$fromTime - $toTime");
                              log(wednesdaySlots.toString());
                            }
                            if (day == 'Thursday') {
                              thursdaySlots.add("$fromTime - $toTime");
                              log(thursdaySlots.toString());
                            }
                            if (day == 'Friday') {
                              fridaySlots.add("$fromTime - $toTime");
                              log(fridaySlots.toString());
                            }
                            if (day == 'Saturday') {
                              saturdaySlots.add("$fromTime - $toTime");
                              log(saturdaySlots.toString());
                            }
                            if (day == 'Sunday') {
                              sundaySlots.add("$fromTime - $toTime");
                              log(sundaySlots.toString());
                            }
                            sheetState(() {});
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Please select start and end time');
                            return;
                          }
                          fromTimeController.clear();
                          toTimeController.clear();
                        },
                        child: const Text('Add Slot'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Confirm Slots'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        );
      },
    );
  }

  DateTime? from;
  DateTime? to;

  void timePicker(TextEditingController controller, bool isStartTime) {
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
        controller.text = value.format(context);

        if (isStartTime == true) {
          fromTime = value.format(context);
          from = DateFormat('h:mm a').parse(fromTime!);
        } else {
          toTime = value.format(context);
          to = DateFormat('h:mm a').parse(toTime!);
          if (fromTime != null) {
            if (to!.isBefore(from!)) {
              Fluttertoast.showToast(
                  msg: 'End time cannot be before start time');
              fromTime = null;
              toTime = null;
              fromTimeController.clear();
              toTimeController.clear();
              Navigator.pop(context);
              return;
            }
          } else {
            Fluttertoast.showToast(msg: 'Please select a starting time');
          }
        }
      });
    });
  }
}
