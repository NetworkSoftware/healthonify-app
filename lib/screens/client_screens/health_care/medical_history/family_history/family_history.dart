import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/medical_history_provider/medical_history_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:provider/provider.dart';

class FamilyHistoryScreen extends StatefulWidget {
  final String? userID;
  const FamilyHistoryScreen({Key? key, this.userID}) : super(key: key);

  @override
  State<FamilyHistoryScreen> createState() => _FamilyHistoryScreenState();
}

class _FamilyHistoryScreenState extends State<FamilyHistoryScreen> {
  final formKey = GlobalKey<FormState>();

  late String? userId;

  String? illnessSince;
  List illnessDuration = [
    'Days',
    'Months',
    'Years',
  ];
  String? relation;
  List relatives = [
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Uncle',
    'Aunt',
  ];

  @override
  void initState() {
    super.initState();
    userId = widget.userID ??
        Provider.of<UserData>(context, listen: false).userData.id;
  }

  String? condition;
  String? sinceWhen;
  String? comments;

  Map<String, dynamic> familyHistoryData = {};

  void onSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    familyHistoryData['userId'] = userId;
    familyHistoryData['condition'] = condition;
    familyHistoryData['relation'] = relation;
    if (illnessSince != null && sinceWhen != null) {
      if (illnessSince == 'Days' && int.parse(sinceWhen!) < 1000) {
        familyHistoryData['sinceWhen'] = '$sinceWhen $illnessSince';
      } else if (illnessSince == 'Months' && int.parse(sinceWhen!) < 100) {
        familyHistoryData['sinceWhen'] = '$sinceWhen $illnessSince';
      } else if (illnessSince == 'Years' && int.parse(sinceWhen!) < 50) {
        familyHistoryData['sinceWhen'] = '$sinceWhen $illnessSince';
      } else {
        Fluttertoast.showToast(msg: 'Please choose a valid value');
        return;
      }
    }
    if (comments!.isNotEmpty) {
      familyHistoryData['comments'] = comments;
    }
    log('$familyHistoryData');
    postFamilyHistory();
  }

  void popfunction() {
    Navigator.pop(context);
  }

  Future<void> postFamilyHistory() async {
    try {
      await Provider.of<MedicalHistoryProvider>(context, listen: false)
          .postFamilyHistory(familyHistoryData);
      popfunction();
      Fluttertoast.showToast(msg: 'Family illness log added succesfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to post family illness log');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Family History'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Add family history',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  hint: 'Condition',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      condition = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the name of the condition';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
              const SizedBox(height: 10),
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
                              sinceWhen = value;
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
                          items: illnessDuration
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              illnessSince = newValue!;
                            });
                          },
                          value: illnessSince,
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
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  hint: 'Comments (Optional)',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      comments = value;
                    });
                  },
                ),
              ),
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
