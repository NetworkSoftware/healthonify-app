import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/wm/goals_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:healthonify_mobile/screens/client_screens/my_goals/my_goals.dart';

class WeightLostCard extends StatefulWidget {
  final Function updateWeight;
  final WeightGoalModel weightGoalData;

  const WeightLostCard(
      {required this.weightGoalData, Key? key, required this.updateWeight})
      : super(key: key);

  @override
  State<WeightLostCard> createState() => _WeightLostCardState();
}

class _WeightLostCardState extends State<WeightLostCard> {
  double? toLoseWeight;
  double? weightLost;
  double? weightPercent;
  bool isWeightLost = false;
  bool goalToGain = false;
  double? weight;
  String? weightValue;
  String? weightDesc;

  void calculateWeights() {
    if (widget.weightGoalData.startingWeight == null ||
        widget.weightGoalData.goalWeight == null) {
      Navigator.of(context).pop();
      Future.delayed(
        Duration.zero,
        () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const MyGoalsScreen(),
          ));
        },
      );
      return;
    }

    print("Starting : ${widget.weightGoalData.startingWeight}");
    print("goalWeight : ${widget.weightGoalData.goalWeight}");
    print("currentWeight : ${widget.weightGoalData.currentWeight}");

    if (double.parse(widget.weightGoalData.goalWeight!) >
        double.parse(widget.weightGoalData.startingWeight!)) {
      double gainGoal = double.parse(widget.weightGoalData.goalWeight!) -
          double.parse(widget.weightGoalData.startingWeight!);

      if (double.parse(widget.weightGoalData.startingWeight!) >
          double.parse(widget.weightGoalData.currentWeight!)) {
        weight = double.parse(widget.weightGoalData.startingWeight ?? "0") -
            double.parse(widget.weightGoalData.currentWeight ?? "0");
        weightDesc = "instead of $gainGoal kg gain";
        weightValue = "$weight kg lost";
        weightPercent = 0;
      } else {
        weight = double.parse(widget.weightGoalData.currentWeight ?? "0") -
            double.parse(widget.weightGoalData.startingWeight ?? "0");
        weightDesc = "out of $gainGoal kg";
        weightValue = "$weight kg gained";
        weightPercent = weight! / gainGoal;
        double weightCalculate = weight! / gainGoal;
        if(weightCalculate >= 1.0){
          weightPercent = 1.0;
        }else if(weightCalculate <= 0.0){
          weightPercent = 0.0;
        }else{
          weightPercent = weightCalculate;
        }
      }
    } else {
      double gainGoal = double.parse(widget.weightGoalData.startingWeight!) -
          double.parse(widget.weightGoalData.goalWeight!);

      if (double.parse(widget.weightGoalData.startingWeight!) <
          double.parse(widget.weightGoalData.currentWeight!)) {
        weight = double.parse(widget.weightGoalData.currentWeight ?? "0") -
            double.parse(widget.weightGoalData.startingWeight ?? "0");
        weightDesc = "instead of $gainGoal kg loose";
        weightValue = "$weight kg gained";
        weightPercent = 0;
      } else {
        weight = double.parse(widget.weightGoalData.startingWeight ?? "0") -
            double.parse(widget.weightGoalData.currentWeight ?? "0");
        weightValue = "$weight kg lost";
        weightDesc = "out of $gainGoal kg";

        double weightCalculate = weight! / gainGoal;
        if(weightCalculate >= 1.0){
          weightPercent = 1.0;
        }else if(weightCalculate <= 0.0){
          weightPercent = 0.0;
        }else{
          weightPercent = weightCalculate;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    calculateWeights();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.96,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      weightValue!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                              color: const Color(0xFFE80945)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  weightDesc!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, right: 25),
                              child: CircularPercentIndicator(
                                radius: 54,
                                animation: true,
                                animationDuration: 2000,
                                progressColor: const Color(0xFFE80945),
                                backgroundColor: Colors.white,
                                center: const Icon(
                                  Icons.accessibility_new_rounded,
                                  color: Color(0xFFE80945),
                                  size: 32,
                                ),
                                lineWidth: 17,
                                percent: weightPercent!,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.of(
                context, /*rootnavigator: true*/
              ).push(MaterialPageRoute(builder: (context) {
                return const MyGoalsScreen();
              })).then((value) {
                if (value == true) {
                  widget.updateWeight();
                  calculateWeights();
                  setState(() {});
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: orange
              ),
              child: const Icon(
                Icons.edit,
                size: 25,
                color: whiteColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
