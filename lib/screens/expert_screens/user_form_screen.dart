import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class UserFormScreen extends StatefulWidget {
  final String clientId;
  const UserFormScreen({required this.clientId, super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  bool isloading = true;

  User client = User();
  Future<void> fetchUserDetails() async {
    try {
      client = await Provider.of<UserData>(context, listen: false)
          .fetchClientData(widget.clientId);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting user details : $e");
      Fluttertoast.showToast(msg: "Unable to fetch user details");
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    int sleepSeconds = client.dailySleepGoalInSeconds ?? 0;
    double hoursOfSleep = sleepSeconds / 3600;

    DateTime dob = DateFormat('MM/dd/yyyy').parse(client.dob!);
    String dateofbirth = DateFormat('d MMMM yyyy').format(dob);
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'User Form'),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${client.firstName!} ${client.lastName!}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      client.gender!,
                                    ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 36,
                                backgroundImage: NetworkImage(
                                  client.imageUrl!,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Date Of Birth : ",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                dateofbirth,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "City : ",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                client.city!,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "BMI : ",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                client.bmi!,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Body Fat : ",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                client.bodyFat!,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Daily sleep goal : ",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                client.dailySleepGoalInSeconds == null
                                    ? "0 hours"
                                    : "${hoursOfSleep.toStringAsFixed(1)} hours",
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Daily steps goal : ",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                client.dailyStepCountGoal == null
                                    ? "0 steps"
                                    : "${client.dailyStepCountGoal} steps",
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Daily calorie intake : ",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                client.calorieIntake == null
                                    ? "0 kcal"
                                    : "${client.calorieIntake} kcal",
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Daily water goal : ",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                client.dailyWaterGoal == null
                                    ? "0 glasses"
                                    : "${client.dailyWaterGoal} glasses",
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
