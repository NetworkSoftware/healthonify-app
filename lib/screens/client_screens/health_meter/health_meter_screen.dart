import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/hra_model/hra_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/vitals/all_vitals.dart';
import 'package:healthonify_mobile/providers/health_risk_assessment/hra_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/vitals/blood_glucose_data.dart';
import 'package:healthonify_mobile/providers/vitals/blood_pressure_data.dart';
import 'package:healthonify_mobile/screens/client_screens/health_meter/HRA/hra_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_meter/blood_pressure/blood_pressure_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/vitals_screens/blood_glucose_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class HealthMeterScreen extends StatefulWidget {
  const HealthMeterScreen({Key? key}) : super(key: key);

  @override
  State<HealthMeterScreen> createState() => _HealthMeterScreenState();
}

class _HealthMeterScreenState extends State<HealthMeterScreen> {
  late String userId;
  List<HraAnswerModel> hraAnswers = [];

  Future<void> getHraAnswers() async {
    try {
      hraAnswers = await Provider.of<HraProvider>(context, listen: false)
          .getHraScore(userId);
      log('hra score fetched');
    } on HttpException catch (e) {
      log("Unable to fetch hra score $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error loading hra score $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  Future<void> getbloodPressure(BuildContext context) async {
    try {
      await Provider.of<BloodPressureData>(context, listen: false)
          .getBpData(userId, "today");
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error enquiry widget $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  BloodGlucose bloodGlucose = BloodGlucose();

  Future<void> getBloodGlucose() async {
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      bloodGlucose = await Provider.of<BloodGlucoseData>(context, listen: false)
          .getBloodGlucose(userId, "today");
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error blood glucose $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;

    getbloodPressure(context);
    getBloodGlucose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Health Meter'),
      body: FutureBuilder(
        future: getHraAnswers(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return HraScreen(
                                    hraData: hraAnswers,
                                  );
                                }));
                              },
                              child: Card(
                                elevation: 5,
                                color: const Color(0xFFec6a13),
                                child: Column(
                                  children: [
                                    //const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                          child: Image.asset(
                                            'assets/images/hra.jpeg',
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Column(
                                          // crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.525,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: const Color(
                                                        0xFFec6a13)),
                                                borderRadius: const BorderRadius
                                                        .only(
                                                    //topLeft: Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                              ),
                                              child: const Text(
                                                'HRA Report',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFFec6a13),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Latest Score: ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                            color: whiteColor),
                                                  ),
                                                  hraAnswers.isNotEmpty
                                                      ? Text(
                                                          '${hraAnswers[0].hraScore}/${hraAnswers[0].maxScore}',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                                  color:
                                                                      whiteColor),
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 6),
                                                          child: Text(
                                                            '0',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                    color:
                                                                        whiteColor),
                                                          ),
                                                        )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                                  child: Text('View Report',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium!
                                                          .copyWith(
                                                              color: const Color(
                                                                  0xFFec6a13))),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Consumer<BloodPressureData>(
                              builder: (context, value, child) {
                            return SizedBox(
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const BloodPressureScreen();
                                  }));
                                },
                                child: Card(
                                  elevation: 5,
                                  color: const Color(0xFFec6a13),
                                  child: Column(
                                    children: [
                                      //const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                            child: Image.asset(
                                              'assets/images/bp.jpeg',
                                              height: 150,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Column(
                                            // crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 10),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.525,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xFFec6a13)),
                                                  borderRadius: const BorderRadius
                                                          .only(
                                                      //topLeft: Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10)),
                                                ),
                                                child: const Text(
                                                  'Blood Pressure',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xFFec6a13),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Latest Score: ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium!
                                                          .copyWith(
                                                              color:
                                                                  whiteColor),
                                                    ),
                                                    if (value.bpData
                                                            .latestData !=
                                                        null)
                                                      Text(
                                                        "${value.bpData.latestData!['systolic'] ?? "0"}/${value.bpData.latestData!['diastolic'] ?? "0"}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                                color:
                                                                    whiteColor),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Average Score',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium!
                                                          .copyWith(
                                                              color:
                                                                  whiteColor),
                                                    ),
                                                    if (value.bpData
                                                            .averageData !=
                                                        null)
                                                      Text(
                                                        value.bpData.averageData !=
                                                                null
                                                            ? "${value.bpData.averageData!['systolicAverage']}/${value.bpData.averageData!['diastolicAverage']}"
                                                            : "No data available",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                color:
                                                                    whiteColor),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () async {
                                bool result = await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const BloodGlucoseScreen();
                                }));

                                print("result : $result");

                                if (result == true) {
                                  getBloodGlucose();
                                  setState(() {});
                                }
                              },
                              child: Card(
                                elevation: 5,
                                color: const Color(0xFFec6a13),
                                child: Column(
                                  children: [
                                    //const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                          child: Image.asset(
                                            'assets/images/blood_glucose.jpeg',
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Column(
                                          // crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.525,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: const Color(
                                                        0xFFec6a13)),
                                                borderRadius: const BorderRadius
                                                        .only(
                                                    //topLeft: Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                              ),
                                              child: const Text(
                                                'Blood Glucose(Random)',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFFec6a13),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Latest Score: ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                            color: whiteColor),
                                                  ),
                                                  Text(
                                                    bloodGlucose.recentLogs ==
                                                            null
                                                        ? "0 mg/dl"
                                                        : bloodGlucose
                                                                    .recentLogs![
                                                                        0]
                                                                    .bloodGlucoseLevel ==
                                                                null
                                                            ? 'No data available'
                                                            : '${bloodGlucose.recentLogs![0].bloodGlucoseLevel} mg/dl',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                            color: whiteColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Average Score',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                            color: whiteColor),
                                                  ),
                                                  Text(
                                                    bloodGlucose.averageData ==
                                                            null
                                                        ? "0 mg/dl"
                                                        : bloodGlucose.averageData![
                                                                    'randomTypeAverage'] ==
                                                                null
                                                            ? 'No data available'
                                                            : '${bloodGlucose.averageData!['randomTypeAverage']} mg/dl',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color: whiteColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ],
                                    ),
                                    //const SizedBox(height: 10),

                                    //
                                    // const SizedBox(height: 10),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.end,
                                    //   children: [
                                    //     Padding(
                                    //       padding: const EdgeInsets.all(8.0),
                                    //       child: Container(
                                    //         decoration: BoxDecoration(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(10),
                                    //             color: Colors.white),
                                    //         child: Padding(
                                    //           padding: const EdgeInsets.symmetric(
                                    //               horizontal: 15, vertical: 10),
                                    //           child: Text('View',
                                    //               style: Theme.of(context)
                                    //                   .textTheme
                                    //                   .labelMedium!
                                    //                   .copyWith(
                                    //                       color:
                                    //                           Color(0xFFec6a13))),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     // Padding(
                                    //     //   padding: const EdgeInsets.all(8.0),
                                    //     //   child: GradientButton(
                                    //     //     title: 'View',
                                    //     //     func: () {
                                    //     //       Navigator.push(context,
                                    //     //           MaterialPageRoute(
                                    //     //               builder: (context) {
                                    //     //                 return HraScreen(
                                    //     //                   hraData: hraAnswers,
                                    //     //                 );
                                    //     //               }));
                                    //     //     },
                                    //     //     gradient: blueGradient,
                                    //     //   ),
                                    //     // ),
                                    //   ],
                                    // ),
                                    // const Padding(
                                    //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                    //   child: Text(
                                    //     "Believe us, your chronic condition can be reversed",
                                    //     style: TextStyle(
                                    //         color: Color(0xFFec6a13),
                                    //         fontSize: 14,
                                    //         fontWeight: FontWeight.bold),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget healthMeterCard(context, Widget text, Function onClicked) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: InkWell(
          onTap: () {
            onClicked();
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            // height: 125,
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF8C0000),
                  Color(0xFFFF5757),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: text,
          ),
        ),
      ),
    );
  }
}
