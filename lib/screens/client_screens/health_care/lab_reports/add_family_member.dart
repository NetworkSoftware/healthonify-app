import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/labs_provider/labs_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:provider/provider.dart';

class AddFamilyMemberForm extends StatefulWidget {
  const AddFamilyMemberForm({super.key});

  @override
  State<AddFamilyMemberForm> createState() => _AddFamilyMemberFormState();
}

class _AddFamilyMemberFormState extends State<AddFamilyMemberForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController dobController = TextEditingController();

  String? firstName;
  String? lastName;
  String? email;
  String? mobileNo;
  int? familyMemberAge;

  String? gender;
  List genders = [
    'Male',
    'Female',
    'Others',
  ];
  String? relation;
  List relatives = [
    'Husband',
    'Wife',
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Other',
  ];

  late String userId;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
  }

  Map<String, dynamic> familyMemberForm = {};

  void onSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    familyMemberForm['relatesTo'] = userId;
    familyMemberForm['firstName'] = firstName;
    familyMemberForm['lastName'] = lastName;
    familyMemberForm['dob'] = ymdFormat;
    familyMemberForm['age'] = familyMemberAge!.abs();
    familyMemberForm['gender'] = gender;
    familyMemberForm['isFamilyMember'] = true;
    familyMemberForm['relation'] = relation;
    familyMemberForm['mobileNo'] = mobileNo;

    if (email!.isNotEmpty) {
      familyMemberForm['email'] = email;
    }

    log(familyMemberForm.toString());
    addFamilyMember();
  }

  Future<void> addFamilyMember() async {
    try {
      await Provider.of<LabsProvider>(context, listen: false)
          .addFamilyMember(familyMemberForm);
      popFunction();
      Fluttertoast.showToast(msg: 'Family member added');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to add family member');
    }
  }

  void popFunction() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Add Family Member'),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  hint: 'First Name',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      firstName = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty || value.isEmpty) {
                      return 'Please add your first name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  hint: 'Last Name',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      lastName = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty || value.isEmpty) {
                      return 'Please add your last name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  keyboard: TextInputType.phone,
                  hint: 'Mobile Number',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      mobileNo = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the mobile number';
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    datePicker(dobController);
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: dobController,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).canvasColor,
                        filled: true,
                        hintText: 'Date of Birth',
                        hintStyle:
                            Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: const Color(0xFF717579),
                                ),
                        suffixIcon: TextButton(
                          onPressed: () {
                            datePicker(dobController);
                          },
                          child: const Text('PICK'),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      cursorColor: whiteColor,
                      validator: (value) {
                        if (value!.isEmpty || value.isEmpty) {
                          return 'Please choose your date of birth';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButtonFormField(
                  isDense: true,
                  items: genders.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: Theme.of(context).textTheme.bodyMedium),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButtonFormField(
                  isDense: true,
                  items: relatives.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: Theme.of(context).textTheme.bodyMedium),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      relation = newValue!;
                    });
                  },
                  value: relation,
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  hint: Text(
                    'Relation',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your relation';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  hint: 'Email (Optional)',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  onSubmit();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  child: Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime? _selectedDate;
  String? formattedDate;
  String? ymdFormat;

  void datePicker(TextEditingController controller) {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: MediaQuery.of(context).platformBrightness == Brightness.light
              ? datePickerLightTheme
              : datePickerDarkTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 36500)),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
        var tempDate = DateFormat.yMd().format(_selectedDate!);
        DateTime temp = DateFormat('MM/dd/yyyy').parse(tempDate);
        ymdFormat = DateFormat('yyyy-MM-dd').format(temp);
        formattedDate = DateFormat('d MMM yyyy').format(temp);
        log(formattedDate!);
        controller.text = formattedDate!;

        var datenow = DateTime.now();
        var age = temp.difference(datenow);
        var hours = age.inHours;
        var days = hours / 24;
        var ageYrs = days / 365.25;
        familyMemberAge = ageYrs.truncate();
      });
    });
  }
}
