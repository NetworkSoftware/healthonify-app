import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/lab_models/family_member_model.dart';
import 'package:healthonify_mobile/models/lab_models/lab_models.dart';
import 'package:healthonify_mobile/providers/labs_provider/labs_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/lab_reports/add_family_member.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/lab_reports/lab_appointment.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/edit_profile.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class LabTestsScreen extends StatefulWidget {
  final String labTestId;
  final String labName;
  final List<LabTestModel> labTests;
  const LabTestsScreen(
      {super.key,
      required this.labTests,
      required this.labName,
      required this.labTestId});

  @override
  State<LabTestsScreen> createState() => _LabTestsScreenState();
}

class _LabTestsScreenState extends State<LabTestsScreen> {
  String? userDob;
  late String userName;
  late double userAge;
  late String userId;
  late String userMobile;
  String userGender = 'Female';

  Map<String, dynamic> labRequest = {};
  List<String> labTestIds = [];

  @override
  void initState() {
    super.initState();
    if (Provider.of<UserData>(context, listen: false).userData.dob == null) {
      Fluttertoast.showToast(
          msg: "Please update your date of birth in Your Profile");
      Navigator.of(context).pop();
      Future.delayed(
        Duration.zero,
        () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const YourProfileScreen(),
            ),
          );
        },
      );
    } else {
      userName =
          Provider.of<UserData>(context, listen: false).userData.firstName!;

      userDob = Provider.of<UserData>(context, listen: false).userData.dob!;
      userId = Provider.of<UserData>(context, listen: false).userData.id!;
      userMobile =
          Provider.of<UserData>(context, listen: false).userData.mobile!;
      gender = Provider.of<UserData>(context, listen: false).userData.gender!;
      var tempAge = DateFormat('MM/dd/yyyy').parse(userDob!);
      var datenow = DateTime.now();
      var age = datenow.difference(tempAge);
      var hours = age.inHours;
      var days = hours / 24;
      userAge = days / 365.25;

      labRequest['userId'] = userId;
      labRequest['location'] = {
        'type': 'Point',
        'coordinates': [13.003450, 77.662795],
      };

      labRequest['labTestCategoryId'] = labTestIds;
      labRequest['labId'] = widget.labTestId;
    }
  }

  List<FamilyMemberModel> familyMembers = [];

  Future<void> getFamilyMembers() async {
    try {
      familyMembers = await Provider.of<LabsProvider>(context, listen: false)
          .getFamilyMember(userId);
    } on HttpException catch (e) {
      log('Http Exception: $e');
    } catch (e) {
      log('Error fetching family members: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: widget.labName),
      body: FutureBuilder(
        future: getFamilyMembers(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const SizedBox(height: 10),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.labTests.length,
                      itemBuilder: (context, index) {
                        List<Map<String, dynamic>> testCheck = List.generate(
                          widget.labTests.length,
                          (idx) {
                            var test = widget.labTests[index].name;
                            return {
                              "name": test,
                              "value": false,
                            };
                          },
                        );
                        var testName = widget.labTests[index].name;
                        var price = widget.labTests[index].price;
                        return StatefulBuilder(
                          builder: (context, newState) {
                            // log(testCheck.toString());
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: CheckboxListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        testName!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Rs. $price",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                value: testCheck[index]['value'],
                                onChanged: (isChecked) {
                                  newState(() {
                                    testCheck[index]['value'] = isChecked;
                                  });
                                  if (isChecked == true) {
                                    labTestIds.add(widget
                                        .labTests[index].labTestCategoryId!);
                                  }
                                  if (isChecked == false) {
                                    labTestIds.removeWhere(
                                      (element) => element.contains(widget
                                          .labTests[index].labTestCategoryId!),
                                    );
                                  }
                                  log(labTestIds.toString());
                                },
                                activeColor: const Color(0xFFff7f3f),
                                checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: ElevatedButton(
                          onPressed: () {
                            labRequest['testFor'] = 'self';
                            labRequest['age'] = userAge.truncate();
                            labRequest['mobileNo'] = userMobile;
                            if (labTestIds.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please select a test');
                            } else {
                              showForMyselfBottomSheet();
                            }
                            log(labRequest.toString());
                          },
                          child: Text('For myself',
                              style: Theme.of(context).textTheme.labelSmall),
                        ),
                        title: Center(
                          child: Text(
                            'OR',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            labRequest['testFor'] = 'family';
                            if (labTestIds.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please select a test');
                            } else {
                              showFamilyMemberBottomSheet();
                            }
                            log(labRequest.toString());
                          },
                          child: Text('For family member',
                              style: Theme.of(context).textTheme.labelSmall),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  String? gender;
  List genders = [
    'Male',
    'Female',
    'Others',
  ];

  void showForMyselfBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, sheetState) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Profile',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Expanded(child: Text('Name:')),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Expanded(child: Text('Age:')),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${userAge.truncate()} yrs",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Expanded(child: Text('Gender:')),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownButtonFormField(
                                isDense: true,
                                items: genders
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  sheetState(() {
                                    gender = newValue!;
                                  });
                                },
                                value: gender,
                                style: Theme.of(context).textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  filled: false,
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
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                hint: Text(
                                  'Gender',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Expanded(child: Text('Mob No:')),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userMobile,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: gender == null
                          ? () {
                              Fluttertoast.showToast(
                                  msg: 'Please select your gender');
                            }
                          : () {
                              Navigator.pop(context);
                              labRequest['gender'] = gender;
                              log(labRequest.toString());
                              labSampleLocation();
                            },
                      child: const Text('Select'),
                    ),
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

  void showFamilyMemberBottomSheet() {
    Object? groupValue;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, sheetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                familyMembers.isEmpty
                    ? const Text('No Family members added')
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: familyMembers.length,
                        itemBuilder: (context, index) {
                          return RadioListTile(
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: index,
                            groupValue: groupValue,
                            onChanged: (ind) {
                              sheetState(() {
                                groupValue = ind;
                              });
                              labRequest['gender'] =
                                  familyMembers[index].gender;
                              labRequest['age'] = familyMembers[index].age;
                              labRequest['patientId'] = familyMembers[index].id;
                              labRequest['mobileNo'] =
                                  familyMembers[index].mobileNo;
                              log(labRequest.toString());
                            },
                            title: Text(
                              "${familyMembers[index].relativeFirstName!} ${familyMembers[index].relativeLastName!}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        },
                      ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const AddFamilyMemberForm();
                    })).then((value) {
                      setState(() {});
                    });
                  },
                  title: Text(
                    'Add a family member',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: orange),
                  ),
                  trailing: const Icon(Icons.add_rounded, color: orange),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: groupValue == null
                        ? null
                        : () {
                            Navigator.pop(context);
                            labSampleLocation();
                          },
                    child: const Text('Proceed'),
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

  void labSampleLocation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).canvasColor,
          title: Text(
            'Where would you like to give the lab sample?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                labRequest['testType'] = 'center';
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LabAppointmentScreen(
                    labTestMap: labRequest,
                  );
                }));
                log(labRequest.toString());
              },
              child: const Text('Visit Lab'),
            ),
            ElevatedButton(
              onPressed: () {
                labRequest['testType'] = 'home';
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return LabAppointmentScreen(
                    labTestMap: labRequest,
                  );
                }));
                log(labRequest.toString());
              },
              child: const Text('Home Pickup'),
            ),
          ],
        );
      },
    );
  }
}
