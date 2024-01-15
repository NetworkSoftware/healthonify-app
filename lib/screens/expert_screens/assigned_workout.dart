import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/workout_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class AssignedWorkout extends StatefulWidget {
  const AssignedWorkout({Key? key}) : super(key: key);

  @override
  State<AssignedWorkout> createState() => _AssignedWorkoutState();
}

class _AssignedWorkoutState extends State<AssignedWorkout> {
  bool isLoading = false;

  List<WorkoutModel> workoutsList = [];
  Future<void> fetchWorkout() async {
    setState(() {
      isLoading = true;
    });
    try {
      String expertId =
      Provider.of<UserData>(context, listen: false).userData.id!;
      workoutsList = await Provider.of<WorkoutProvider>(context, listen: false)
          .getWorkoutPlan("?expertId=$expertId");
      log('fetched workout details');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error getting workout details $e");
      Fluttertoast.showToast(msg: "Unable to fetch HEP");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  String expertId = "";

  @override
  void initState() {
    super.initState();
    fetchWorkout();
    expertId =
    Provider.of<UserData>(context, listen: false).userData.id!;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: "Assigned Client",
      ),
      body: isLoading
          ? const Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : workoutsList.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 30, left: 10, right: 10),
          child: Text("No workout plans available. Please create one."),
        ),
      )
          : ListView.builder(
          shrinkWrap: true,
          itemCount: workoutsList.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 5,
            ),
            child: Card(
              child: InkWell(
                onTap: () {
                 // widget.func();
                },
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 120),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://static.independent.co.uk/s3fs-public/thumbnails/image/2018/03/19/18/idoh-exercise.jpg?width=1200"),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              workoutsList[index].name ?? "",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              workoutsList[index].description ?? "",
                              maxLines: 3,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              showSendDialog(context,workoutId: workoutsList[index].id!,clientId: expertId));
                                    },
                                    child: const Text("Assign"),
                                  ),
                                ],
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }

  Dialog showSendDialog(BuildContext context,{required String workoutId,required String clientId}) {
    return Dialog(
      //backgroundColor: darkGrey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Prescribe to client"),
            const SizedBox(
              height: 10,
            ),
            const Text("Are you sure you want to assign this to this client?"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    assignWorkoutPlan(workoutId: workoutId,clientId: clientId);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Send"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> assignWorkoutPlan({required String workoutId,required String clientId}) async {
    try {
      await Provider.of<WorkoutProvider>(context, listen: false)
          .assignWorkoutPlan({
        "workoutPlanId": workoutId,
        "userId": clientId,
      });
      popScreen();
    } on HttpException catch (e) {
      log("error assigning user ${e.toString}");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error assigning user ${e.toString}");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  void popScreen() {
    Navigator.of(context).pop();
  }
}
