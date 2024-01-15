import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/create_diet_plan_models.dart';
import 'package:healthonify_mobile/models/wm/diet_plan_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/diet_plan_provider.dart';
import 'package:provider/provider.dart';

class DietFunc {
  Future<bool> postDietFunc(BuildContext context,
      {required CreateDietPlanModel dietPlanModel,
      required List<CreateDietDays> dietDays}) async {
    Map<String, dynamic> data = {};

    var userData = Provider.of<UserData>(context, listen: false).userData;
    String roleTitle = "userId";
    if (userData.roles![0]["name"] == "client") {
      roleTitle = "userId";
    } else {
      roleTitle = "expertId";
    }

    data = {
      roleTitle: userData.id, //userId or expertId
      "name": dietPlanModel.name,
      "type": roleTitle == "userId"
          ? "individual"
          : "paid", //individual or free or paid
      "level": dietPlanModel.level,
      "goal": dietPlanModel.goal,
      "planType": dietPlanModel.planType ?? "weekly",
      "validity": int.parse(dietPlanModel.validity ?? "0"),
      "note": dietPlanModel.note,
      "weeklyDetails": List.generate(
        dietDays.length,
        (index) {
          CreateDietDays dietDay = dietDays[index];
          return {
            "day": dietDay.day,
            "meals": List.generate(
              dietDay.meal!.length,
              (index) {
                Meal meal = dietDay.meal![index];
                return {
                  "mealOrder": index + 1,
                  "mealTime": meal.mealTime,
                  "mealName": meal.mealName,
                  "dishes": List.generate(
                    meal.dishes!.length,
                    (index) {
                      CreateDietDish dish = meal.dishes![index];
                      return {
                        "dishId": dish.dishId,
                        "unit": dish.unit,
                        "quantity": dish.quantity,
                        "alternateFood":
                            List.generate(dish.alternateFood!.length, (index) {
                          CreateDietDish alternateFood =
                              dish.alternateFood![index];
                          return {
                            "dishId": alternateFood.dishId,
                            "unit": alternateFood.unit,
                            "quantity": alternateFood.quantity
                          };
                        })
                      };
                    },
                  ),
                };
              },
            )
          };
        },
      ),
    };

    log(json.encode(data));

    try {
      await Provider.of<DietPlanProvider>(context, listen: false)
          .postDietPlan(data);
      return true;
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to save diet plan');
      return false;
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to save diet plan');
      return false;
    }
  }

  Future<bool> updateWorkoutPlan(BuildContext context,
      {required DietPlan dietPlanModel,
      required List<RegularDetail> dietDays}) async {
    Map<String, dynamic> data = {};

    var userData = Provider.of<UserData>(context, listen: false).userData;
    String roleTitle = "userId";
    if (userData.roles![0]["name"] == "client") {
      roleTitle = "userId";
    } else {
      roleTitle = "expertId";
    }

    data = {
      "set": {
        roleTitle: userData.id, //userId or expertId
        "name": dietPlanModel.name,
        "type": roleTitle == "userId"
            ? "individual"
            : "paid", //individual or free or paid
        "level": dietPlanModel.level,
        "goal": dietPlanModel.goal,
        "planType": dietPlanModel.planType ?? "weekly",
        "validity": dietPlanModel.validity ?? 0,
        "note": dietPlanModel.note,
        "weeklyDetails": List.generate(
          dietDays.length,
          (index) {
            RegularDetail dietDay = dietDays[index];
            return {
              "day": dietDay.day,
              "meals": List.generate(
                dietDay.meals!.length,
                (index) {
                  GetMeal meal = dietDay.meals![index];
                  return {
                    "mealOrder": index + 1,
                    "mealTime": meal.mealTime,
                    "mealName": meal.mealName,
                    "dishes": List.generate(
                      meal.dishes!.length,
                      (index) {
                        GetDish dish = meal.dishes![index];
                        return {
                          "dishId": dish.dishId!.id,
                          "unit": dish.unit,
                          "quantity": dish.quantity,
                          "alternateFood": List.generate(
                              dish.alternateFood == null
                                  ? 0
                                  : dish.alternateFood!.length, (index) {
                            GetDish alternateFood = dish.alternateFood![index];
                            return {
                              "dishId": alternateFood.dishId!.id,
                              "unit": alternateFood.unit,
                              "quantity": alternateFood.quantity
                            };
                          })
                        };
                      },
                    ),
                  };
                },
              )
            };
          },
        ),
      },
    };

    log(json.encode(data));

    try {
      await Provider.of<DietPlanProvider>(context, listen: false)
          .updateDietPlan(data, dietPlanModel.id!);
      return true;
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to update diet plan');
      return false;
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to update diet plan');
      return false;
    }
  }

  Future<bool> deleteDietPlan(BuildContext context, String dietPlanId) async {
    try {
      await Provider.of<DietPlanProvider>(context, listen: false)
          .deleteDietPlan(dietPlanId: dietPlanId);
      return true;
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to delete diet plan');
      return false;
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to delete diet plan');
      return false;
    }
  }
}
