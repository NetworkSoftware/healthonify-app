import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/vitals/blood_glucose_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:healthonify_mobile/widgets/other/calendar_appbar.dart';

class LogBloodGlucose extends StatefulWidget {
  final String? userId;

  const LogBloodGlucose({Key? key, this.userId}) : super(key: key);

  @override
  State<LogBloodGlucose> createState() => _LogBloodGlucoseState();
}

class _LogBloodGlucoseState extends State<LogBloodGlucose> {
  final formKey = GlobalKey<FormState>();
  final List<bool> _selections = [
    true,
    false,
  ];

  bool isLoading = true;

  bool isPostPrandial = false;
  DateTime? _selectedDate;
  String? _selectedTime;
  String? bGlucose;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  String? dropDownValue;
  List dropDownOptions = [
    // 'Before Meal',
    // 'After Meal',
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

  // int? _value = 1;
  Map<String, String> data = {
    "userId": "",
    "date": "",
    "time": "",
    "bloodGlucoseLevel": "",
    "testType": "",
  };

  void onSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    String userId = widget.userId == null
        ? Provider.of<UserData>(context, listen: false).userData.id!
        : widget.userId!;
    data["userId"] = userId;
    data["date"] = DateFormat("MM/dd/yyyy").format(_selectedDate!);
    data["time"] = _selectedTime!;

    if (int.parse(bGlucose!) > 1000) {
      Fluttertoast.showToast(msg: 'Please enter a valid value');
      return;
    }

    data["bloodGlucoseLevel"] = bGlucose!;
    data["testType"] = isPostPrandial ? 'random' : 'fasting';
    if (isPostPrandial == true) {
      if (dropDownValue == null) {
        Fluttertoast.showToast(msg: 'Please select a meal type');
        return;
      }
      data["mealType"] = dropDownValue!;
    }
    // isPostPrandial ? data["mealType"] = dropDownValue! : null;

    log(data.toString());

    postBloodGlucose();
  }

  void popFunc() {
    Navigator.of(context).pop();
  }

  Future<void> postBloodGlucose() async {
    try {
      await Provider.of<BloodGlucoseData>(context, listen: false)
          .storeBloodGlucose(data);
      Fluttertoast.showToast(msg: "Logs added");
      popFunc();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to store logs");
    } catch (e) {
      log("Error hba1c widget $e");
      Fluttertoast.showToast(msg: "Unable to store logs");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Log your Blood Glucose'),
      body: Form(
        key: formKey,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 10),
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
                            log(_selectedDate.toString());
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
                      onTap: () => _timePicker(),
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
                                _timePicker();
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
                            log(_selectedDate.toString());
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
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 10),
                  //   child: HorizCalendar(),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       ElevatedButton(
                  //         onPressed: () {
                  //           _timePicker(context);
                  //         },
                  //         child: const Text('Choose Time'),
                  //       ),
                  //       Text(
                  //         _selectedTime == null
                  //             ? TimeOfDay.now().format(context)
                  //             : _selectedTime!.format(context),
                  //         style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  //               color: Colors.black,
                  //             ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20),
                  //   child: Text(
                  //     'Blood Glucose Level',
                  //     style: Theme.of(context).textTheme.labelLarge,
                  //   ),
                  // ),
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
                //  const SizedBox(height: 60),
                  toggleButton(),
                  isPostPrandial
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
                            ),
                          ],
                        )
                      : const Text(''),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: GradientButton(
                      func: () {
                        onSubmit();
                      },
                      title: 'Submit',
                      gradient: orangeGradient,
                    ),
                  ),
                  bloodGlucoseTable(context),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '''FACTS:
      Glucose is a simple sugar and is one of the primary molecules which serve as energy sources for both plants and animals.
      
      Insulin, a hormone produced by the pancreas, helps maintain normal blood sugar levels.
      
      Uncontrolled or high blood sugar levels can lead to health complications such as blindness, heart disease and kidney disease.
      
      Increase or decrease in the glucose level in the blood can lead to a condition called "diabetic coma”.
      
      Fasting normal blood sugar
       Normal for person without diabetes: 70–99 mg/dl (3.9–5.5 mmol/L)
       Official ADA recommendation for someone with diabetes: 80–130 mg/dl (4.4–7.2 mmol/L)
      
      Normal blood sugar 2 hours after meals
       Normal for person without diabetes: Less than 140 mg/dl (7.8 mmol/L)
       Official ADA recommendation for someone with diabetes: Less than 180 mg/dl (10.0 mmol/L)
      
      HbA1c
       Normal for person without diabetes: Less than 5.7%
       Official ADA recommendation for someone with diabetes: Less than 7.0%.
      
      Recommended Blood Sugar Targets:
      For people with type 1 diabetes, the American Diabetes Association recommends that blood sugar targets be :
      
      Before meals, your blood sugar should be:
      
      From 90 to 130 mg/dL (5.0 to 7.2 mmol/L) for adults
      
      From 90 to 130 mg/dL (5.0 to 7.2 mmol/L) for children, 13 to 19 years old
      
      From 90 to 180 mg/dL (5.0 to 10.0 mmol/L) for children, 6 to 12 years old
      
      From 100 to 180 mg/dL (5.5 to 10.0 mmol/L) for children under 6 years old
      
      After meals (1 to 2 hours after eating), your blood sugar should be:
      Less than 180 mg/dL (10 mmol/L) for adults
      
      For people with type 2 diabetes, the American Diabetes Association also recommends that blood sugar targets be :
      
      Before meals, your blood sugar should be:
      From 70 to 130 mg/dL (3.9 to 7.2 mmol/L) for adults
      
      After meals (1 to 2 hours after eating), your blood sugar should be:
      Less than 180 mg/dL (10.0 mmol/L) for adults.
            ''',
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bloodGlucoseTable(BuildContext context) {
    var tableTextStyle =
        Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 11);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(2.5),
                4: FlexColumnWidth(2),
              },
              border: TableBorder.all(
                color: Theme.of(context).textTheme.bodySmall!.color!,
              ),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Category', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Low Value', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('High Value', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Just after eating', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('2 hours after consuming',
                          style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      color: const Color(0xFF4599d9),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('Normal', style: tableTextStyle),
                      ),
                    ),
                    Container(
                      color: const Color(0xFF4599d9),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('70', style: tableTextStyle),
                      ),
                    ),
                    Container(
                      color: const Color(0xFF4599d9),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('100', style: tableTextStyle),
                      ),
                    ),
                    Container(
                      color: const Color(0xFF4599d9),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('170 - 200', style: tableTextStyle),
                      ),
                    ),
                    Container(
                      color: const Color(0xFF4599d9),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('< 140', style: tableTextStyle),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      color: orange,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('Early Diabetes', style: tableTextStyle),
                      ),
                    ),
                    Container(
                      color: orange,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('101', style: tableTextStyle),
                      ),
                    ),
                    Container(
                      color: orange,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('126', style: tableTextStyle),
                      ),
                    ),
                    Container(
                      color: orange,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('190 - 230               ', style: tableTextStyle),
                      ),
                    ),
                    Container(
                      color: orange,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('140 - 200', style: tableTextStyle),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child:
                            Text('Established Diabetes', style: tableTextStyle),
                      ),
                    ),
                    Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('126', style: tableTextStyle),
                      ),
                    ),
                    Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('-', style: tableTextStyle),
                      ),
                    ),
                    Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('230 - 300    ', style: tableTextStyle),
                      ),
                    ),
                    Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('> 200', style: tableTextStyle),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
        _selectedDate = value;
        dateController.text = DateFormat('dd-MMM-yyyy').format(_selectedDate!);
      });
    });
  }

  void _timePicker() {
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
        _selectedTime = selection.format(context);
        timeController.text = _selectedTime!;
        log('selected time in 24 hrs -> $format24hrTime');
        log('selected time -> ${_selectedTime!}');
      });
    });
  }

  Widget inputFields(String glucoseLevel) {
    return TextFormField(
      keyboardType: TextInputType.phone,
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
        bGlucose = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter $glucoseLevel ';
        }
        if (int.parse(value) > 1000) {
          return 'Please enter a valid value';
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
        setState(
          () {
            for (int buttonIndex = 0;
                buttonIndex < _selections.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                _selections[buttonIndex] = !_selections[buttonIndex];
              } else {
                _selections[buttonIndex] = false;
              }
            }
            isPostPrandial = !isPostPrandial;
            log(isPostPrandial.toString());
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
}
