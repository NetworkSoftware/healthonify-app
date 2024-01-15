
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/health_meter/blood_pressure/blood_pressure_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/vitals_screens/hba1c_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/vitals_screens/blood_glucose_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/vitals_screens/heart_rate_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class VitalsScreen extends StatefulWidget {
  String? userId;
  VitalsScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  @override
  void initState() {
    // log(widget.userId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Vitals'),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            vitalCard(
              context,
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/icons/heart_rate.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  Text(
                    'Track your Heart Rate',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: whiteColor),
                  ),
                ],
              ),
              () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HeartRateScreen(
                    userId: widget.userId == null ? widget.userId : null,
                  );
                }));
              },
            ),
            const SizedBox(height: 16),
            vitalCard(
              context,
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/icons/heart_rate.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  Text(
                    'Track your Blood Pressure',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: whiteColor),
                  ),
                ],
              ),
              () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BloodPressureScreen(
                    userId: widget.userId,
                  );
                }));
              },
            ),
            const SizedBox(height: 16),
            vitalCard(
              context,
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/icons/blood_glucose.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  Text(
                    'Blood Glucose',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: whiteColor),
                  ),
                  // const Spacer(),
                  // Text(
                  //   '178',
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .headlineLarge!
                  //       .copyWith(color: whiteColor),
                  // ),
                  // const SizedBox(width: 6),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 10),
                  //   child: Text(
                  //     'mg/dl',
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .bodyMedium!
                  //         .copyWith(color: whiteColor),
                  //   ),
                  // ),
                ],
              ),
              () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const BloodGlucoseScreen();
                }));
              },
            ),
            const SizedBox(height: 16),
            vitalCard(
              context,
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/icons/hba1c.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  Text(
                    'Start tracking HbA1c (%)',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: whiteColor),
                  ),
                ],
              ),
              () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const HbA1cScreen();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget vitalCard(context, Widget text, Function onClicked) {
    return Center(
      child: InkWell(
        onTap: () {
          onClicked();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 125,
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
    );
  }
}
