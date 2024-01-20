import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/physiotherapy/enquiry_form_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/succes_screens/successful_update.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/text%20fields/support_text_fields.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RequestAppointmentForm extends StatefulWidget {
  final String? title;
  final String? buttonTitle;
  List<String> options = [];

  RequestAppointmentForm(
      {Key? key,
      required this.title,
      required this.buttonTitle,
      required this.options})
      : super(key: key);

  @override
  State<RequestAppointmentForm> createState() => _RequestAppointmentFormState();
}

class _RequestAppointmentFormState extends State<RequestAppointmentForm> {
  final _key = GlobalKey<FormState>();
  String? dropDownValue;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    log("init");
    //getExpertise();
  }

  Future<void> getExpertise() async {
    var topLevelExpertiseIdList =
        Provider.of<ExpertiseData>(context, listen: false)
            .topLevelExpertiseData;
    String? id;
    log("Get exp");
    for (var element in topLevelExpertiseIdList) {
      log("check");

      if (element.name == "Physiotherapy") {
        id = element.id!;
        log("physio");
      }
    }
    try {
      await Provider.of<ExpertiseData>(context, listen: false)
          .fetchExpertise(id!);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get fetch expertise $e");
      Fluttertoast.showToast(msg: "Unable to fetch expertise");
    }
  }

  final Map<String, String> data = {
    "name": "",
    "email": "",
    "contactNumber": "",
    "message": "",
    "userId": "",
    "enquiryFor": "",
    "category": "",
    "date": "",
    "time": "",
    "flow": "physioTherapy"
  };

  Future<void> submitForm(VoidCallback onSuccess) async {
    LoadingDialog().onLoadingDialog("Please wait....", context);
    try {
      await Provider.of<EnquiryData>(context, listen: false)
          .submitEnquiryForm(data);
      onSuccess.call();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
      Navigator.of(context).pop();
    } catch (e) {
      log("Error request appointment $e");
      Fluttertoast.showToast(msg: "Not able to submit your request");
      Navigator.of(context).pop();
    }
  }

  void onSubmit() {
    if (!_key.currentState!.validate()) {
      // setState(() => isLoading = false);
      return;
    }
    if (dropDownValue == null) {
      Fluttertoast.showToast(
          msg: "Choose a value from the enquire now dropdown");
      return;
    }
    data["enquiryFor"] = dropDownValue!;
    data["category"] = 'Physiotherapy';
    data["date"] = startDate!;
    data["time"] = startTime!;
    _key.currentState!.save();
    log(data.toString());
    submitForm(() {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SuccessfulUpdate(
            onSubmit: (ctx) {
              Navigator.of(ctx).pop();
            },
            title:
                "Consultation Initiated. A expert will be assigned to you shortly",
            buttonTitle: "Back"),
      ));
    });
  }

  void setData(User userData) {
    data["name"] = userData.firstName!;
    data["email"] = userData.email!;
    data["contactNumber"] = userData.mobile!;
    data["userId"] = userData.id!;
    data["enquiryFor"] = "physioTherapy";
    data["date"] = "";
    data["time"] = "";
  }

  void getMessage(String message) => data["message"] = message;

  String? startTime;
  DateTime? _selectedDate;
  String? formattedDate;
  String? ymdFormat = DateFormat('yyyy-MM-dd').format(
      DateFormat('MM/dd/yyyy').parse(DateFormat.yMd().format(DateTime.now())));
  String? startDate;

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
      // DateTime tempDate = _selectedDate!;
      var todayDate = DateTime.now().toString().split(' ');

      log(todayDate[0]);

      log("qwee${ymdFormat.toString()}");
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
        startTime = format24hrTime;
        log('24h time: $startTime');
        controller.text = value.format(context);
      });
    });
  }

  void datePicker(TextEditingController controller) {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: datePickerDarkTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((value) {
      if (value == null) {
        return;
      }
      // var todayDate = DateTime.now().toString().split(' ');
      //
      // log(todayDate[0]);
      //
      // log(ymdFormat.toString());
      //
      //   if (value.hour < (DateTime.now().hour + 3)) {
      //     Fluttertoast.showToast(
      //         msg:
      //         'Consultation time must be atleast 3 hours after current time');
      //
      //     return;
      //   }

      setState(() {
        _selectedDate = value;
        var tempDate = DateFormat.yMd().format(_selectedDate!);
        DateTime temp = DateFormat('MM/dd/yyyy').parse(tempDate);

        // if (temp.isBefore(DateTime.now())) {
        //   Fluttertoast.showToast(msg: 'Please select a valid date');
        //   return;
        // }

        startDate = DateFormat('yyyy/MM/dd').format(temp);
        log('start date:  $startDate');
        ymdFormat = DateFormat('yyyy-MM-dd').format(temp);
        formattedDate = DateFormat('d MMM yyyy').format(temp);
        log(formattedDate!);
        controller.text = formattedDate!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserData>(context).userData;
    setData(userData);
    return SingleChildScrollView(
      child: Form(
        key: _key,
        child: Padding(
          padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 1),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                widget.title!,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enquiry for :'),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    isDense: true,
                    items: widget.options
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropDownValue = newValue!;
                      });
                    },
                    value: dropDownValue,
                    isExpanded: true,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.25,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 50,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    hint: Text(
                      'Select',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFF959EAD),
                          ),
                    ),
                  )
                ],
              ),
            ),
            // const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Explain your issue",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  IssueField(getValue: getMessage),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GradientButton(
                      title: widget.buttonTitle,
                      func: onSubmit,
                      gradient: orangeGradient,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Center(
                  //   child: SaveButton(
                  //     isLoading: false,
                  //     submit: onSubmit,
                  //     title: widget.buttonTitle,
                  //   ),
                  // ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
