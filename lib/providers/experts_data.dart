import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/expert.dart';
import 'package:healthonify_mobile/models/health_care/health_care_expert/health_care_expert.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class ExpertsData with ChangeNotifier {
  List<Expert> _expertData = [];

  List<Expert> get expertData {
    return [..._expertData];
  }

  Future<void> fetchExpertsData(String id) async {
    String url =
        "${ApiUrl.url}get/user?expertise=$id&expert=1&isAdminApproved=true";
    final List<Expert> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as List<dynamic>;
        log("Fetched experts data");

        for (var element in responseData) {
          loadedData.add(Expert(
              id: element['_id'],
              firstName: element['firstName'],
              lastName: element['lastName'],
              consultaionCharge: element['consultationCharge'],
              imageUrl: element['imageUrl'] ?? ""));
        }
        _expertData = loadedData;
        log(_expertData[0].id.toString());
        log("Fetched experts data");

        // notifyListeners();
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Expert>> fetchHealthCareExperts() async {
    String url =
        "${ApiUrl.url}get/user?topExpertise=6343acb2f427d20b635ec853&isAdminApproved=true";

    print("Url : $url");

    final List<Expert> healthCareExperts = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as List<dynamic>;
        log("Fetched experts data");

        for (var element in responseData) {
          healthCareExperts.add(
            Expert(
              id: element['_id'],
              firstName: element['firstName'],
              lastName: element['lastName'],
              imageUrl: element['imageUrl'] ?? "",
            ),
          );
        }
        log("Fetched health care experts");
        return healthCareExperts;
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<HealthCareExpert>> fetchHealthCareExpertsData(String id) async {
    String url = "${ApiUrl.url}get/user?id=$id";

    log(url);

    final List<HealthCareExpert> healthCareExperts = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as List<dynamic>;
        log("Fetched experts data");

        for (var element in responseData) {
          healthCareExperts.add(
            HealthCareExpert(
              email: element["email"],
              topExpertiseId: element["topExpertise"]["_id"],
              topExpertiseName: element["topExpertise"]["name"],
              topExpertiseFlow: element["topExpertise"]["flowName"],
              firstName: element["firstName"],
              id: element["_id"],
              isVerified: element["isVerified"],
              lastName: element["lastName"],
              mobileNo: element["mobileNo"],
              city: element["city"],
              state: element["state"],
              about: element["about"],
              imageUrl: element["imageUrl"],
              certificates: element["certificates"],
            ),
          );
        }
        return healthCareExperts;
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
