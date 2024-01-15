import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/diet_plans/search_diet_plans_model.dart';
import 'package:healthonify_mobile/models/wm/diet_plan_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class DietPlanProvider with ChangeNotifier {
  Future<List<DietPlan>> getDietPlans(String data) async {
    String url = '${ApiUrl.wm}get/dietPlan$data';

    log("get diet plan url $url");

    List<DietPlan> dietPlans = [];

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
          dietPlans.add(DietPlan.fromJson(ele));
        }
        return dietPlans;
        // log(data.toString());
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e,trace) {
      print("Trace : $trace");
      rethrow;
    }
  }

  Future<List<SearchDietPlanModel>> searchDietPlans(String query) async {
    String url = '${ApiUrl.wm}search/dietPlan?query=$query';

    log("search diet plan url $url");

    List<SearchDietPlanModel> dietPlans = [];

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
          dietPlans.add(SearchDietPlanModel.fromJson(ele));
        }
        return dietPlans;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DietPlan>> getUserDietPlans(String data) async {
    String url = '${ApiUrl.wm}get/UserDietPlan$data';

    log("get user diet plan url $url");
    List<DietPlan> dietPlans = [];

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
          //var dietPlanId = ele["dietPlanId"];
          dietPlans.add(
            DietPlan(
              id: ele["dietPlanId"]["_id"],
              //expertId: ele["dietPlanId"]["expertId"]["_id"],
              name: ele["dietPlanId"]["name"],
              type: ele["dietPlanId"]["type"],
              level: ele["dietPlanId"]["level"],
              goal: ele["dietPlanId"]["goal"],
              planType: ele["dietPlanId"]["planType"],
              validity: ele["dietPlanId"]["validity"],
              note:ele["dietPlanId"]["note"],
              createdDate: ele["dietPlanId"]["created_at"],
              weeklyDetails: List<RegularDetail>.from(
                ele["dietPlanId"]["weeklyDetails"].map(
                  (x) => RegularDetail.fromJson(x),
                ),
              ),
            ),
          );
        }
        return dietPlans;
        // log(data.toString());
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e,trace) {
      print("Trace : $trace");
      rethrow;
    }
  }

  Future<void> postDietPlan(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}post/dietPlan';

    print("Url : $url");
    print("data : ${json.encode(data)}");

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
        Fluttertoast.showToast(msg: 'Diet plan saved');
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> addDietPlan(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}post/userDietPlan';

    print("Url : $url");
    print("data : ${json.encode(data)}");

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
        Fluttertoast.showToast(msg: 'Diet plan saved');
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> updateDietPlan(Map<String, dynamic> data, String id) async {
    String url = '${ApiUrl.wm}put/dietPlan?id=$id';

    log("update diet plan $url");

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      log(responseData.toString());

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        Fluttertoast.showToast(msg: 'Diet plan updated');
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteDietPlan({required String dietPlanId}) async {
    String url = '${ApiUrl.wm}delete/dietPlan?id=$dietPlanId';

    log("update diet plan $url");

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      log(responseData.toString());

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        Fluttertoast.showToast(msg: 'Diet plan deleted');
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> assignDietPlan(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}assignDietPlan';

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
        Fluttertoast.showToast(msg: 'Diet plan assigned');
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
