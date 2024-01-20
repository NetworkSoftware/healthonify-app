import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/set_calories_constants/set_calories_constants.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/fitness_tools/fitness_tools_data.dart';
import 'package:healthonify_mobile/screens/client_screens/calories_plan.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/bmi_details.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/cards/custom_appbar.dart';

class SetCaloriesTarget extends StatefulWidget {
  final bool isAfterLogin;

  const SetCaloriesTarget({Key? key, this.isAfterLogin = false})
      : super(key: key);

  @override
  State<SetCaloriesTarget> createState() => _SetCaloriesTargetState();
}

class _SetCaloriesTargetState extends State<SetCaloriesTarget> {
  final _formKey = GlobalKey<FormState>();

  String? dropdownValue1;
  String? dropdownValue2;
  String? height;
  String? weight;
  String? gender;
  String? age;
  String? targetWeight;
  String? goalValue;

  bool isHeightCm = false;
  String? heightCm;
  String? heightFt;
  String heightInches = '0.0';
  double? feetToCm;

  final List<bool> _selections = [
    true,
    false,
  ];
  String _selected = "kgs";

  void convFeetToCm() {
    var feet = double.parse(heightFt!) * 30.48;
    var inches = double.parse(inchesController.text.trim()) * 2.54;
    feetToCm = feet + inches;
    height = feetToCm.toString();
    log("$feet ft $inches inches to Cm ===> $feetToCm");
  }

  TextEditingController heightController = TextEditingController();
  TextEditingController inchesController = TextEditingController();
  TextEditingController wghtController = TextEditingController();
  TextEditingController targetWeightController = TextEditingController();

  void getFt(String val) => heightFt = val;

  void getInches(String val) => heightInches = val;

  Future calculateCalories(Function(Map<String, dynamic>) onSuccess) async {
    try {
      var data = await Provider.of<FitnessToolsData>(context, listen: false)
          .calculateTool(
              "tool=calorieIntake&weight=$weight&height=$height&age=$age&gender=$gender&targetWeight=$targetWeight&goal=$dropdownValue1&activityLevel=$dropdownValue2&goalValue=$goalValue");

      onSuccess.call(data);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error calculating calories $e");
      Fluttertoast.showToast(msg: "Unable to calculate calories");
    }
  }

  void gndr(String val) {
    gender = val;
  }

  bool isCurrentWeight = true;

  void convertLbsToKgs(String value) {
    //! 1 lbs = 0.4536 kgs
    double convWeight = double.parse(value) * 0.4536;
    isCurrentWeight
        ? weight = convWeight.toString()
        : targetWeight = convWeight.toString();

    log('converted weight from lbs to kgs -> ${weight!}');
  }

  void onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    log('api called');
    log(weight ?? "weight null");
    log(targetWeight ?? "target weight null");
    log(height ?? "height null");
    log(age ?? "age null");
    log(gender ?? "gender null");
    log(dropdownValue1 ?? "goal null");
    log(dropdownValue2 ?? "activity null");
    if (gender == null || dropdownValue1 == null || dropdownValue2 == null) {
      Fluttertoast.showToast(
          msg: 'Please select your gender, goal and activity level');
    } else {
      calculateCalories((Map<String, dynamic> data) =>
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return CaloriesTargetScreen(
              calorieData: data,
              isAfterLogin: widget.isAfterLogin,
            );
          })));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !widget.isAfterLogin
          ? const CustomAppBar(appBarTitle: 'Set Calories Target')
          : const CustomAppBar(appBarTitle: 'Set Calories Target'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: GenderToggle(getGender: gndr),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 10),
                  child: Text(
                    'Goal',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  child: DropdownButtonFormField(
                    items: goalOptions.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value["key"],
                        child: Text(value["title"]),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue1 = newValue!;
                      });
                      log('weight goal => ${dropdownValue1!}');
                      goalValue = dropdownValue1;
                      log("goalValue => ${goalValue!}");
                    },
                    value: dropdownValue1,
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
                      'Select',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Height',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: heightController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFC3CAD9),
                                  ),
                                ),
                                hintText: isHeightCm
                                    ? 'Height in Cm'
                                    : 'Height in Feet',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF959EAD),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                              onSaved: (value) {
                                if (isHeightCm == true) {
                                  height = value;
                                } else {
                                  getFt(value!);
                                  convFeetToCm();
                                }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your height';
                                }
                                return null;
                              },
                            ),
                          ),
                          isHeightCm
                              ? const SizedBox()
                              : const SizedBox(width: 16),
                          isHeightCm
                              ? const SizedBox()
                              : Expanded(
                                  child: TextFormField(
                                    controller: inchesController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFC3CAD9),
                                        ),
                                      ),
                                      hintText: isHeightCm
                                          ? 'Height in Cm'
                                          : 'Height in Inches',
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF959EAD),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'OpenSans',
                                      ),
                                    ),
                                    onSaved: (value) {
                                      getInches(value!);
                                      convFeetToCm();
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        heightInches = '0.0';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          heightController.clear();
                          inchesController.clear();
                          setState(() {
                            isHeightCm = !isHeightCm;
                          });
                        },
                        child: Text(
                          isHeightCm ? 'change to ft' : 'change to cm',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Weight',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ToggleButtons(
                            isSelected: _selections,
                            constraints: const BoxConstraints(
                              minWidth: 46,
                              maxWidth: 56,
                              maxHeight: 64,
                              minHeight: 28,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            selectedColor: Colors.white,
                            fillColor: const Color(0xFFff7f3f),
                            color: Colors.teal,
                            onPressed: (int index) {
                              // log(index.toString());
                              wghtController.clear();
                              targetWeightController.clear();

                              if (index == 0) {
                                _selected = "kgs";
                              } else {
                                _selected = "lbs";
                              }

                              log(_selected);
                              // widget.getUnit!("cm");
                              setState(
                                () {
                                  for (int buttonIndex = 0;
                                      buttonIndex < _selections.length;
                                      buttonIndex++) {
                                    _selections[buttonIndex] =
                                        buttonIndex == index;
                                  }
                                },
                              );
                            },
                            children: const [
                              Text(
                                'Kgs',
                              ),
                              Text(
                                'Lbs',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: wghtController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFC3CAD9),
                        ),
                      ),
                      hintText: _selected == 'kgs'
                          ? 'Current Weight in Kgs'
                          : 'Current Weight in Lbs',
                      hintStyle: const TextStyle(
                        color: Color(0xFF959EAD),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    onSaved: (value) {
                      if (_selected == 'kgs') {
                        weight = value;
                      } else {
                        convertLbsToKgs(value!);
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your weight';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Target Weight',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: targetWeightController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFC3CAD9),
                        ),
                      ),
                      hintText: _selected == 'kgs'
                          ? 'Target Weight in Kgs'
                          : 'Target Weight in Lbs',
                      hintStyle: const TextStyle(
                        color: Color(0xFF959EAD),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    onSaved: (value) {
                      if (_selected == 'kgs') {
                        targetWeight = value;
                      } else {
                        isCurrentWeight = false;
                        convertLbsToKgs(value!);
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your target weight';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Age',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFC3CAD9),
                        ),
                      ),
                      hintText: 'Age in years',
                      hintStyle: const TextStyle(
                        color: Color(0xFF959EAD),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    onSaved: (value) {
                      age = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your age';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Daily Activity Level',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  child: DropdownButtonFormField(
                    items:
                        activityOptions.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value["key"],
                        child: Text(value["title"]),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue2 = newValue!;
                      });
                      log('daily act level => ${dropdownValue2!}');
                    },
                    value: dropdownValue2,
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
                      'Select',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: GradientButton(
                    title: 'Calculate',
                    func: () {
                      onSubmit();
                    },
                    gradient: orangeGradient,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    text: TextSpan(
                      text: '',
                      style: Theme.of(context).textTheme.bodySmall,
                      children: <TextSpan>[
                        TextSpan(
                            text: '\n\nSource',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.red),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => launchUrl(Uri.parse(
                                  "https://www.calculator.net/bmi-calculator.html"))),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
