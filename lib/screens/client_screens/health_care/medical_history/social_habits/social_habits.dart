import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/medical_history_provider/medical_history_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:provider/provider.dart';

class SocialHabitsScreen extends StatefulWidget {
  final String? userID;
  const SocialHabitsScreen({Key? key, this.userID}) : super(key: key);

  @override
  State<SocialHabitsScreen> createState() => _SocialHabitsScreenState();
}

class _SocialHabitsScreenState extends State<SocialHabitsScreen> {
  final formKey = GlobalKey<FormState>();

  String smoking = 'Smoking';
  String alcohol = 'Alcohol';
  String tobacco = 'Tobacco Chewing';

  String smokingFrequency = 'Cigarettes per year';
  String drinkingFrequency = 'mL per year';
  String chewingFrequency = 'Pouches per year';

  String? socialHabit;
  String? since;
  String? frequency;
  String? comments;

  Object? radioGroup = 0;
  String? habitDuration;
  List habitSince = [
    'Days',
    'Months',
    'Years',
  ];

  late String userId;

  Map<String, dynamic> socialHabitsData = {};

  void onSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    socialHabitsData['userId'] = userId;
    socialHabitsData['socialHabit'] = socialHabit;
    if (habitDuration == 'Days' && int.parse(since!) < 1000) {
      socialHabitsData['havingFrom'] = '$since $habitDuration';
    } else if (habitDuration == 'Months' && int.parse(since!) < 100) {
      socialHabitsData['havingFrom'] = '$since $habitDuration';
    } else if (habitDuration == 'Years' && int.parse(since!) < 50) {
      socialHabitsData['havingFrom'] = '$since $habitDuration';
    } else {
      Fluttertoast.showToast(msg: 'Please choose a valid value');
      return;
    }
    socialHabitsData['frequency'] = socialHabit == smoking
        ? '$frequency $smokingFrequency'
        : socialHabit == alcohol
            ? '$frequency $drinkingFrequency'
            : '$frequency $chewingFrequency';
    if (comments!.isNotEmpty) {
      socialHabitsData['comments'] = comments;
    }

    log(socialHabitsData.toString());
    postSocialHabit();
  }

  void popfunction() {
    Navigator.pop(context);
  }

  Future<void> postSocialHabit() async {
    try {
      await Provider.of<MedicalHistoryProvider>(context, listen: false)
          .postSocialHabits(socialHabitsData);
      popfunction();
      Fluttertoast.showToast(msg: 'Social habit added succesfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to post social habit');
    }
  }

  @override
  void initState() {
    super.initState();
    userId = widget.userID ??
        Provider.of<UserData>(context, listen: false).userData.id!;
    socialHabit = smoking;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Add Social Habits'),
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
                      socialHabit = smoking;
                    });
                  },
                  title: Text(
                    smoking,
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
                      socialHabit = alcohol;
                    });
                  },
                  title: Text(
                    alcohol,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RadioListTile(
                  value: 2,
                  groupValue: radioGroup,
                  onChanged: (value) {
                    setState(() {
                      radioGroup = value;
                      socialHabit = tobacco;
                    });
                  },
                  title: Text(
                    tobacco,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
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
                          items:
                              habitSince.map<DropdownMenuItem<String>>((value) {
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
                              habitDuration = newValue!;
                            });
                          },
                          value: habitDuration,
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
                              return 'Please select a period';
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
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: CustomTextField(
                          keyboard: TextInputType.phone,
                          hint: 'Frequency',
                          hintBorderColor: Colors.grey,
                          onSaved: (value) {
                            setState(() {
                              frequency = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please add a frequency';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    radioGroup == 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              smokingFrequency,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : const SizedBox(),
                    radioGroup == 1
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              drinkingFrequency,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : const SizedBox(),
                    radioGroup == 2
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              chewingFrequency,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : const SizedBox(),
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
