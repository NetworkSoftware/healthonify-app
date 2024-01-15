import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/workout/search_workout.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:http/http.dart' as http;

class WorkoutProvider with ChangeNotifier {
  Future<List<WorkoutModel>> getWorkoutPlan(String data) async {
    String url = '${ApiUrl.wm}get/workoutPlan$data';

    log("workout url $url");

    List<WorkoutModel> tempWorkout = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-type": "application/json"},
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = responseData['data'] as List<dynamic>;

        for (var ele in data) {
          tempWorkout.add(
            WorkoutModel(
              id: ele['_id'],
              name: ele['name'],
              daysInweek: ele['daysInweek'],
              validityInDays: ele['validityInDays'],
              schedule: List<Schedule>.from(
                  ele["schedule"].map((x) => Schedule.fromJson(x))),
              createdAt: DateTime.parse(ele["created_at"]),
              updatedAt: DateTime.parse(ele["updated_at"]),
              updatedAtInString: ele["updated_at"],
              createdAtString:ele["created_at"],
              description: ele['description'],
              expertId: ele['expertId'],
              goal: ele['goal'],
              level: ele['level'],
              price: ele["price"].toString(),
            ),
          );
        }
        // log('workout data $data');
        return tempWorkout;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WorkoutModel>>
  getUserWorkoutPlan(String userId) async {
    String url = '${ApiUrl.wm}fetch/userWorkoutPlan?userId=$userId';
    log("workout get user plan $url");

    List<WorkoutModel> tempWorkout = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-type": "application/json"},
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      // log(responseData.toString());

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        if ((responseData["data"] as List<dynamic>).isEmpty) {
          return tempWorkout;
        }

        final d = responseData["data"] as List<dynamic>;

        for (var ele in d) {
          if(ele['workoutPlanId'] != null){
            tempWorkout.add(
              WorkoutModel(
                id: ele['workoutPlanId']['_id'],
                name: ele['workoutPlanId']['name'],
                daysInweek: ele['workoutPlanId']['daysInweek'].toString(),
                validityInDays:
                ele['workoutPlanId']['validityInDays'].toString(),
                schedule: List<Schedule>.from(ele['workoutPlanId']["schedule"]
                    .map((x) => Schedule.fromJson(x))),
                // createdAt: DateTime.parse(ele['workoutPlanId']["created_at"]),
                // updatedAt: DateTime.parse(ele['workoutPlanId']["updated_at"]),
                description: ele['workoutPlanId']['description'],
              ),
            );
          }

        }
//         if (responseData['data'][0]['workoutPlanId'] != null) {
//           // final data =
//           //     responseData['data'][0]['workoutPlanId'] as Map<String, dynamic>;
// //responseData["dataCount"] != 0 &&
//
//
//           // log('workout data$data');
//         }

        return tempWorkout;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e,trace) {
      print("Trace : $trace");
      rethrow;
    }
  }

  Future<List<SearchWorkoutPlanModel>> searchWorkoutPlans(String query) async {
    String url = '${ApiUrl.wm}search/workoutPlan$query';

    log("search workout plan url $url");

    List<SearchWorkoutPlanModel> workoutPlans = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = responseData['data'] as List<dynamic>;

        for (var ele in data) {
          workoutPlans.add(
            SearchWorkoutPlanModel(
              id: ele["_id"],
              name: ele["name"],
              daysInweek: ele["daysInweek"],
              validityInDays: ele["validityInDays"],
              description: ele["description"],
              goal: ele["goal"],
              level: ele["level"],
              userId: ele["userId"],
            ),
          );
        }
        return workoutPlans;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postWorkoutPlan(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}post/workoutPlan';

    log("post workout data $data");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log(responseData['message']);
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> postSetCurrentPlans(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}post/userWorkoutPlan';

    log("post workout data $data");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log(responseData['message']);
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> assignWorkoutPlan(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}wm/expert/assignWorkoutPlan';

    log("url assign workout $url");
    log("$data");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log(responseData['message']);
        Fluttertoast.showToast(msg: 'Workout plan assigned');
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteWorkoutPlan(String id) async {
    String url = '${ApiUrl.wm}delete/workoutPlan?id=$id';

    log("delte workout : $url");

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log(responseData['message']);
        Fluttertoast.showToast(msg: 'Workout plan deleted');
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> editWorkoutPlan(String id, Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}put/workoutPlan?id=$id';

    log("edit workout : $url");

    log("edit workout data $data");

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log(responseData['message']);
        Fluttertoast.showToast(msg: 'Workout plan updated');
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postWorkoutLog(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}user/storeWorkoutLog';

    log("post workout log : $url");
    log("post workout log data ${json.encode(data)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log(responseData['message']);
        final data = responseData["data"] as Map<String, dynamic>;
        return data;
        // Fluttertoast.showToast(msg: 'Workout');
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> purchaseWorkoutPlan(Map data) async {
    String url = '${ApiUrl.wm}user/purchaseWorkoutPlan';

    log("purchase workout  : $url");
    log("purchase workout data $data");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        log("purchase workout plan $responseData");
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log(responseData['message']);
        final data = responseData["data"] as Map<String, dynamic>;
        return data;
        // Fluttertoast.showToast(msg: 'Workout');
      } else {
        log("purchase workout plan $responseData");
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
