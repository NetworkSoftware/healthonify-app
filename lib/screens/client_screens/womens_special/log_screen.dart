// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/func/womens_special_fn/womens_special_fns.dart';
import 'package:healthonify_mobile/models/womens_special_models/ws_flow_intensity_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/womens_special/womens_special_provider.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WomenLogScreen extends StatefulWidget {
  const WomenLogScreen({Key? key}) : super(key: key);

  @override
  State<WomenLogScreen> createState() => _WomenLogScreenState();
}

class _WomenLogScreenState extends State<WomenLogScreen> {
  List<String> flowIntensityList = [];
  List<String> symptomsList = [];
  List<String> moodsList = [];

  Map<String, dynamic> data = {
    "userId": "",
    "menustralDate": "",
    "flowIntensity": [],
    "symptoms": [],
    "moods": [],
  };

  void submit() async {
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    data["userId"] = userId;
    data["menustralDate"] = DateFormat("yyyy-MM-dd").format(DateTime.now());
    data["flowIntensity"] = flowIntensityList;
    data["symptoms"] = symptomsList;
    data["moods"] = moodsList;
    log(data.toString());
    LoadingDialog().onLoadingDialog("Please wait...", context);
    await WomensSpecialFun().postPeriods(context, data);
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Log'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 10),
                    child: Text(
                      'Log Flow symptoms and moods for today',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  // Card(
                  //   child: SizedBox(
                  //     height: 420,
                  //     width: MediaQuery.of(context).size.width * 0.8,
                  //     child: CalendarCarousel(
                  //       pageSnapping: true,
                  //       customGridViewPhysics:
                  //           const NeverScrollableScrollPhysics(),
                  //       weekendTextStyle: const TextStyle(
                  //         color: orange,
                  //       ),
                  //       weekdayTextStyle: const TextStyle(
                  //         color: whiteColor,
                  //       ),
                  //       daysTextStyle: const TextStyle(
                  //         color: Colors.grey,
                  //       ),
                  //       thisMonthDayBorderColor: Colors.grey,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  // Text(
                  //   'Logging flow will not add a period.',
                  //   style: Theme.of(context).textTheme.labelMedium,
                  // ),
                  // Text(
                  //   'To add or delete a period, select a date from the calendar then click log/delete period.',
                  //   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  //         color: Colors.grey[600],
                  //       ),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(height: 10),
                ],
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Flow',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              Consumer<WomensSpecialProvider>(
                builder: (context, value, child) => SizedBox(
                  height: 130,
                  child: value.flowIntensity.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: value.flowIntensity.length,
                          itemBuilder: (context, index) {
                            return scrollCard(
                              data: value.flowIntensity[index],
                              addData: (String id) {
                                if (!flowIntensityList.contains(id)) {
                                  flowIntensityList.add(id);
                                } else {
                                  flowIntensityList.remove(id);
                                }
                              },
                            );
                          },
                        )
                      : const SizedBox(),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Symptoms',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              Consumer<WomensSpecialProvider>(
                builder: (context, value, child) => SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: value.symptoms.length,
                    itemBuilder: (context, index) {
                      return scrollCard(
                          data: value.symptoms[index],
                          addData: (String id) {
                            if (!symptomsList.contains(id)) {
                              symptomsList.add(id);
                            } else {
                              symptomsList.remove(id);
                            }
                          });
                    },
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Moods',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              Consumer<WomensSpecialProvider>(
                builder: (context, value, child) => SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: value.moods.length,
                    itemBuilder: (context, index) {
                      return scrollCard(
                          data: value.moods[index],
                          addData: (String id) {
                            if (!moodsList.contains(id)) {
                              moodsList.add(id);
                            } else {
                              moodsList.remove(id);
                            }
                          });
                    },
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
                      submit();
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget scrollCard({
    required WSLogModel data,
    required Function(String id) addData,
  }) {
    bool isSelected = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Card(
          child: InkWell(
            onTap: () {
              addData(data.id);
              setState(
                () {
                  isSelected = !isSelected;
                },
              );
            },
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                color: isSelected ? Colors.purple[100] : whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: data.mediaLink,
                            height: 46,
                            width: 46,
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/icons/women_icon.png',
                              height: 46,
                              width: 46,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data.name,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.black,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
