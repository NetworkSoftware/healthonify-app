import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

enum RadioOptions1 {
  self,
  partner,
  relative,
  friend,
}

enum RadioOptions2 {
  trackCycle,
  challenges,
  avoidPreg,
  becomePreg,
  trackPreg,
  overcomePreg,
  pregCare,
}

class WomensProfile extends StatelessWidget {
  const WomensProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RadioOptions1? option1 = RadioOptions1.self;
    RadioOptions2? option2 = RadioOptions2.trackCycle;

    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              StatefulBuilder(
                builder: (context, newState) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'I use women care for',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          RadioListTile<RadioOptions1>(
                            title: Text(
                              'Self',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            value: RadioOptions1.self,
                            groupValue: option1,
                            onChanged: (RadioOptions1? value) {
                              newState(() {
                                option1 = value;
                              });
                            },
                          ),
                          RadioListTile<RadioOptions1>(
                            title: Text(
                              'Partner',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            value: RadioOptions1.partner,
                            groupValue: option1,
                            onChanged: (RadioOptions1? value) {
                              newState(() {
                                option1 = value;
                              });
                            },
                          ),
                          RadioListTile<RadioOptions1>(
                            title: Text(
                              'Relative',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            value: RadioOptions1.relative,
                            groupValue: option1,
                            onChanged: (RadioOptions1? value) {
                              newState(() {
                                option1 = value;
                              });
                            },
                          ),
                          RadioListTile<RadioOptions1>(
                            title: Text(
                              'Friend',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            value: RadioOptions1.friend,
                            groupValue: option1,
                            onChanged: (RadioOptions1? value) {
                              newState(() {
                                option1 = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              StatefulBuilder(
                builder: (context, newState) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'I use women care to',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          RadioListTile<RadioOptions2>(
                            title: Text(
                              'Track Cycles and Health',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            value: RadioOptions2.trackCycle,
                            groupValue: option2,
                            onChanged: (RadioOptions2? value) {
                              newState(() {
                                option2 = value;
                              });
                            },
                          ),
                          RadioListTile<RadioOptions2>(
                            title: Text(
                              'Overcome Menstruation Challenges',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            value: RadioOptions2.challenges,
                            groupValue: option2,
                            onChanged: (RadioOptions2? value) {
                              newState(() {
                                option2 = value;
                              });
                            },
                          ),
                          RadioListTile<RadioOptions2>(
                            title: Text(
                              'Avoid Pregnancy',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            value: RadioOptions2.avoidPreg,
                            groupValue: option2,
                            onChanged: (RadioOptions2? value) {
                              newState(() {
                                option2 = value;
                              });
                            },
                          ),
                          RadioListTile<RadioOptions2>(
                            title: Text(
                              'Get Pregnant',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            value: RadioOptions2.becomePreg,
                            groupValue: option2,
                            onChanged: (RadioOptions2? value) {
                              newState(() {
                                option2 = value;
                              });
                            },
                          ),
                          RadioListTile<RadioOptions2>(
                            title: Text(
                              'Track Pregnancy',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            value: RadioOptions2.trackPreg,
                            groupValue: option2,
                            onChanged: (RadioOptions2? value) {
                              newState(() {
                                option2 = value;
                              });
                            },
                          ),
                          RadioListTile<RadioOptions2>(
                            title: Text(
                              'Overcome Pregnancy Complications',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            value: RadioOptions2.overcomePreg,
                            groupValue: option2,
                            onChanged: (RadioOptions2? value) {
                              newState(() {
                                option2 = value;
                              });
                            },
                          ),
                          RadioListTile<RadioOptions2>(
                            title: Text(
                              'Post Pregnancy Care',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            value: RadioOptions2.pregCare,
                            groupValue: option2,
                            onChanged: (RadioOptions2? value) {
                              newState(() {
                                option2 = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientButton(
                    title: 'Save',
                    func: () {
                      Navigator.pop(context);
                    },
                    gradient: orangeGradient,
                  ),
                ],
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              //   child: const Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 16),
              //     child: Text('Save'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
