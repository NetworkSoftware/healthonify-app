import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/pill_reminder_provider.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

import '../../../constants/reminder_ids.dart';
import '../../../models/fiirebase_notifications.dart';
import '../../../models/health_care/pills_reminder_model.dart';
import '../../../models/shared_pref_manager.dart';
import '../../../providers/user_data.dart';

class PillReminderScreen extends StatefulWidget {
  const PillReminderScreen({super.key});

  @override
  State<PillReminderScreen> createState() => _PillReminderScreenState();
}

class _PillReminderScreenState extends State<PillReminderScreen> {
  List<PillsReminderModel> pillReminderModel = [];
  late TextEditingController timeController;
  late TextEditingController medicineNameController;
  late TextEditingController purposeController;
  late TextEditingController noteController;
  ReminderSharedPref reminderPreferences = ReminderSharedPref();
  bool trackReminder = false;
  var data;
  List notifList = [];
  bool? isloading;
  late String userId;
  String? selectedSetType;
  bool setTypeSelected = false;
  int dosageCount = 1;
  bool isModify = false;
  bool isModifyFirstTime = true;

  List setTake = [
    "before breakfast",
    "after breakfast",
    "before meal",
    "after meal",
    "before dinner",
    "after dinner"
  ];

  void cancelNotifications() {
    FirebaseNotif().cancelNotif(breakfastId);
  }

  Future<void> getPillReminders() async {
    var tempList = await reminderPreferences.getPillReminders();

    for (int index = 0; index < tempList.length; index++) {
      notifList.insert(index, tempList[index]);
    }
    setState(() {});
  }

  void savePillReminders() {
    reminderPreferences.savePillReminder(reminders: notifList);
    isModify = false;
  }

  void getReminders() async {
    await getPillReminders();
  }

  Future getPillsData() async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    log(userId!);
    pillReminderModel =
        await Provider.of<PillReminderProvider>(context, listen: false)
            .getPillsDataa(userId);
    // if(isModify == true){
    //   notifList = [];
    //   for (int index = 0; index < pillReminderModel.length; index++) {
    //     notifList.add(false);
    //   }
    // }else if(isModifyFirstTime == true){
    //   notifList = [];
    //   for (int index = 0; index < pillReminderModel.length; index++) {
    //     notifList.add(false);
    //   }
    //   isModifyFirstTime = false;
    // }

    if (notifList.isEmpty) {
      for (int index = 0; index < pillReminderModel.length; index++) {
        notifList.add(false);
      }
    }
    savePillReminders();
  }

  Map<String, dynamic> pillReminder = {};

  void popFunction() {
    Navigator.pop(context);
  }

  Future<void> postPillReminder(BuildContext context) async {
    if (timeController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please add time');
    } else if (medicineNameController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please add medicine name');
    } else if (purposeController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please add purpose note');
    } else if (selectedSetType == null) {
      Fluttertoast.showToast(msg: 'Please select how to take');
    } else if (noteController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please add note');
    } else {
      setState(() {
        isloading = true;
      });
      pillReminder = {
        "userId": userId,
        "time": timeController.text,
        "medicineName": medicineNameController.text,
        "instruction": selectedSetType,
        "purpose": purposeController.text,
        "note": noteController.text,
        "dosage": dosageCount,
      };
      try {
        await Provider.of<PillReminderProvider>(context, listen: false)
            .addPillReminder(pillReminder);
        popFunction();
        await getPillReminders();
        savePillReminders();
        medicineNameController.clear();
        purposeController.clear();
        timeController.clear();
        noteController.clear();
        selectedSetType = null;
        dosageCount = 1;
        Fluttertoast.showToast(msg: 'Pill Reminder updated');
      } on HttpException catch (e) {
        log(e.toString());
        Fluttertoast.showToast(msg: e.toString());
      } catch (e) {
        log(e.toString());
        Fluttertoast.showToast(msg: 'Unable to update pill reminder');
      } finally {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  Future<void> deletePillReminder(String id) async {
    try {
      await Provider.of<PillReminderProvider>(context, listen: false)
          .deletePillReminder(id);
      getPillsData();
      getPillReminders();
      Fluttertoast.showToast(msg: 'Pill Reminder Deleted');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to update pill reminder');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  void enableNotifications() {
    FirebaseNotif().scheduledNotification(
      id: breakfastId,
      hour: 3,
      minute: 28,
      title: "It's time for breakfast",
      desc: "It's time for breakfast",
    );
  }

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    getPillsData();
    getPillReminders();
    timeController = TextEditingController();
    medicineNameController = TextEditingController();
    purposeController = TextEditingController();
    noteController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // log(pillReminderModel[0].medicineName!);
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: 'Medicine Reminder',
        widgetRight: IconButton(
          onPressed: () async {
            bool result = await showBottomSheet();

            if (result == true) {
              setState(() {
                isModify == true;
              });
            }
          },
          icon: const Icon(
            Icons.add,
            color: whiteColor,
            size: 28,
          ),
          splashRadius: 20,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ListTile(
            //   tileColor: Theme.of(context).canvasColor,
            //   title: Text(
            //     'Send Notification[s]',
            //     style: Theme.of(context).textTheme.labelLarge,
            //   ),
            //   trailing: Switch(
            //     activeColor: orange,
            //     inactiveTrackColor: Colors.grey[600],
            //     value: trackReminder,
            //     onChanged: (val) {
            //       setState(() {
            //         trackReminder = !trackReminder;
            //
            //         if (trackReminder == false) {
            //           cancelNotifications();
            //         } else {
            //           enableNotifications();
            //         }
            //       });
            //     },
            //   ),
            // ),
            SizedBox(
              height: 800,
              child: FutureBuilder(
                  future: getPillsData(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        itemCount: pillReminderModel.length,
                        itemBuilder: (context, index) {
                          // log(pillReminderModel[index].medicineName!);
                          return ListTile(
                            leading: IconButton(
                              onPressed: () {
                                deletePillReminder(
                                    pillReminderModel[index].id.toString());
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pillReminderModel[index].medicineName ??
                                      'Medicine Name',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  pillReminderModel[index].time ?? "10:00 PM",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: orange,
                                      ),
                                ),
                              ],
                            ),
                            trailing: Switch(
                              activeColor: orange,
                              inactiveTrackColor: Colors.grey[600],
                              value: notifList[index],
                              onChanged: (val) {
                                setState(() {
                                  isModify = true;
                                  notifList[index] = !notifList[index];
                                  if (val == false) {
                                    FirebaseNotif().cancelNotif(sleepTimeId);
                                  } else {
                                    // FirebaseNotif().scheduledNotification(
                                    //   id: sleepTimeId,
                                    //   hour: sleepHour!,
                                    //   minute: sleepMinutes!,
                                    //   title: "It's time to sleep",
                                    //   desc: "ZZZ ... sweet dreams",
                                    // );
                                  }
                                  // trackReminder = !trackReminder;
                                  // callApi();
                                  savePillReminders();
                                });
                              },
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: medicineNameController,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).canvasColor,
                          filled: true,
                          hintText: "Enter Medicine Name[s]",
                          hintStyle:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: const Color(0xFF717579),
                                  ),
                          // suffixIcon: TextButton(
                          //   onPressed: () {
                          //     timePicker();
                          //   },
                          //   child: const Text('PICK'),
                          // ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        cursorColor: whiteColor,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: purposeController,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).canvasColor,
                          filled: true,
                          hintText: "Enter Purpose",
                          hintStyle:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: const Color(0xFF717579),
                                  ),
                          // suffixIcon: TextButton(
                          //   onPressed: () {
                          //     timePicker();
                          //   },
                          //   child: const Text('PICK'),
                          // ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        cursorColor: whiteColor,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        isDense: true,
                        items: setTake.map<DropdownMenuItem<String>>((value) {
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
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.grey,
                          //   ),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.grey,
                          //   ),
                          // ),
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
                          'Select How To Take',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: const Color(0xFF717579),
                                  ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          timePicker();
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: timeController,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).canvasColor,
                              filled: true,
                              hintText: 'Time',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: const Color(0xFF717579),
                                  ),
                              suffixIcon: TextButton(
                                onPressed: () {
                                  timePicker();
                                },
                                child: const Text('PICK'),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                            cursorColor: whiteColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).canvasColor,
                          filled: true,
                          hintText: "Enter Note",
                          // hintStyle: const TextStyle(
                          //   height: 1.4,
                          //   color: Color(0xFF717579)
                          // ),
                          hintStyle:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: const Color(0xFF717579),
                                  ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        cursorColor: whiteColor,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text("Dosage/Tablet :"),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (dosageCount == 1) {
                                      dosageCount;
                                    } else {
                                      dosageCount--;
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: orange,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Icon(
                                        Icons.remove,
                                        size: 20,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    //borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Text(
                                      dosageCount.toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: orange),
                                    ),
                                  )),
                              GestureDetector(
                                onTap: () {
                                  dosageCount++;
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: orange,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Icon(
                                        Icons.add,
                                        size: 20,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              postPillReminder(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: orange,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  "Set Reminder",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 30,
                      // ),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child:
                      // )
                    ],
                  ),
                ),
              );
            }));
  }

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
        timeController.text = value.format(context);
        // startTime = value;
        // endTime = value;
      });
    });
  }
}
