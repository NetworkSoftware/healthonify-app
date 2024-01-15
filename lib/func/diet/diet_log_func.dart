import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/func/diet/meals_switch_case.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/diet_plan_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/diet_log_provider.dart';
import 'package:provider/provider.dart';

class DietLogFunc {
  Future<bool> getDietLogs(BuildContext context, {required String date}) async {
    try {
      var userId = Provider.of<UserData>(context, listen: false).userData.id!;

      await Provider.of<DietLogProvider>(context, listen: false)
          .getDietLogs(userId: userId, date: date);
      return true;
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Something went wrong');
      return false;
    } catch (e,trace) {
      log(e.toString());
      log(trace.toString());
      Fluttertoast.showToast(msg: 'No diet plans available');
      return false;
    }
  }

  Future<bool> postDietLog(
      BuildContext context, GetMeal meal, String date) async {
    String formattedDate = StringDateTimeFormat().stringtDateFormat2(date);
    var userId = Provider.of<UserData>(context, listen: false).userData.id!;
    Map<String, dynamic> data = {
      "date": formattedDate,
      "timeInMs": DateTime.now().millisecondsSinceEpoch,
      "mealName": MealSwitchCase().upperToLower(meal.mealName ?? ""),
      "userId": userId,
      "dishes": meal.dishes == null || meal.dishes!.isEmpty
          ? []
          : List.generate(
              meal.dishes!.length,
              (index) => {
                "dishId": meal.dishes![index].dishId!.id,
                "quantity": meal.dishes![index].quantity
              },
            ),
    };
    if (meal.id != null) {
      data["_id"] = meal.id;
    }
    log(
      json.encode(data),
    );
    try {
      await Provider.of<DietLogProvider>(context, listen: false)
          .postDietPlan(data);
      return true;
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Something went wrong');
      return false;
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'No diet plans available');
      return false;
    }
  }
}
