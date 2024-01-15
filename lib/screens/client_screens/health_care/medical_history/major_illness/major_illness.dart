import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/medical_history_provider/medical_history_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:provider/provider.dart';

class MajorIllnessScreen extends StatefulWidget {
  final String? userID;
  const MajorIllnessScreen({Key? key, this.userID}) : super(key: key);

  @override
  State<MajorIllnessScreen> createState() => _MajorIllnessScreenState();
}

class _MajorIllnessScreenState extends State<MajorIllnessScreen> {
  final formKey = GlobalKey<FormState>();
  late String userId;
  String? condition;
  String? since;
  String? comments;
  String? illnessSince;
  List illnessDuration = [
    'Days',
    'Months',
    'Years',
  ];
  bool isMedication = false;

  Map<String, dynamic> majorIllnessData = {};

  void onSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    majorIllnessData['userId'] = userId;
    majorIllnessData['condition'] = condition;
    if (illnessSince == 'Days' && int.parse(since!) < 1000) {
      majorIllnessData['sinceWhen'] = '$since $illnessSince';
    } else if (illnessSince == 'Months' && int.parse(since!) < 100) {
      majorIllnessData['sinceWhen'] = '$since $illnessSince';
    } else if (illnessSince == 'Years' && int.parse(since!) < 50) {
      majorIllnessData['sinceWhen'] = '$since $illnessSince';
    } else {
      Fluttertoast.showToast(msg: 'Please choose a valid value');
      return;
    }
    majorIllnessData['onMedication'] = isMedication;
    if (comments!.isNotEmpty) {
      majorIllnessData['comments'] = comments;
    }

    log(majorIllnessData.toString());
    postMajorIllness();
  }

  void popfunction() {
    Navigator.pop(context);
  }

  Future<void> postMajorIllness() async {
    try {
      await Provider.of<MedicalHistoryProvider>(context, listen: false)
          .postMajorIllness(majorIllnessData);
      popfunction();
      Fluttertoast.showToast(msg: 'Major illness log added succesfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to post major illness log');
    }
  }

  @override
  void initState() {
    super.initState();
    userId = widget.userID ??
        Provider.of<UserData>(context, listen: false).userData.id!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Major Illness'),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 30),
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
                    return 'Please add your condition';
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
                            since = value;
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
                                style: Theme.of(context).textTheme.bodyMedium),
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
                            return 'Please select duration';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: whiteColor,
              ),
              child: CheckboxListTile(
                title: Text(
                  'I am on medication',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                value: isMedication,
                onChanged: (isChecked) {
                  setState(() {
                    isMedication = isChecked!;
                  });
                },
                activeColor: const Color(0xFFff7f3f),
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                controlAffinity: ListTileControlAffinity.trailing,
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
            const SizedBox(height: 20),
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
    );
  }
}
