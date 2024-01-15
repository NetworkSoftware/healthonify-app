import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/consultation.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class GetConsultation with ChangeNotifier {
  List<Consultation> _consultations = [];
  List<Consultation> get consultations {
    return [..._consultations];
  }

  Future<List<Consultation>> getConsultation(String? id, String page,String flow) async {
    String url = '${ApiUrl.url}get/consultation?$id&limit=20&page=$page&flow=$flow';

    List<Consultation> loadedData = [];

    log(url);

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
        final data = responseData['data'] as List<dynamic>;
        log(data.toString());

        for (var ele in data) {
          // log(ele.toString());
          if (ele["status"] == "initiated") {
            loadedData.add(
              Consultation(
                id: ele["_id"],
                expertiseId: ele["expertiseId"] != null
                    ? List<dynamic>.from(ele["expertiseId"].map((x) => x))
                    : [],
                user: List<dynamic>.from(data[0]["userId"].map((x) => x)),
                startTime: ele["time"],
                startDate: ele["date"],
                status: ele["status"],
              ),
            );
          } else {
            loadedData.add(
              Consultation(
                id: ele["_id"],
                expertiseId: ele["expertiseId"] != null
                    ? List<dynamic>.from(ele["expertiseId"].map((x) => x))
                    : [],
                expertId: ele["expertId"] as Map<String, dynamic>,
                startTime: ele["time"],
                user: List<dynamic>.from(data[0]["userId"].map((x) => x)),
                startDate: ele["date"],
                status: ele["status"] ?? "",
              ),
            );
          }
        }

        _consultations = loadedData;
        log("fetched consultation list");
        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  final ConsultationDetails _consultationDetails = ConsultationDetails();

  ConsultationDetails get consultationDetails {
    return _consultationDetails;
  }

  Future<void> getConsultationBasedOnId(String? id) async {
    String url = '${ApiUrl.url}get/consultation?id=$id';

    // log("Okay");

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
        final data = responseData['data'] as List<dynamic>;
        // log(data.toString());

        _consultationDetails.sendbirdChannelId = data[0]["channelId"] ?? "";
        _consultationDetails.meetingLink = data[0]["meetingLink"] ?? "";
        _consultationDetails.userId = data[0]["userId"][0]["_id"];
        _consultationDetails.user =
            List<dynamic>.from(data[0]["userId"].map((x) => x));
        _consultationDetails.expert = data[0]["userId"][0]["expertId"];

        // log(_consultationDetails.user.toString());

        log("fetched consultation details");
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
