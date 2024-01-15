import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/forms/fitness_form_func.dart';
import 'package:healthonify_mobile/models/http_exception.dart';


Map<String, dynamic> map = {"userId": "", "questionId": "", "answer": "65"};

class WeightTextField extends StatelessWidget {
  final Function getEmail;
  String userId;
  String qId;
  String hintText;
  String title;
  TextInputType textInputType;
  TextEditingController? controller;
  final ValueChanged<String?>? onChanged;
  WeightTextField(
      {Key? key,
      required this.getEmail,
      required this.text,
      required this.userId,
      required this.qId,
      required this.hintText,
      required this.title,
        this.controller,
        this.onChanged,
      this.textInputType = TextInputType.phone})
      : super(key: key);

  String text;
  String value = "";


  void submit(VoidCallback callback) {
    map["userId"] = userId;
    map["questionId"] = qId;
    map["answer"] = value;

    log(map.toString());
    try {
      FitnessFormFunc().submitFitnessForm(map);
      callback.call();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error submitting fitness form $e");
      Fluttertoast.showToast(msg: "unable to submit");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Text(title),
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    // title: Text(
                    //   hintText,
                    //   style: Theme.of(context).textTheme.bodyLarge,
                    // ),
                    content: TextFormField(
                      initialValue: value,
                      //controller: controller,
                      keyboardType: textInputType,
                      decoration: InputDecoration(
                        // border: InputBorder.none,
                        // focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        hintText: hintText,
                        hintStyle: const TextStyle(
                          color: Color(0xFF959EAD),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      //onChanged: onChanged,
                      // onChanged: onChanged ?? (v) => setState(
                      //   () => value = v,
                      // ),
                      onChanged:(v) => setState(
                            () => value = v,
                      ),
                      onSaved: (value) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              value = "";
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      TextButton(
                          onPressed: () {
                            if (value.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please enter a value");
                              return;
                            }
                            submit(
                              () => Navigator.of(context).pop(),
                            );
                          },
                          child: const Text("Ok")),
                    ],
                  ),
                );
              },
              child: Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).canvasColor,
                  child: value.isEmpty ? Text(text) : Text(value)),
            ),
          ],
        ),
      );
    });
  }
}

class HeightTextField extends StatelessWidget {
  final Function getEmail;
  const HeightTextField({Key? key, required this.getEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Height in Cm',
          hintStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your height';
          }
          return null;
        },
      ),
    );
  }
}

class WaistTextField extends StatelessWidget {
  final Function getEmail;
  const WaistTextField({Key? key, required this.getEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Waist in inches',
          hintStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your waist';
          }
          return null;
        },
      ),
    );
  }
}

class DescriptionTextField extends StatelessWidget {
  final Function getEmail;
  const DescriptionTextField({Key? key, required this.getEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Enter Description',
          hintStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a description';
          }
          return null;
        },
      ),
    );
  }
}

class FitnessGoalDropDown extends StatefulWidget {
  final String userId;
  final qid;
  const FitnessGoalDropDown({Key? key, required this.qid, required this.userId})
      : super(key: key);

  @override
  State<FitnessGoalDropDown> createState() => _FitnessGoalDropDownState();
}

class _FitnessGoalDropDownState extends State<FitnessGoalDropDown> {
  String? dropdownValue;
  List<String> dropDownOptions = [
    'Fat Loss',
    'Muscle Gain',
    'Weight Gain',
    'General Fitness',
    'Maintain Weight',
  ];

  Map<String, dynamic> map = {"userId": "", "questionId": "", "answer": "65"};

  void submit() {
    map["userId"] = widget.userId;
    map["questionId"] = widget.qid;
    map["answer"] = dropdownValue;

    log(map.toString());

    try {
      FitnessFormFunc().submitFitnessForm(map);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error submitting fitness form $e");
      Fluttertoast.showToast(msg: "unable to submit");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: dropDownOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
        submit();
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
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey,
      ),
      isExpanded: true,
      borderRadius: BorderRadius.circular(13),
      elevation: 1,
      hint: Text(
        'Fitness Goal',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onSaved: (value) {},
    );
  }
}

class FitnessLevelDropDown extends StatefulWidget {
  final String userId;
  final qid;
  const FitnessLevelDropDown(
      {Key? key, required this.userId, required this.qid})
      : super(key: key);

  @override
  State<FitnessLevelDropDown> createState() => _FitnessLevelDropDownState();
}

class _FitnessLevelDropDownState extends State<FitnessLevelDropDown> {
  String? dropdownValue;
  List<String> dropDownOptions = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'General',
  ];

  Map<String, dynamic> map = {"userId": "", "questionId": "", "answer": "65"};

  void submit() {
    map["userId"] = widget.userId;
    map["questionId"] = widget.qid;
    map["answer"] = dropdownValue;

    log(map.toString());

    try {
      FitnessFormFunc().submitFitnessForm(map);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error submitting fitness form $e");
      Fluttertoast.showToast(msg: "unable to submit");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: dropDownOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
        submit();
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
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey,
      ),
      isExpanded: true,
      borderRadius: BorderRadius.circular(13),
      elevation: 1,
      hint: Text(
        'Fitness Level',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onSaved: (value) {},
    );
  }
}

class CheckListTile extends StatefulWidget {
  final String checkTitle;
  final qId;
  final String userId;
  const CheckListTile(
      {required this.checkTitle,
      Key? key,
      required this.qId,
      required this.userId})
      : super(key: key);

  @override
  State<CheckListTile> createState() => _CheckListTileState();
}

bool isTapped = false;

class _CheckListTileState extends State<CheckListTile> {
  Map<String, dynamic> map = {"userId": "", "questionId": "", "answer": "65"};

  void submit() {
    map["userId"] = widget.userId;
    map["questionId"] = widget.qId;
    if (isTapped) {
      map["answer"] = "yes";
    } else {
      map["answer"] = "no";
    }

    log(map.toString());

    try {
      FitnessFormFunc().submitFitnessForm(map);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error submitting fitness form $e");
      Fluttertoast.showToast(msg: "unable to submit");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        widget.checkTitle,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      value: isTapped,
      onChanged: (isChecked) {
        setState(() {
          isTapped = isChecked!;
        });
        submit();
      },
      side: const BorderSide(
        color: orange,
      ),
      activeColor: const Color(0xFFff7f3f),
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class CheckListTile2 extends StatefulWidget {
  final String checkTitle;

  const CheckListTile2({
    required this.checkTitle,
    Key? key,
  }) : super(key: key);

  @override
  State<CheckListTile2> createState() => _CheckListTile2State();
}

class _CheckListTile2State extends State<CheckListTile2> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        widget.checkTitle,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      value: isTapped,
      onChanged: (isChecked) {
        setState(() {
          isTapped = isChecked!;
        });
      },
      side: const BorderSide(
        color: orange,
      ),
      activeColor: const Color(0xFFff7f3f),
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
