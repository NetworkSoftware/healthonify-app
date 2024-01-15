// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:provider/provider.dart';

class FirstNameTextField extends StatelessWidget {
  final Function func;
  final String initValue;

  const FirstNameTextField(
      {Key? key, required this.func, required this.initValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'First Name',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              initialValue: initValue,
              onSaved: (newValue) => func(newValue),
              validator: (newValue) {
                if (newValue!.isEmpty) {
                  return "Enter your name";
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your first name',
                hintStyle: TextStyle(
                  color: Color(0xFF959EAD),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LastNameTextField extends StatelessWidget {
  final Function func;
  final String initValue;
  const LastNameTextField(
      {Key? key, required this.func, required this.initValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Last Name',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              initialValue: initValue,
              onSaved: (newValue) => func(newValue),
              validator: (newValue) {
                if (newValue!.isEmpty) {
                  return "Enter your last name";
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your last name',
                hintStyle: TextStyle(
                  color: Color(0xFF959EAD),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DOBField extends StatefulWidget {
  final Function func;
  String initValue;

  DOBField({Key? key, required this.func, required this.initValue})
      : super(key: key);

  @override
  State<DOBField> createState() => _DOBFieldState();
}

class _DOBFieldState extends State<DOBField> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    // DateTime _dateTime = DateTime.now();
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Text(
            'Date of Birth',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.initValue),
                Theme(
                  data: Theme.of(context).copyWith(
                    dialogBackgroundColor: darkGrey,
                  ),
                  child: TextButton(
                    onPressed: () => _datePicker(),
                    child: const Text(
                      "Select a date",
                      style: TextStyle(
                        color: Color(0xFF959EAD),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _datePicker() {
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
      initialDate: widget.initValue.isEmpty
          ? DateTime.now()
          : DateFormat("MM/dd/yyyy").parse(widget.initValue),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        // log(value.toString());
        selectedDate = value;
        // widget.initValue = value.toString();
        String date = DateFormat("MM/dd/yyyy").format(value);
        widget.initValue = date;
        log(date);
        widget.func(date.toString());
      });
    });
  }
}

class AddressTextField extends StatelessWidget {
  final Function func;
  final String initValue;
  const AddressTextField(
      {Key? key, required this.func, required this.initValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              maxLines: 10,
              initialValue: initValue,
              onSaved: (newValue) => func(newValue),
              validator: (newValue) {
                if (newValue!.isEmpty) {
                  return "Enter your address";
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your address',
                hintStyle: TextStyle(
                  color: Color(0xFF959EAD),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CityTextField extends StatelessWidget {
  final Function func;
  final String initValue;
  const CityTextField({Key? key, required this.func, required this.initValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'City',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              initialValue: initValue,
              onSaved: (newValue) => func(newValue),
              validator: (newValue) {
                if (newValue!.isEmpty) {
                  return "Enter your city";
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your city',
                hintStyle: TextStyle(
                  color: Color(0xFF959EAD),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StateTextField extends StatelessWidget {
  final Function func;
  final String initValue;
  const StateTextField({Key? key, required this.func, required this.initValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'State',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              initialValue: initValue,
              onSaved: (newValue) => func(newValue),
              validator: (newValue) {
                if (newValue!.isEmpty) {
                  return "Enter your State";
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your State',
                hintStyle: TextStyle(
                  color: Color(0xFF959EAD),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PincodeTextField extends StatelessWidget {
  final Function func;
  final String initValue;
  const PincodeTextField(
      {Key? key, required this.func, required this.initValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Pincode',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              initialValue: initValue,
              keyboardType: TextInputType.number,
              onSaved: (newValue) => func(newValue),
              validator: (newValue) {
                if (newValue!.isEmpty) {
                  return "Enter your Pincode";
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your Pincode',
                hintStyle: TextStyle(
                  color: Color(0xFF959EAD),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CountryTextField extends StatelessWidget {
  final Function func;
  final String initValue;
  const CountryTextField(
      {Key? key, required this.func, required this.initValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Country',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              initialValue: initValue,
              onSaved: (newValue) => func(newValue),
              validator: (newValue) {
                if (newValue!.isEmpty) {
                  return "Enter your Country";
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your Country',
                hintStyle: TextStyle(
                  color: Color(0xFF959EAD),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditValue extends StatelessWidget {
  final Function func;
  final String initValue;
  final String title;
  const EditValue(
      {Key? key,
      required this.func,
      required this.initValue,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              initialValue: initValue,
              onSaved: (newValue) => func(newValue),
              validator: (newValue) {
                if (newValue!.isEmpty) {
                  return "Enter your $title";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Enter your $title',
                hintStyle: const TextStyle(
                  color: Color(0xFF959EAD),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditExpertiseBtn extends StatefulWidget {
  final Function func;
  final String initValue;
  final String title;
  const EditExpertiseBtn({
    Key? key,
    required this.func,
    required this.initValue,
    required this.title,
  }) : super(key: key);

  @override
  State<EditExpertiseBtn> createState() => _EditExpertiseState();
}

class _EditExpertiseState extends State<EditExpertiseBtn> {
  String? dropdownValue;
  List<String> dropDownOptions = [
    'option 1',
    'option 2',
    'option 3',
    'option 4',
    'option 5',
  ];
  String id = '6229a980305897106867f787';
  Future<void> getExpertise(BuildContext context) async {
    try {
      await Provider.of<ExpertiseData>(context, listen: false)
          .fetchExpertise(id);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get fetch expertise $e");
      Fluttertoast.showToast(msg: "Unable to fetch expertise");
    }
  }

  String? idVal;
  List checkTopLevel() {
    String topLExp =
        Provider.of<UserData>(context, listen: false).userData.topLevelExpName!;

    log("heyyyy $topLExp");
    if (topLExp == "Physiotherapy") {
      id = "6229a980305897106867f787";
    }
    if (topLExp == "Dietitian") {}
    id = "6229a968eb71920e5c85b0af";

    if (topLExp == "Health Care") {
      id = "6343acb2f427d20b635ec853";
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    checkTopLevel();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getExpertise(context),
      builder: (context, snapshot) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 30),
            Consumer<ExpertiseData>(
              builder: (context, value, child) {
                List<String> expNames = [];
                List<String> expIds = [];
                for (var element in value.expertise) {
                  expNames.add(element.name!);
                  expIds.add(element.id!);
                }
                return Expanded(
                  child: DropdownButtonFormField(
                    items:
                        expNames.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
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
                    hint: Text(widget.initValue),
                    onSaved: (String? value) {
                      int idx = expNames.indexOf(value!);
                      idVal = expIds[idx];
                      log(idVal!);
                      widget.func(idVal);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
