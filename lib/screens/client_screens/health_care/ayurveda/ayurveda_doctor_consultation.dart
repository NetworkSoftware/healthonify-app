import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/health_care/ayurveda_models/ayurveda_conditions_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/ayurveda_provider/ayurveda_provider.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class AyurvedaDoctorConsultation extends StatefulWidget {
  const AyurvedaDoctorConsultation({super.key});

  @override
  State<AyurvedaDoctorConsultation> createState() =>
      _AyurvedaDoctorConsultationState();
}

class _AyurvedaDoctorConsultationState
    extends State<AyurvedaDoctorConsultation> {
  String? description;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  List<AyurvedaConditionsModel> ayurvedaConditions = [];

  bool isLoading = true;

  Future<void> fetchAyurvedaConditions() async {
    try {
      ayurvedaConditions =
          await Provider.of<AyurvedaProvider>(context, listen: false)
              .getAyurvedaConditions();

      log('fetched ayurveda conditions');
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching ayurveda conditions');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  late String userId;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;

    fetchAyurvedaConditions().then(
      (value) {
        for (var ele in ayurvedaConditions) {
          treatmentConditions.add(ele.name);
        }
        log(treatmentConditions.toString());
      },
    );
  }

  String? requestCondition;
  List treatmentConditions = [];

  Map<String, dynamic> consultationData = {};

  Future<void> submitForm() async {
    try {
      await Provider.of<HealthCareProvider>(context, listen: false)
          .consultSpecialist(consultationData);
      popFunction();
      Fluttertoast.showToast(msg: 'Consultation scheduled successfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error request appointment $e");
      Fluttertoast.showToast(msg: "Not able to submit your request");
    }
  }

  void onSubmit() {
    consultationData['userId'] = userId;
    if (selectedTime != null) {
      consultationData['startTime'] = selectedTime;
    } else {
      Fluttertoast.showToast(msg: 'Please select a consultation time');
      return;
    }
    if (ymdFormat != null) {
      consultationData['startDate'] = ymdFormat;
    } else {
      Fluttertoast.showToast(msg: 'Please select a consultation date');
      return;
    }
    consultationData['expertiseId'] = '6368b1870a7fad5713edb4b4';

    if (description != null) {
      consultationData['description'] = description;
    } else {
      Fluttertoast.showToast(
          msg: 'Please enter a brief description for your consultation');
      return;
    }

    log(consultationData.toString());
    submitForm();
  }

  void popFunction() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Request Appointment'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Treatment Condition',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: DropdownButtonFormField(
                isDense: true,
                items:
                    treatmentConditions.map<DropdownMenuItem<String>>((value) {
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
                    requestCondition = newValue!;
                  });
                },
                value: requestCondition,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.25,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.25,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    maxHeight: 56,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
                hint: Text(
                  'Condition',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          datePicker(dateController);
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: dateController,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).canvasColor,
                              filled: true,
                              hintText: 'Date',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: const Color(0xFF717579),
                                  ),
                              suffixIcon: TextButton(
                                onPressed: () {
                                  datePicker(dateController);
                                },
                                child: Text(
                                  'PICK',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(color: orange),
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                            cursorColor: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          timePicker(timeController);
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
                                  timePicker(timeController);
                                },
                                child: Text(
                                  'PICK',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(color: orange),
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                            cursorColor: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: SizedBox(
                child: TextFormField(
                  maxLines: 5,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).canvasColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Describe your issue',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onSubmit();
                  },
                  child: Text(
                    'Request Appointment',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  String? selectedTime;

  void timePicker(TextEditingController controller) {
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
      var todayDate = DateTime.now().toString().split(' ');

      log(todayDate[0]);

      log(ymdFormat.toString());
      if (ymdFormat.toString() == todayDate[0]) {
        if (value.hour < (DateTime.now().hour + 3)) {
          Fluttertoast.showToast(
              msg:
                  'Consultation time must be atleast 3 hours after current time');

          return;
        }
      }
      setState(() {
        var format24hrTime =
            '${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}:00';
        selectedTime =
            "${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}:00";
        controller.text = value.format(context);
      });
    });
  }

  DateTime? _selectedDate;
  String? formattedDate;
  String? ymdFormat;

  void datePicker(TextEditingController controller) {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? datePickerDarkTheme
              : datePickerLightTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        // log(value.toString());
        _selectedDate = value;
        var tempDate = DateFormat.yMd().format(_selectedDate!);
        DateTime temp = DateFormat('MM/dd/yyyy').parse(tempDate);
        ymdFormat = DateFormat('yyyy-MM-dd').format(temp);
        // log(ymdFormat!);
        formattedDate = DateFormat('d MMM yyyy').format(temp);
        log(formattedDate!);
        controller.text = formattedDate!;
      });
    });
  }
}
