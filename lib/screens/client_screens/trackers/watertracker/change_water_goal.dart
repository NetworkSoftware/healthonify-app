import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/trackers/watertracker_func.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class ChangeWaterGoal extends StatefulWidget {
  final int goal;
  const ChangeWaterGoal({Key? key, required this.goal}) : super(key: key);

  @override
  State<ChangeWaterGoal> createState() => _ChangeWaterGoalState();
}

class _ChangeWaterGoalState extends State<ChangeWaterGoal> {
  final formKey = GlobalKey<FormState>();
  String? goalValue;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    goalValue = widget.goal.toString();
  }

  void popFunc() {
    Navigator.of(context).pop();
  }

  Future<void> updateWaterGoal(BuildContext context, String goal) async {
    setState(() {
      _isLoading = true;
    });
    await WaterTracker().updateWaterGoal(
        context,
        goal,
        () => Provider.of<AllTrackersData>(context, listen: false)
            .localUpdateWaterGoal(int.parse(goal)));
    popFunc.call();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: const CustomAppBar(appBarTitle: "Set your water goal"),
        body: Form(
          key: formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 25),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "Set Goal (Glasses)",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Flexible(child: textField()),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "1 Glass",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    child: Text(
                      "250 ml",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: grey),
              const SizedBox(height: 20),
              Text(
                '''Water is your body's principal chemical component and makes up about 50% to 70% of your body weight. Your body depends on water to survive. Every cell, tissue and organ in your body needs water to work properly. Lack of water can lead to dehydration — a condition that occurs when you don't have enough water in your body to carry out normal functions. Even mild dehydration can drain your energy and make you tired. The U.S. National Academies of Sciences, Engineering, and Medicine determined that an adequate daily fluid intake is:
        
        About 3.7L of fluids a day for men
        About 2.7L of fluids a day for women
        
        These recommendations cover fluids from water, other beverages and food. About 20% of daily fluid intake usually comes from food and the rest from drinks. A minimum of 2L of daily water consumption is considered to be the desired intake of water for our body.
        ''',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (_isLoading)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
            ],
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            if (!formKey.currentState!.validate()) {
              return;
            }
            formKey.currentState!.save();
            updateWaterGoal(context, goalValue!);
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(gradient: orangeGradient),
            child: const Center(child: Text("Done")),
          ),
        ),
      ),
    );
  }

  Widget textField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            initialValue: goalValue,
            textAlign: TextAlign.center,
            maxLines: null,
            onChanged: (value) {
              goalValue = value;
              log(goalValue!);
            },
            validator: (value) {
              if (int.parse(value!) > 100) {
                Fluttertoast.showToast(
                    msg: 'Water goal cannot be more than 100 glasses');
                return 'Water goal cannot be more than 100 glasses';
              }
              return null;
            },
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10)),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
