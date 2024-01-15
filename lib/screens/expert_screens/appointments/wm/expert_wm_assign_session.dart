import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/wm_sessions_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class ExpertWmAssignSession extends StatelessWidget {
  final String? subId;
  const ExpertWmAssignSession({Key? key, required this.subId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: "Assign Session"),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AssignSessionForm(
            subId: subId,
          ),
        ],
      ),
    );
  }
}

class AssignSessionForm extends StatefulWidget {
  final String? subId;
  const AssignSessionForm({Key? key, required this.subId}) : super(key: key);

  @override
  State<AssignSessionForm> createState() => _AssignSessionFormState();
}

class _AssignSessionFormState extends State<AssignSessionForm> {
  final _key = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  var _isLoading = false;

  Map<String, dynamic> reqData = {
    "subscriptionId": "",
    "specialExpertId": "",
    "name": "",
    // "description": "",
    "startTime": "",
    "startDate": "",
    "durationInMinutes": 90,
    // "status": "taken",
    "videoCallLink": "",
    // "benefits": "better back pain relief, reduces headache",
    "order": 1 // order of sessions, like order 1 means, its the first session
  };

  void getName(String value) => reqData["name"] = value;
  // void getDescription(String value) => reqData["description"] = value;
  // void getBenefits(String value) => reqData["benefits"] = value;

  _onSubmit() {
    setState(() {
      _isLoading = true;
    });

    if (!_key.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_selectedDate == null) {
      Fluttertoast.showToast(msg: "Please choose a date");
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (_selectedTime == null) {
      Fluttertoast.showToast(msg: "Please choose a time");
      setState(() {
        _isLoading = false;
      });
      return;
    }
    //format date to 24hr format
    var df = DateFormat("h:mm a").parse(_selectedTime!.format(context));
    String finalFormattedDate = DateFormat('HH:mm:ss').format(df);

    reqData["startDate"] = DateFormat("MM/dd/yyyy").format(_selectedDate!);
    reqData["startTime"] = finalFormattedDate;
    reqData["order"] = "1";
    reqData["subscriptionId"] = widget.subId!;
    reqData["specialExpertId"] =
        Provider.of<UserData>(context, listen: false).userData.id!;

    String newString = widget.subId!.substring(widget.subId!.length - 4);

    reqData["videoCallLink"] =
        DateTime.now().millisecondsSinceEpoch.toString() + newString;

    _key.currentState!.save();

    log(reqData.toString());

    assignSession();

    setState(() {
      _isLoading = false;
    });
  }

  void popFunc() {
    Navigator.of(context).pop();
  }

  Future<bool> assignSession() async {
    try {
      await Provider.of<WmSessionsData>(context, listen: false)
          .storeSession(reqData);
      popFunc();
      return false;
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Not able to assign sessions");
      return true;
    } catch (e) {
      log("Error store session $e");
      Fluttertoast.showToast(msg: "Not able to assign sessions");
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        children: [
          textFieldContainer(
              title: "Name",
              onSaved: getName,
              errorMessage: "Please enter the name for the sessions"),
          const SizedBox(
            height: 25,
          ),
          // textFieldContainer(
          //     title: "Description",
          //     onSaved: getDescription,
          //     errorMessage: "Please enter the name for the sessions"),
          // const SizedBox(
          //   height: 25,
          // ),
          // textFieldContainer(
          //     title: "Benefits",
          //     onSaved: getBenefits,
          //     errorMessage: "Please enter the name for the sessions"),
          // const SizedBox(
          //   height: 20,
          // ),
          dateAndTimePicker(),
        ],
      ),
    );
  }

  Widget dateAndTimePicker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                _datePicker();
              },
              child: Text(
                "Choose a date",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            Text(
              _selectedDate == null
                  ? ""
                  : DateFormat("MM/dd/yyyy").format(_selectedDate!),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                _timePicker();
              },
              child: Text(
                "Choose a time",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            Text(
              _selectedTime == null ? "" : _selectedTime!.format(context),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  _onSubmit();
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFFff7f3f),
                  ),
                ),
                child: const Text(
                  "Assign Session",
                ),
              ),
      ],
    );
  }

  void _datePicker() {
    var maxDate = DateTime.now().add(const Duration(days: 31));
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
            lastDate: maxDate)
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        log(value.toString());
        _selectedDate = value;
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
        log(value.toString());
        _selectedTime = value;
      });
    });
  }

  Widget textFieldContainer(
      {required String title,
      required String errorMessage,
      required Function onSaved}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: title,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return errorMessage;
        }
        return null;
      },
      onSaved: (value) {
        onSaved(value);
      },
    );
  }
}
