import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/health_care/hc_consultations_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class HealthCareProvider with ChangeNotifier {
  Future<void> consultSpecialist(Map<String, dynamic> consultData) async {
    String url = "${ApiUrl.hc}user/consultNow";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(consultData),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        log(responseData['data'].toString());
      } else {
        throw HttpException(responseData["message"]);
      }
      // notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<HealthCareConsultations>> getUserConsultations(
      {required String data}) async {
    String url = '${ApiUrl.hc}get/hcConsultation?$data';

    final List<HealthCareConsultations> loadedData = [];

    log("hc consultation url $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        log(responseBody.toString());
        throw HttpException(responseBody["message"]);
      }
      if (responseBody["status"] == 1) {
        final responseData = json.decode(response.body)["data"];
        for (var element in responseData) {
          loadedData.add(
            HealthCareConsultations(
              id: element["_id"],
              expertiseId: List<ExpertiseId>.from(
                  element["expertiseId"].map((x) => ExpertiseId.fromJson(x))),
              startDate: element["startDate"],
              startTime: element["startTime"],
              userId:
                  List<Id>.from(element["userId"].map((x) => Id.fromJson(x))),
              description: element["description"],
              expertId: element["expertId"] == null
                  ? null
                  : List<Id>.from(
                      element["expertId"].map((x) => Id.fromJson(x))),
              startTimeMiliseconds: element["startTimeMiliseconds"],
              status: element["status"],
              meetingLink: element["meetingLink"],
              isActive: element["isActive"],
            ),
          );
        }
        return loadedData;
      } else {
        log(responseBody.toString());
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('error $e');
    }
  }

  Future<void> consultationRating(Map<String, dynamic> ratingData) async {
    String url = "${ApiUrl.hc}user/hcConsultationRating";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(ratingData),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        log(responseData['data'].toString());
      } else {
        throw HttpException(responseData["message"]);
      }
      // notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<HealthCarePrescription>> getHealthCarePrescription(
      String id) async {
    String url = '${ApiUrl.hc}get/hcPrescriptions?hcConsultationId=$id';

    final List<HealthCarePrescription> loadedData = [];

    log("hc prescription api: $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpException(responseBody["message"]);
      }
      if (responseBody["status"] == 1) {
        final responseData = json.decode(response.body)["data"];
        for (var element in responseData) {
          loadedData.add(
            HealthCarePrescription(
              healthCarePrescriptionUrl: element['prescriptionUrl'],
            ),
          );
        }
        return loadedData;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('error');
    }
  }
}
