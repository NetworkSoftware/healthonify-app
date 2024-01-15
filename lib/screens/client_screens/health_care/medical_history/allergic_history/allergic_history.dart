import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/medical_history_provider/medical_history_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:provider/provider.dart';

class AllergicHistoryScreen extends StatefulWidget {
  final String? userId;
  const AllergicHistoryScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<AllergicHistoryScreen> createState() => _AllergicHistoryScreenState();
}

class _AllergicHistoryScreenState extends State<AllergicHistoryScreen> {
  final formKey = GlobalKey<FormState>();
  Object? radioGroup = 0;
  String allergyType = 'Drug';
  String? allergyName;
  String? allergyFrom;
  String? description;
  String? allergyDuration;
  List allergySince = [
    'Days',
    'Months',
    'Years',
  ];

  late String userId;

  Map<String, dynamic> allergyData = {};

  void onSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    allergyData['userId'] = userId;
    allergyData['name'] = allergyName;
    allergyData['type'] = allergyType;
    if (allergyDuration == 'Days' && int.parse(allergyFrom!) < 1000) {
      allergyData['sinceFrom'] = '$allergyFrom $allergyDuration';
    } else if (allergyDuration == 'Months' && int.parse(allergyFrom!) < 100) {
      allergyData['sinceFrom'] = '$allergyFrom $allergyDuration';
    } else if (allergyDuration == 'Years' && int.parse(allergyFrom!) < 50) {
      allergyData['sinceFrom'] = '$allergyFrom $allergyDuration';
    } else {
      Fluttertoast.showToast(msg: 'Please choose a valid value');
      return;
    }
    allergyData['description'] = description;

    log(allergyData.toString());
    postAllergicHistory();
  }

  void popfunction() {
    Navigator.pop(context);
  }

  Future<void> postAllergicHistory() async {
    try {
      await Provider.of<MedicalHistoryProvider>(context, listen: false)
          .postAllergicHistory(allergyData);
      popfunction();
      Fluttertoast.showToast(msg: 'Allergy log added succesfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to post allergy log');
    }
  }

  @override
  void initState() {
    super.initState();
    userId = widget.userId == null
        ? Provider.of<UserData>(context, listen: false).userData.id!
        : widget.userId!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Allergic History'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RadioListTile(
                  value: 0,
                  groupValue: radioGroup,
                  onChanged: (value) {
                    setState(() {
                      radioGroup = value;
                      allergyType = 'Drug';
                    });
                  },
                  title: Text(
                    'Drug',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RadioListTile(
                  value: 1,
                  groupValue: radioGroup,
                  onChanged: (value) {
                    setState(() {
                      radioGroup = value;
                      allergyType = 'Food';
                    });
                  },
                  title: Text(
                    'Food',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  hint: 'Allergy Name',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      allergyName = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your allergy's name";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: CustomTextField(
                          keyboard: TextInputType.phone,
                          hint: 'Since when',
                          hintBorderColor: Colors.grey,
                          onSaved: (value) {
                            setState(() {
                              allergyFrom = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please add duration';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButtonFormField(
                          isDense: true,
                          items: allergySince
                              .map<DropdownMenuItem<String>>((value) {
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
                              allergyDuration = newValue!;
                            });
                          },
                          value: allergyDuration,
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
                              maxHeight: 56,
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
                            'Select',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Please choose period';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  maxLines: 5,
                  hint: 'Add note',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please add a description';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onSubmit();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Add',
                          style: Theme.of(context).textTheme.labelMedium),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
