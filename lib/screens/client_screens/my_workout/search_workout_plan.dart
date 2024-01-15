import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/workout/search_workout.dart';
import 'package:healthonify_mobile/providers/weight_management/workout_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class SearchWorkoutPlans extends StatefulWidget {
  const SearchWorkoutPlans({super.key});

  @override
  State<SearchWorkoutPlans> createState() => _SearchWorkoutPlansState();
}

class _SearchWorkoutPlansState extends State<SearchWorkoutPlans> {
  bool isLoading = false;
  List<SearchWorkoutPlanModel> workoutPlans = [];

  Future<void> searchWorkoutPlans() async {
    setState(() {
      isLoading = true;
    });
    try {
      workoutPlans = await Provider.of<WorkoutProvider>(context, listen: false)
          .searchWorkoutPlans(
              searchWorkout != null ? "?query=$searchWorkout" : "");
      log('fetched workout plans');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error getting workout details $e");
      Fluttertoast.showToast(msg: "Unable to fetch workout plans");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    searchWorkoutPlans();
  }

  String? searchWorkout;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Search Diet Plans'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  setState(() {
                    searchWorkout = value;
                    searchWorkoutPlans();
                  });
                },
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.black87,
                    ),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF717579),
                  ),
                  constraints: const BoxConstraints(
                    maxHeight: 56,
                  ),
                  fillColor: const Color(0xFFE3E3E3),
                  filled: true,
                  hintText: 'Search workout plans',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF717579),
                    fontFamily: 'OpenSans',
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFFE3E3E3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFFE3E3E3),
                    ),
                  ),
                ),
              ),
            ),
            workoutPlans.isEmpty
                ? const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
                    child: Center(
                      child: Text("No workout plans available"),
                    ),
                  )
                : isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: workoutPlans.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: InkWell(
                              onTap: () {},
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        workoutPlans[index].name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      workoutPlans[index].description != null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              child: Text(
                                                workoutPlans[index]
                                                    .description!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        color: Colors.grey),
                                              ),
                                            )
                                          : const SizedBox(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    workoutPlans[index]
                                                        .daysInweek!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                  Text(
                                                    'No of days in a week',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const VerticalDivider(
                                              color: Colors.grey,
                                              indent: 10,
                                              endIndent: 10,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "${workoutPlans[index].validityInDays!} days",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                  Text(
                                                    'Duration',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                ],
                                              ),
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
                      ),
          ],
        ),
      ),
    );
  }
}
