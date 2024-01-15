import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/workout/add_workout_temp_model.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/workout_data.dart';
import 'package:provider/provider.dart';

class WorkoutFunc {
  Future<bool> postWorkoutData(BuildContext context,
      {required List<Schedule> schedule,
      required AddWorkoutModel workoutModel,
      required List<String> exNotes}) async {
    Map<String, dynamic> data = {};
    var userData = Provider.of<UserData>(context, listen: false).userData;
    String roleTitle = "userId";
    if (userData.roles![0]["name"] == "client") {
      roleTitle = "userId";
    } else {
      roleTitle = "expertId";
    }

    data = {
      "name": workoutModel.name,
      "daysInweek": workoutModel.duration,
      "validityInDays": workoutModel.noOfDays,
      "description": workoutModel.note,
      "goal": workoutModel.goal,
      "level": workoutModel.level,
      roleTitle: userData.id!,
      "type": roleTitle == "userId" ? "individual" : "paid",
      "schedule": List.generate(
          int.parse(workoutModel.duration!),
          (sIndex) => {
                "day": "Day ${sIndex + 1}",
                "exercises": schedule[sIndex].exercises == null
                    ? []
                    : List.generate(
                        schedule[sIndex].exercises!.length,
                        (index) => {
                              "round": schedule[sIndex].exercises![index].round,
                              "group": schedule[sIndex].exercises![index].group,
                              "exerciseId": schedule[sIndex]
                                  .exercises![index]
                                  .exerciseId!["_id"],
                              "setTypeId": "6263b18af0bd9642f4193c2b",
                              "bodyPartGroupId": schedule[sIndex]
                                  .exercises![index]
                                  .bodyPartGroupId!["_id"],
                              "bodyPartId": schedule[sIndex]
                                  .exercises![index]
                                  .bodyPartId!["_id"],
                              "setType":
                                  schedule[sIndex].exercises![index].setType,
                              "note": schedule[sIndex].exercises![index].note,
                              "sets": List.generate(
                                  schedule[sIndex]
                                      .exercises![index]
                                      .sets!
                                      .length,
                                  (i) => {
                                        "weight": schedule[sIndex]
                                                .exercises![index]
                                                .sets![i]
                                                .weight ??
                                            0,
                                        "weightUnit": schedule[sIndex]
                                                .exercises![index]
                                                .sets![i]
                                                .weightUnit ??
                                            "",
                                        "reps": schedule[sIndex]
                                                .exercises![index]
                                                .sets![i]
                                                .reps ??
                                            0,
                                        "distance": schedule[sIndex]
                                                .exercises![index]
                                                .sets![i]
                                                .distance ??
                                            0,
                                        "distanceUnit": schedule[sIndex]
                                                .exercises![index]
                                                .sets![i]
                                                .distanceUnit ??
                                            "",
                                        "time": schedule[sIndex]
                                                .exercises![index]
                                                .sets![i]
                                                .time ??
                                            0,
                                        "timeUnit": schedule[sIndex]
                                                .exercises![index]
                                                .sets![i]
                                                .timeUnit ??
                                            "",
                                        "speed": schedule[sIndex]
                                                .exercises![index]
                                                .sets![i]
                                                .speed ??
                                            "",
                                        "name": schedule[sIndex]
                                                .exercises![index]
                                                .sets![i]
                                                .name ??
                                            "",
                                        "set": schedule[sIndex]
                                                .exercises![index]
                                                .sets![i]
                                                .set ??
                                            "",
                                      }),
                            }),
                "note": exNotes[sIndex],
                "order": sIndex + 1
              })
    };

    // log("workout plan data ${json.encode(data)}");

    try {
      await Provider.of<WorkoutProvider>(context, listen: false)
          .postWorkoutPlan(data);
      return true;
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to save workout plan');
      return false;
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to save workout plan');
      return false;
    }
  }

  Future<void> updateWorkoutPlan(BuildContext context,
      {required WorkoutModel workoutModel,
      required String title,
      required List<String> notes,
      required VoidCallback popScreen}) async {
    LoadingDialog().onLoadingDialog("Updating", context);
    try {
      Map<String, dynamic> data = {
        "set": {
          "name": title,
          "daysInweek": workoutModel.daysInweek,
          "validityInDays": workoutModel.validityInDays,
          "goal": workoutModel.goal,
          "level": workoutModel.level,
          "description": workoutModel.description,
          "schedule": List.generate(
            notes.length,
            (sIndex) => {
              "day": workoutModel.schedule![sIndex].day,
              "exercises": workoutModel.schedule![sIndex].exercises == null
                  ? []
                  : List.generate(
                      workoutModel.schedule![sIndex].exercises!.length,
                      (index) => {
                            "round": workoutModel
                                .schedule![sIndex].exercises![index].round,
                            "group": workoutModel
                                .schedule![sIndex].exercises![index].group,
                            "exerciseId": workoutModel.schedule![sIndex]
                                .exercises![index].exerciseId!["_id"],
                            "setTypeId": "6263b18af0bd9642f4193c2b",
                            "bodyPartGroupId": workoutModel.schedule![sIndex]
                                .exercises![index].bodyPartGroupId!["_id"],
                            "bodyPartId": workoutModel.schedule![sIndex]
                                .exercises![index].bodyPartId!["_id"],
                            "setType": workoutModel
                                .schedule![sIndex].exercises![index].setType,
                            "note": workoutModel
                                .schedule![sIndex].exercises![index].note,
                            "sets": List.generate(
                                workoutModel.schedule![sIndex].exercises![index]
                                    .sets!.length,
                                (i) => {
                                      "weight": workoutModel
                                              .schedule![sIndex]
                                              .exercises![index]
                                              .sets![i]
                                              .weight ??
                                          0,
                                      "weightUnit": workoutModel
                                              .schedule![sIndex]
                                              .exercises![index]
                                              .sets![i]
                                              .weightUnit ??
                                          "",
                                      "reps": workoutModel
                                              .schedule![sIndex]
                                              .exercises![index]
                                              .sets![i]
                                              .reps ??
                                          0,
                                      "distance": workoutModel
                                              .schedule![sIndex]
                                              .exercises![index]
                                              .sets![i]
                                              .distance ??
                                          0,
                                      "distanceUnit": workoutModel
                                              .schedule![sIndex]
                                              .exercises![index]
                                              .sets![i]
                                              .distanceUnit ??
                                          "",
                                      "time": workoutModel
                                              .schedule![sIndex]
                                              .exercises![index]
                                              .sets![i]
                                              .time ??
                                          0,
                                      "timeUnit": workoutModel
                                              .schedule![sIndex]
                                              .exercises![index]
                                              .sets![i]
                                              .timeUnit ??
                                          "",
                                      "speed": workoutModel
                                              .schedule![sIndex]
                                              .exercises![index]
                                              .sets![i]
                                              .speed ??
                                          "",
                                      "name": workoutModel
                                              .schedule![sIndex]
                                              .exercises![index]
                                              .sets![i]
                                              .name ??
                                          "",
                                      "set": workoutModel.schedule![sIndex]
                                              .exercises![index].sets![i].set ??
                                          "",
                                    }),
                          }),
              "note": notes[sIndex],
              "order": workoutModel.schedule![sIndex].order
            },
          ),
        }
      };
      // log("data ${json.encode(data)}");
      await Provider.of<WorkoutProvider>(context, listen: false)
          .editWorkoutPlan(
        workoutModel.id!,
        data,
      );
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error getting workout details $e");
      Fluttertoast.showToast(msg: "Unable to update hep");
    } finally {
      popScreen();
    }
  }

  Future<Map<String, dynamic>> postWorkoutLog(
    BuildContext context, {
    required String workoutId,
    required List<ExerciseWorkoutModel> selectedExs,
    required Schedule schedule,
  }) async {
    // LoadingDialog().onLoadingDialog("Updating", context);
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;

    try {
      Map<String, dynamic> data = {
        "userId": userId,
        "date": DateFormat("MM/dd/yyyy").format(DateTime.now()),
        "weight": "65",
        "workoutPlanId": workoutId,
        "schedule": schedule.day,
        "exercises": List.generate(
          selectedExs.length,
          (index) => {
            "exerciseId": selectedExs[index].exerciseId!["_id"],
            "durationInMinutes": 2,
            "sets": List.generate(
                selectedExs[index].sets!.length,
                (i) => {
                      "weight": selectedExs[index].sets![i].weight == null
                          ? ""
                          : selectedExs[index].sets![i].weight == "undefined"
                              ? ""
                              : selectedExs[index].sets![i].weight,
                      "weightUnit":
                          selectedExs[index].sets![i].weightUnit ?? "",
                      "reps": selectedExs[index].sets![i].reps ?? 0,
                      "distance": selectedExs[index].sets![i].distance == null
                          ? ""
                          : selectedExs[index].sets![i].distance == "undefined"
                              ? ""
                              : selectedExs[index].sets![i].distance,
                      "distanceUnit":
                          selectedExs[index].sets![i].distanceUnit ?? "",
                      "time": selectedExs[index].sets![i].time ?? 0,
                      "timeUnit": selectedExs[index].sets![i].timeUnit ?? "",
                      "speed": selectedExs[index].sets![i].speed ?? "",
                      "name": selectedExs[index].sets![i].name ?? "",
                      "set": selectedExs[index].sets![i].set ?? "",
                    }),
          },
        ),
      };
      log("data ${json.encode(data)}");
      var responseData =
          await Provider.of<WorkoutProvider>(context, listen: false)
              .postWorkoutLog(
        data,
      );
      return responseData;
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
      return {};
    } catch (e) {
      log("Error getting workout details $e");
      Fluttertoast.showToast(msg: "Unable to update hep");
      return {};
    } finally {
      // Navigator.of(context).pop();
    }
  }
}
