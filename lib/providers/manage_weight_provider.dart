import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/health_care/health_care_plans/health_care_plans_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class ManageWeightPlansProvider with ChangeNotifier {
  Future<List<HealthCarePlansModel>> getManageWeightPlans() async {
    String url = "${ApiUrl.url}get/package?flow=manageWeight";
    List<HealthCarePlansModel> healthCarePlans = [];
    log("fetch hc plans url $url");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          healthCarePlans.add(
            HealthCarePlansModel(
              id: ele["_id"],
              bodyPart: List<dynamic>.from(ele["bodyPart"].map((x) => x)),
              healthCondition:
              List<dynamic>.from(ele["healthCondition"].map((x) => x)),
              name: ele["name"],
              description: ele["description"],
              benefits: ele["benefits"],
              price: ele["price"],
              sessionCount: ele["sessionCount"].toString(),
              flow: ele["flow"],
              isActive: ele["isActive"],
              // expertiseId: ele
              // ["expertiseId"],
              expertiseId: ele['expertiseId'] != null
                  ? ExpertiseId.fromJson(ele['expertiseId'])
                  : null,
              durationInDays: ele["durationInDays"],
              services: List<Service>.from(
                  ele["services"].map((x) => Service.fromJson(x))),
              createdAt: DateTime.parse(ele["created_at"]),
              updatedAt: DateTime.parse(ele["updated_at"]),
              v: ele["__v"],
            ),
          );
        }

        log('fetched all fitness plans');
        return healthCarePlans;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e,trace) {
      log(e.toString());
      log(trace.toString());
      rethrow;
    }
  }
}