import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/trackers/sleep_tracker.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/diet_plan_provider.dart';
import 'package:healthonify_mobile/providers/weight_management/workout_data.dart';
import 'package:provider/provider.dart';

class PlaceholderScreen extends StatefulWidget {
  const PlaceholderScreen({Key? key}) : super(key: key);

  @override
  State<PlaceholderScreen> createState() => _PlaceholderScreenState();
}

class _PlaceholderScreenState extends State<PlaceholderScreen> {
  Future<void> fetchWorkout(BuildContext context) async {
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      await Provider.of<WorkoutProvider>(context, listen: false)
          .getUserWorkoutPlan(userId);
      log('fetched workout details');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting workout details $e");
      Fluttertoast.showToast(msg: "Unable to fetch workout details");
    }
  }

  // Future<void> fetchDietPlan(BuildContext context) async {
  //   try {
  //     await Provider.of<DietPlanProvider>(context, listen: false)
  //         .getDietPlans();
  //     log('fetched diet details');
  //   } on HttpException catch (e) {
  //     log(e.toString());
  //     Fluttertoast.showToast(msg: e.message);
  //   } catch (e) {
  //     log("Error getting diet details $e");
  //     Fluttertoast.showToast(msg: "Unable to fetch diet details");
  //   }
  // }

  Map<String, dynamic> postData = {
    "name": "Core workout plan 15",
    "daysInweek": 4,
    "validityInDays": 30,
    "schedule": [
      {
        "day": "Abs",
        "exercises": [
          {
            "round": 1,
            "exerciseId": "629516d2bf56f94eecbfd022",
            "setTypeId": "6263b18af0bd9642f4193c2b",
            "bodyPartGroupId": "6263acca60f1c72b6c17e3a7",
            "note": "this is it",
            "sets": [
              {"weight": 20, "weightUnit": "KG", "reps": 12}
            ]
          }
        ],
        "note": "Good for core",
        "order": 1
      }
    ]
  };

  Map<String, dynamic> postDiet = {
    "name": "Simple Mini Plan 10",
    "planType": "regular",
    "validity": 90,
    "regularDetails": [
      {
        "mealOrder": 1,
        "mealTime": "6:30 A.M.",
        "dishes": [
          {"dishId": "62984403b3e6be2f74f981fd", "unit": "grams", "quantity": 1}
        ]
      }
    ],
    "expertId": "622b04f1e1d4c7398c170460"
  };

  Map<String, dynamic> sleepLog = {
    "userId": "627dffae862ba3a172f62929",
    "date": "2022-07-04",
    "sleepTime": "20:00:00",
    "wakeupTime": "06:00:00"
  };

  Map<String, dynamic> sleepGoal = {
    "set": {
      "sleepTime": "20:00:00",
      "wakeupTime": "06:00:00",
    }
  };

  Future<void> postWorkoutData(BuildContext context) async {
    try {
      await Provider.of<WorkoutProvider>(context, listen: false)
          .postWorkoutPlan(postData);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to post workout plan');
    }
  }

  Future<void> postDietplan(BuildContext context) async {
    try {
      await Provider.of<DietPlanProvider>(context, listen: false)
          .postDietPlan(postDiet);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to post diet plan');
    }
  }

  Future<void> postSleepLog(BuildContext context) async {
    try {
      await Provider.of<SleepTrackerProvider>(context, listen: false)
          .postSleepLogs(sleepLog);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to post sleep log');
    }
  }

  Future<void> facebookLogin() async {
    // final LoginResult result = await FacebookAuth.instance.login();
    // if (result.status == LoginStatus.success) {
    //   // you are logged
    //   // final AccessToken accessToken = result.accessToken!;
    //   await FacebookAuth.instance.getUserData().then((value) {
    //     log(value.toString());
    //   });
    // } else { 
    //   log("yes  ${result.status}");
    //   log("loool ${result.message}");
    // }
  }

  Future<void> putSleepGoal(BuildContext context) async {
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      await Provider.of<SleepTrackerProvider>(context, listen: false)
          .putSleepGoal(sleepGoal, userId);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to post sleep goal');
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithGoogle() async {
    GoogleSignInAccount? user = await _googleSignIn.signIn().then((userData) {
      log(userData.toString());
    }).catchError((e) {
      log(e.toString());
    });

    final GoogleSignInAuthentication? googleAuth = await user?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchWorkout(context),
        builder: (context, snapshot) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text('Placeholder text'),
            ),
            ElevatedButton(
              onPressed: () {
                postWorkoutData(context);
              },
              child: const Text('Post workout plan'),
            ),
            ElevatedButton(
              onPressed: () {
                // fetchDietPlan(context);
              },
              child: const Text('get diet plan'),
            ),
            ElevatedButton(
              onPressed: () {
                postDietplan(context);
              },
              child: const Text('post diet plan'),
            ),
            ElevatedButton(
              onPressed: () {
                postSleepLog(context);
              },
              child: const Text('post sleep log'),
            ),
            ElevatedButton(
              onPressed: () {
                putSleepGoal(context);
              },
              child: const Text('set & get sleep goal'),
            ),
            ElevatedButton(
              onPressed: () async {
                await signInWithGoogle();
              },
              child: const Text('facebook login'),
            ),
          ],
        ),
      ),
    );
  }
}
