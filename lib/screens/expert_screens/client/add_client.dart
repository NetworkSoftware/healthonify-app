import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/experts/add_client_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:provider/provider.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final formKey = GlobalKey<FormState>();

  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? password;
  String? gender;
  List genders = [
    'Male',
    'Female',
    'Others',
  ];

  late String? expertId;

  @override
  void initState() {
    super.initState();

    expertId = Provider.of<UserData>(context, listen: false).userData.id;
  }

  Map<String, dynamic> addClientMap = {};

  void onSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();

    addClientMap['firstName'] = firstName;
    addClientMap['lastName'] = lastName;
    addClientMap['email'] = email;
    addClientMap['mobileNo'] = mobile;
    addClientMap['password'] = mobile;
    addClientMap['expertId'] = expertId;

    log(addClientMap.toString());
    addExpertClient();
  }

  Future<void> addExpertClient() async {
    try {
      await Provider.of<AddClientProvider>(context, listen: false)
          .addClient(addClientMap);
      popFunction();
      Fluttertoast.showToast(msg: 'Added client successfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to add client');
    }
  }

  void popFunction() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Add Client'),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  hint: 'First Name',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    firstName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter client's first name";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  hint: 'Last Name',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    lastName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter client's last name";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8),
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
                  validator: (value) {
                    if (value == null) {
                      return "Please select the client's gender";
                    }
                    return null;
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
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  keyboard: TextInputType.phone,
                  hint: 'Mobile Number',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    mobile = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter client's mobile number";
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  hint: 'Email',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter client's email";
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Please provide a valid email id';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: orangeGradient,
        ),
        child: InkWell(
          onTap: () {
            onSubmit();
          },
          child: Center(
            child: Text(
              'SUBMIT',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: whiteColor),
            ),
          ),
        ),
      ),
    );
  }
}
