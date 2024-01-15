import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/trackers/steps_tracker_func.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class ChangeStepsGoal extends StatefulWidget {
  final int goal;
  const ChangeStepsGoal({Key? key, required this.goal}) : super(key: key);

  @override
  State<ChangeStepsGoal> createState() => _ChangeStepsGoalState();
}

class _ChangeStepsGoalState extends State<ChangeStepsGoal> {
  final formKey = GlobalKey<FormState>();
  String? goalValue;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    goalValue = widget.goal.toString();
  }

  Future<void> updateStepsGoal(
      BuildContext context, String goal, VoidCallback onSuccess) async {
    setState(() {
      _isLoading = true;
    });
    await StepsTrackerFunc().updateStepsGoal(context, goal, () {
      Provider.of<AllTrackersData>(context, listen: false)
          .localUpdateStepsGoal(int.parse(goal));
    });
    onSuccess.call();
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
        appBar: const CustomAppBar(appBarTitle: "Set your steps goal"),
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
                  Expanded(
                    child: Text(
                      "Set Goal (Steps)",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(child: textField()),
                ],
              ),
              const SizedBox(height: 20),
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
            updateStepsGoal(
                context, goalValue!, () => Navigator.of(context).pop());
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
              if (int.parse(value!) > 100000) {
                Fluttertoast.showToast(msg: 'Steps cannot be more than 100000');
                return 'Steps goal cannot be more than 100000';
              }
              return null;
            },
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 10, right: 10),
            ),
          ),
        ),
      ],
    );
  }
}
